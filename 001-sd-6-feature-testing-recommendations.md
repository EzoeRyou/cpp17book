# SD-6 C++のための機能テスト推奨

C++17には機能テストのためのCプリプロセッサー機能が追加された。

## 機能テストマクロ

機能テストというのは、C++の実装（C++コンパイラー）が特定の機能をサポートしているかどうかをコンパイル時に判断できる機能だ。本来、C++17の規格に準拠したC++実装は、C++17の機能をすべてサポートしているべきだ。しかし、残念ながら現実のC++コンパイラーの開発はそのようには行われていない。C++17に対応途中のC++コンパイラーは将来的にはすべての機能を実装することを目標としつつも、現時点では一部の機能しか実装していないという状態になる。

たとえば、C++11で追加された`rvalue`リファレンスという機能に現実のC++コンパイラーが対応しているかどうかをコンパイル時に判定するコードは以下のようになる。

~~~cpp
#ifndef __USE_RVALUE_REFERENCES
  #if (__GNUC__ > 4 || __GNUC__ == 4 && __GNUC_MINOR__ >= 3) || \
      _MSC_VER >= 1600
    #if __EDG_VERSION__ > 0
      #define __USE_RVALUE_REFERENCES (__EDG_VERSION__ >= 410)
    #else
      #define __USE_RVALUE_REFERENCES 1
    #endif
  #elif __clang__
    #define __USE_RVALUE_REFERENCES __has_feature(cxx_rvalue_references)
  #else
    #define __USE_RVALUE_REFERENCES 0
  #endif
#endif
~~~

このそびえ立つクソのようなコードは現実に書かれている。このコードはGCCとMSVCとEDGとClangという現実に使われている主要な4つのC++コンパイラーに対応した`rvalue`リファレンスが実装されているかどうかを判定する機能テストコードだ。

この複雑なプリプロセッサーを解釈した結果、`__USE_RVALUE_REFERENCES`というプリプロセッサーマクロの値が、もしC++コンパイラーが`rvalue`リファレンスをサポートしているならば1、そうでなければ0となる。後は、このプリプロセッサーマクロで`#if`ガードしたコードを書く。

~~~cpp
// 文字列を処理する関数
void process_string( std::string const & str ) ;

#if __USE_RVALUE_REFERENCES == 1
// 文字列をムーブして処理してよい実装の関数
// C++コンパイラーがrvalueリファレンスを実装していない場合はコンパイルされない
void process_string( std::string && str ) ;
#endif
~~~

C++17では、上のようなそびえ立つクソのようなコードを書かなくてもすむように、標準の機能テストマクロが用意された。C++実装が特定の機能をサポートしている場合、対応する機能テストマクロが定義される。機能テストマクロの値は、その機能がC++標準に採択された年と月を合わせた6桁の整数で表現される。

たとえば`rvalue`リファレンスの場合、機能テストマクロの名前は`__cpp_rvalue_references`となっている。`rvalue`リファレンスは2006年10月に採択されたので、機能テストマクロの値は200610という値になっている。将来`rvalue`リファレンスの機能が変更されたときは機能テストマクロの値も変更される。この値を調べることによって使っているC++コンパイラーはいつの時代のC++標準の機能をサポートしているか調べることもできる。

この機能テストマクロを使うと、上のコードの判定は以下のように書ける。


~~~cpp
// 文字列を処理する関数
void process_string( std::string const & str ) ;

#ifdef __cpp_rvalue_references
// 文字列をムーブして処理してよい実装の関数
// C++コンパイラーがrvalueリファレンスを実装していない場合はコンパイルされない
void process_string( std::string && str ) ;
#endif
~~~

機能テストマクロの値は通常は気にする必要がない。機能テストマクロが存在するかどうかで機能の有無を確認できるので、通常は`#ifdef`を使えばよい。


## __has_include式 : ヘッダーファイルの存在を判定する

`__has_include`式は、ヘッダーファイルが存在するかどうかを調べるための機能だ。

~~~c++
__has_include( ヘッダー名 )
~~~

`__has_include`式はヘッダー名が存在する場合1に、存在しない場合0に置換される。


たとえば、C++17の標準ライブラリにはファイルシステムが入る。そのヘッダー名は`<filesystem>`だ。C++コンパイラーがファイルシステムライブラリをサポートしているかどうかを調べるには、以下のように書く。


~~~cpp
#if __has_include(<filesystem>) 
// ファイルシステムをサポートしている
#include <filesystem>
namespace fs = std::filesystem ;
#else
// 実験的な実装を使う
#include <experimental/filesystem>
namespace fs = std::experimental::filesystem ;
#endif
~~~


C++実装が`__has_include`をサポートしているかどうかは、`__has_include`の存在をプリプロセッサーマクロのように`#ifdef`で調べることによって判定できる。

~~~cpp
#ifdef __has_include
// __has_includeをサポートしている
#else
// __has_includeをサポートしていない
#endif
~~~

`__has_include`式は`#if`と`#elif`の中でしか使えない。

~~~c++
int main()
{
    // エラー
    if ( __has_include(<vector>) )
    { }
}
~~~

## __has_cpp_attribute式

C++実装が特定の属性トークンをサポートしているかどうかを調べるには、`__has_cpp_attribute`式が使える。

~~~c++
__has_cpp_attribute( 属性トークン )
~~~

`__has_cpp_attribute`式は、属性トークンが存在する場合は属性トークンが標準規格に採択された年と月を表す数値に、存在しない場合は0に置換される。

~~~cpp
// [[nodiscard]]がサポートされている場合は使う
#if __has_cpp_attribute(nodiscard)
[[nodiscard]]
#endif
void * allocate_memory( std::size_t size ) ;
~~~

`__has_include`式と同じく、`__has_cpp_attribute`式も`#if`か`#elif`の中でしか使えない。`#ifdef`で`__has_cpp_attribute`式の存在の有無を判定できる。

