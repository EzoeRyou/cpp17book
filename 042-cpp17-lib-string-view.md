# string_view : 文字列ラッパー

`string_view`は、文字型（`char`, `wchar_t`, `char16_t`, `char32_t`）の連続した配列で表現された文字列に対する共通の文字列ビューを提供する。文字列は所有しない。

## 使い方

連続した文字型の配列を使った文字列の表現方法にはさまざまある。C++では最も基本的な文字列の表現方法として、`null`終端された文字型の配列がある。

~~~c++
char str[6] = { 'h', 'e', 'l', 'l', 'o', '\0' } ;
~~~

あるいは、文字型の配列と文字数で表現することもある。

~~~c++
// sizeは文字数
std::size_t size
char * ptr ;
~~~

このような表現をいちいち管理するのは面倒なので、クラスで包むこともある。

~~~c++
class string_type
{
    std::size_t size ;
    char *ptr
} ;
~~~

このように文字列を表現する方法はさまざまある。これらのすべてに対応していると、表現の数だけ関数のオーバーロードが追加されていくことになる。

~~~c++
// null終端文字列用
void process_string( char * ptr ) ;
// 配列へのポインターと文字数
void process_string( char * ptr, std::size_t size ) ;
// std::stringクラス
void process_string( std::string s ) ;
// 自作のstring_typeクラス
void process_string( string_type s ) ;
// 自作のmy_string_typeクラス
void process_string( my_string_type s ) ;
~~~

`string_view`はさまざまな表現の文字列に対して共通の`view`を提供することで、この問題を解決できる。もう関数のオーバーロードを大量に追加する必要はない。

~~~c++
// 自作のstring_type
struct string_type
{
    std::size_t size ;
    char * ptr ;

    // string_viewに対応する変換関数
    operator std::string_view() const noexcept
    {
        return std::string_view( ptr, size ) ;
    }
}

// これ1つだけでよい
void process_string( std::string_view s ) ;

int main()
{
    // OK
    process_string( "hello" ) ;
    // OK
    process_string( { "hello", 5 } ) ;

    std::string str( "hello" ) ;
    process_string( str ) ;

    string_type st{5, "hello"} ;

    process_string( st ) ;
}
~~~


## basic_string_view

`std::stringがstd::basic_string< CharT, Traits >`に対する`std::basic_string<char>`であるように、`std::string_view`も、その実態は`std::basic_string_view`の特殊化への`typedef`名だ。

~~~c++
// 本体
template<class charT, class traits = char_traits<charT>>
class basic_string_view ;

// それぞれの文字型のtypedef名
using string_view = basic_string_view<char>;
using u16string_view = basic_string_view<char16_t>;
using u32string_view = basic_string_view<char32_t>;
using wstring_view = basic_string_view<wchar_t>;
~~~


なので、通常は`basic_string_view`ではなく、`string_view`とか`u16string_view`などの`typedef`名を使うことになる。本書では`string_view`だけを解説するが、その他の`typedef`名も文字型が違うだけで同じだ。



## 文字列の所有、非所有

`string_view`は文字列を所有しない。所有というのは、文字列を表現するストレージの確保と破棄に責任を持つということだ。所有しないことの意味を説明するために、まず文字列を所有するライブラリについて説明する。


`std::string`は文字列を所有する。`std::string`風のクラスの実装は、たとえば以下のようになる。


~~~cpp
class string
{
    std::size_t size ;
    char * ptr ;

public :
    // 文字列を表現するストレージの動的確保
    string ( char const * str )
    {
        size = std::strlen( str ) ;
        ptr = new char[size+1] ;
        std::strcpy( ptr, str ) ;
    }

    // コピー
    // 別のストレージを動的確保
    string ( string const & r )
        : size( r.size ), ptr ( new char[size+1] )
    {
        std::strcpy( ptr, r.ptr ) ;
    }

    // ムーブ
    // 所有権の移動
    string ( string && r )
        : size( r.size ), ptr( r.ptr )
    {
        r.size = 0 ;
        r.ptr = nullptr ;
    }

    // 破棄
    // 動的確保したストレージを解放
    ~string()
    {
        delete[] ptr ;
    }
    
} ;
~~~

`std::string`は文字列を表現するストレージを動的に確保し、所有する。コピーは別のストレージを確保する。ムーブするときはストレージの所有権を移す。デストラクターは所有しているストレージを破棄する。

`std::string_view`は文字列を所有しない。`std::string_view`風のクラスの実装は、たとえば以下のようになる。

~~~cpp
class string_view
{
    std::size_t size ;
    char const * ptr ;

public :

    // 所有しない
    // strの参照先の寿命は呼び出し側が責任を持つ
    string_view( char const * str ) noexcept
        : size( std::strlen(str) ), ptr( str )
    { }

    // コピー
    // メンバーごとのコピーだけでよいのでdefault化するだけでよい
    string_view( string_view const & r ) noexcept = default ;

    // ムーブはコピーと同じ
    // 所有しないので所有権の移動もない

    // 破棄
    // 何も解放するストレージはない
    // デストラクターもトリビアルでよい
} ;
~~~

`string_view`に渡した連続した文字型の配列へのポインターの寿命は、渡した側が責任を持つ。つまり、以下のようなコードは間違っている。

~~~cpp
std::string_view get_string()
{
    char str[] = "hello" ;

    // エラー
    // strの寿命は関数の呼び出し元に戻った時点で尽きている
    return str ;
}
~~~

## string_viewの構築
`string_view`の構築には4種類ある。

+ デフォルト構築
+ `null`終端された文字型の配列へのポインター
+ 文字型の配列へのポインターと文字数
+ 文字列クラスからの変換関数

### デフォルト構築

~~~c++
constexpr basic_string_view() noexcept;
~~~

`string_view`のデフォルト構築は、空の`string_view`を作る。

~~~cpp
int main()
{
    // 空のstring_view
    std::string_view s ;
}
~~~

### null終端された文字型の配列へのポインター

~~~c++
constexpr basic_string_view(const charT* str);
~~~

この`string_view`のコンストラクターは、`null`終端された文字型へのポインターを受け取る。

~~~cpp
int main()
{
    std::string_view s( "hello" ) ;
}
~~~

### 文字型へのポインターと文字数

~~~c++
constexpr basic_string_view(const charT* str, size_type len);
~~~

この`string_view`のコンストラクターは、文字型の配列へのポインターと文字数を受け取る。ポインターは`null`終端されていなくてもよい。


~~~c++
int main()
{
    char str[] = {'h', 'e', 'l', 'l', 'o'} ;

    std::string_view s( str, 5 ) ;
}
~~~

## 文字列クラスからの変換関数

他の文字列クラスから`string_view`を作るには、変換関数を使う。`string_view`のコンストラクターは使わない。

`std::string`は`string_view`への変換関数をサポートしている。独自の文字列クラスを`string_view`に対応させるにも変換関数を使う。たとえば以下のように実装する。

~~~c++
class string
{
    std::size_t size ;
    char * ptr ;
public :
    operator std::string_view() const noexcept
    {
        return std::string_view( ptr, size ) ;
    }
} ;
~~~

これにより、`std::string`から`string_view`への変換が可能になる。

~~~cpp
int main()
{
    std::string s = "hello" ;
    std::string_view sv = s ;
}
~~~

コレと同じ方法を使えば、独自の文字列クラスも`string_view`に対応させることができる。

`std::string`は`string_view`を受け取るコンストラクターを持っているので、`string_view`から`string`への変換もできる。

~~~cpp
int main()
{
    std::string_view sv = "hello" ;

    // コピーされる
    std::string s = sv ;
}
~~~


## string_viewの操作

`string_view`は既存の標準ライブラリの`string`とほぼ同じ操作性を提供している。たとえばイテレーターを取ることができるし、`operator []`で要素にアクセスできるし、`size()`で要素数が返るし、`find()`で検索もできる。

~~~cpp
template < typename T >
void f( T  t )
{
    for ( auto c : t )
    {
        std::cout << c ;
    }

    if ( t.size() > 3 )
    {
        auto c = t[3] ;
    }

    auto pos = t.find( "fox" ) ;
}

int main()
{
    std::string s("quick brown fox jumps over the lazy dog.") ;

    f( s ) ;

    std::string_view sv = s ;

    f( sv ) ;
}
~~~

`string_view`は文字列を所有しないので、文字列を書き換える方法を提供していない。

~~~c++
int main()
{
    std::string s = "hello" ;

    s[0] = 'H' ;
    s += ",world" ;

    std::string_view sv = s ;

    // エラー
    // string_viewは書き換えられない
    sv[0] = 'h' ;
    s += ".\n" ;
}
~~~

`string_view`は文字列を所有せず、ただ参照しているだけだからだ。

~~~cpp
int main()
{
    std::string s = "hello" ;
    std::string_view sv = s ;

    // "hello"
    std::cout << sv ;

    s = "world" ;

    // "world"
    // string_viewは参照しているだけ
    std::cout << sv ;
}
~~~

`string_view`は`string`とほぼ互換性のあるメンバーを持っているが、一部の文字列を変更するメンバーは削除されている。

### remove_prefix/remove_suffix : 先頭、末尾の要素の削除

`string_view`は先頭と末尾から`n`個の要素を削除するメンバー関数を提供している。

~~~c++
constexpr void remove_prefix(size_type n);
constexpr void remove_suffix(size_type n);
~~~

`string_view`にとって、先頭と末尾から`n`個の要素を削除するのは、ポインターを`n`個ずらすだけなので、これは文字列を所有しない`string_view`でも行える操作だ。

~~~cpp
int main()
{
    std::string s = "hello" ;

    std::string_view s1 = s ;

    // "lo"
    s1.remove_prefix(3) ;

    std::string_view s2 = s ;

    // "he"
    s2.remove_suffix(3) ;
}
~~~

このメンバー関数は既存の`std::string`にも追加されている。

## ユーザー定義リテラル

`std::string`と`std::string_view`にはユーザー定義リテラルが追加されている。

~~~c++
string operator""s(const char* str, size_t len);
u16string operator""s(const char16_t* str, size_t len);
u32string operator""s(const char32_t* str, size_t len);
wstring operator""s(const wchar_t* str, size_t len);

constexpr string_view
operator""sv(const char* str, size_t len) noexcept;

constexpr u16string_view
operator""sv(const char16_t* str, size_t len) noexcept;

constexpr u32string_view
operator""sv(const char32_t* str, size_t len) noexcept;

constexpr wstring_view
operator""sv(const wchar_t* str, size_t len) noexcept;
~~~

以下のように使う。

~~~cpp
int main()
{
    using namespace std::literals ;

    // std::string
    auto s = "hello"s ;

    // std::string_view
    auto sv = "hello"sv ;
}
~~~


