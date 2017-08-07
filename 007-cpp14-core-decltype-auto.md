## decltype(auto): 厳格なauto

警告：この項目はC++規格の詳細な知識を解説しているため極めて難解になっている。平均的なC++プログラマーはこの知識を得てもよりよいコードが書けるようにはならない。この項目は読み飛ばすべきである。

decltype(auto)はauto指定子の代わりに使える厳格なautoだ。利用にはC++の規格の厳格な理解が求められる。

autoとdecltype(auto)は型指定子と呼ばれる文法の一種で、プレイスホルダー型として使う。

わかりやすく言うと、具体的な型を式から決定する機能だ。

~~~cpp
// aはint
auto a = 0 ;
// bはint 
auto b() { return 0 ; } 
~~~

変数宣言にプレイスホルダー型を使う場合、型を決定するための式は初期化子と呼ばれる部分に書かれる式を使う。関数の戻り値の型推定にプレイスホルダー型を使う場合、return文の式を使う。

decltype(auto)はautoの代わりに使うことができる。delctype(auto)も型を式から決定する。

~~~cpp
// aはint
decltype(auto) a = 0 ;
// bはint
decltype(auto) b() { return 0 ; }
~~~

一見するとautoとdecltype(auto)は同じようだ。しかし、この2つは式から型を決定する方法が違う。どちらもC++の規格の極めて難しい規則に基づいて決定される。習得には熟練の魔法使いであることが要求される。

autoが式から型を決定するには、autoキーワードをテンプレートパラメーター名で置き換えた関数テンプレートの仮引数に、式を実引数として渡してテンプレート実引数推定を行わせた場合に推定される型が使われる。

例えば

~~~c++
auto x = 0 ;
~~~

の場合は、

~~~c++
template < typename T >
void f( T u ) ;
~~~

のような関数テンプレートに対して、

~~~c++
f(0) ;
~~~

と実引数を渡した時にuの型として推定される型と同じ型になる。

~~~c++
int i ;
auto const * x = &i ;
~~~

の場合には、

~~~c++
template < typename T >
void f( T const * u ) ;
~~~

のような関数テンプレートに

~~~c++
f(&i) ;
~~~

と実引数を渡した時にuの型として推定される型と同じ型になる。この場合はint const *になる。

ここまでがautoの説明だ。decltype(auto)の説明は簡単だ。

decltype(auto)の型は、autoを式で置き換えたdecltypeの型になる。

~~~c++
// int
decltype(auto) a = 0 ;

// int
decltype(auto) f() { return 0 ; }
~~~

上のコードは、下のコードと同じ意味だ。

~~~c++
decltype(0) a = 0 ;
decltype(0) f() { return 0 ; }
~~~

ここまでは簡単だ。そして、これ以降は黒魔術のようなC++の規格の知識が必要になってくる。

autoとdecltype(auto)は一見すると同じように見える。型を決定する方法として、autoは関数テンプレートの実引数推定を使い、decltype(auto)はdecltypeを使う。どちらも式を評価した結果の型になる。一体何が違うというのか。

主な違いは、autoは関数呼び出しを使うということだ。関数呼び出しの際には様々な暗黙の型変換が行われる。

例えば、配列を関数に渡すと、暗黙の型変換の結果、配列の先頭要素へのポインターになる。

~~~cpp
template < typename T >
void f( T u ) {}

int main()
{
    int array[5] ;
    // Tはint *
    f( array ) ;
}
~~~

ではautoとdecltype(auto)を使うとどうなるのか。

~~~c++
int array[5] ;
// int *
auto x1 = array ;
// エラー、配列は配列で初期化できない
decltype(auto) x2 = array ;
~~~

このコードは、以下と同じ意味になる。

~~~c++
int array[5] ;
// int *
int * x1 = array ;
// エラー、配列は配列で初期化できない
int x2[5] = array ;
~~~

autoの場合、型はint *となる。配列は配列の先頭要素へのポインターへと暗黙に変換できるので、結果のコードは正しい。

decltype(auto)の場合、型はint [5]となる。配列は配列で初期化、代入ができないので、このコードはエラーになる。

関数型も暗黙の型変換により関数へのポインター型になる。

~~~c++
void f() ;

// 型はvoid(*)()
auto x1 = f ;
// エラー、関数型は変数にできない
decltype(auto) x2 = f ;
~~~

autoはトップレベルのリファレンス修飾子を消すが、decltype(auto)は保持する。

~~~cpp
int & f()
{
    static int x ;
    return x ;
}

int main()
{
    // int
    auto x1 = f() ;
    // int &
    decltype(auto) x2 = f() ;
}
~~~

リスト初期化はautoではstd::initializer_listだが、decltype(auto)では式ではないためエラー

~~~c++
int main()
{
    // std::initializer_list<int>
    auto x1 = { 1,2,3 } ;
    // エラー、decltype({1,2,3})はできない
    decltype(auto) x2 = { 1,2,3 } ;
}
~~~

decltype(auto)は単体で使わなければならない。

~~~c+
// OK
auto const x1 = 0 ; 
// エラー
decltype(auto) const x2 = 0 ;
~~~

この他にもautoとdecltype(auto)には様々な違いがある。すべての違いを列挙するのは煩雑なので省略するが、decltype(auto)は式の型を直接使う。autoは大抵の場合は便利な型の変換が入る。

autoは便利で大抵の場合はうまく行くが暗黙の型の変換が入るため、意図通りの推定をしてくれないことがある。

例えば、引数でリファレンスを受け取り、戻り値でそのリファレンスを返す関数を書くとする。以下のように書くのは間違いだ。

~~~cpp
// int ( int & )
auto f( int & ref )
{ return ref ; }
~~~

なぜならば、戻り値の型は式の型から変化してintになってしまうからだ。ここでdecltype(auto)を使うと、

~~~cpp
// int & ( int & )
decltype(auto) f( int & ref )
{ return ref ; }
~~~

式の型をそのまま使ってくれる。

ラムダ式にdelctype(auto)を使う場合は以下のように書く。

~~~c++
[]() -> decltype(auto) { return 0 ; } ;
~~~

decltype(auto)は主に関数の戻り地の型推定で式の型をそのまま推定してくれるようにするために追加された機能だ。その利用にはC++の型システムの深い理解が必要になる。

機能テストマクロは__cpp_decltype_auto, 値は201304。
