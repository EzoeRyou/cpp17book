## 変数テンプレート

変数テンプレートとは変数宣言をテンプレート宣言にできる機能だ。

~~~cpp
template < typename T >
T variable { } ;

int main()
{
    variable<int> = 42 ;
    variable<double> = 1.0 ;
}
~~~

これだけではわからないだろうから、順を追って説明する。

C++ではクラスを宣言できる。

~~~cpp
class X
{
    int member ;
} ;
~~~

C++ではクラスをテンプレート宣言できる。型テンプレートパラメーターは型として使える。


~~~cpp
template < typename T >
class X
{
public :
    T member ;
} ;

int main()
{
    X<int> i ;
    i.member = 42 ; // int

    X<double> d ;
    d.member = 1.0 ; // double
}
~~~

C++では関数を宣言できる。

~~~cpp
int f( int x )
{ return x ; }
~~~

C++では関数をテンプレート宣言できる。型テンプレートパラメーターは型として使える。


~~~cpp
template < typename T >
T f( T x )
{ return x ; }

int main()
{
    auto i = f( 42 ) ; // int
    auto d = f( 1.0 ) ; // double
}
~~~

C++11では`typedef`名を宣言するためにエイリアス宣言ができる。


~~~cpp
using type = int ;
~~~

C++11ではエイリアス宣言をテンプレート宣言できる。型テンプレートパラメーターは型として使える。

~~~cpp
template < typename T >
using type = T ;

int main()
{
    type<int> i = 42 ; // int
    type<double> d = 1.0 ; // double
}
~~~

そろそろパターンが見えてきたのではないだろうか。C++では一部の宣言はテンプレート宣言できるということだ。このパターンを踏まえて以下を考えてみよう。


C++では変数を宣言できる。

~~~cpp
int variable{} ;
~~~

C++14では変数宣言をテンプレート宣言できる。型テンプレートパラメーターは型として使える。

~~~cpp
template < typename T >
T variable { } ;

int main()
{
    variable<int> = 42 ;
    variable<double> = 1.0 ;
}
~~~


変数テンプレートは名前どおり変数宣言をテンプレート宣言できる機能だ。変数テンプレートはテンプレート宣言なので、名前空間スコープとクラススコープの中にしか書くことができない。

~~~cpp
// これはグローバル名前空間スコープという特別な名前空間スコープ

namespace ns {
// 名前空間スコープ
}

class
{
// クラススコープ
} ;
~~~

変数テンプレートの使い道は主に2つある。


### 意味は同じだが型が違う定数

プログラムでマジックナンバーを変数化しておくのは良い作法であるとされている。たとえば円周率を`3.14...`などと書くよりも`pi`という変数名で扱ったほうがわかりやすい。変数化すると、円周率の値が後で変わったときにプログラムを変更するのも楽になる。


~~~cpp
constexpr double pi = 3.1415926535 ;
~~~

しかし、円周率を表現する型が複数ある場合どうすればいいのか。よくあるのは名前を分ける方法だ。

~~~c++
constexpr float pi_f = 3.1415 ;
constexpr double pi_d = 3.1415926535 ;
constexpr int pi_i = 3 ;
// 任意の精度の実数を表現できるクラスとする
const Real pi_r("3. 141592653589793238462643383279") ;
~~~

しかしこれは、使う側で型によって名前を変えなければならない。


~~~c++
// 円の面積を計算する関数
template < typename T >
T calc_area( T r )
{
    // Tの型によって使うべき名前が変わる
    return r * r * ??? ;
}
~~~

関数テンプレートを使うという手がある。


~~~c++
template < typename T >
constexpr T pi()
{
    return static_cast<T>(3.1415926535) ;
}

template < >
Real pi()
{
    return Real("3. 141592653589793238462643383279") ;
}


template < typename T >
T calc_area( T r )
{
    return r * r * pi<T>() ;
}
~~~

しかし、この場合引数は何もないのに関数呼び出しのための`()`が必要だ。

変数テンプレートを使うと以下のように書ける。


~~~c++
template < typename T >
constexpr T pi = static_cast<T>(3.1415926535) ;

template < >
Real pi<Real>("3. 141592653589793238462643383279") ;

template < typename T >
T calc_area( T r )
{
    return r * r * pi<T> ;
}
~~~


### traitsのラッパー

値を返す`traits`で値を得るには`::value`と書かなければならない。

~~~cpp
std::is_pointer<int>::value ;
std::is_same< int, int >::value ;
~~~

C++14では`std::integral_constant`に`constexpr operator bool`が追加されたので、以下のようにも書ける。

~~~cpp
std::is_pointer<int>{} ;
std::is_same< int, int >{} ;
~~~

しかしまだ面倒だ。変数テンプレートを使うと`traits`の記述が楽になる。

~~~c++
template < typename T >
constexpr bool is_pointer_v = std::is_pointer<T>::value ;
template < typename T, typename U >
constexpr bool is_same_v = std::is_same<T, U>::value ;

is_pointer_v<int> ;
is_same_v< int, int > ;
~~~

C++の標準ライブラリでは従来の`traits`ライブラリを変数テンプレートでラップした`_v`版を用意している。

機能テストマクロは`__cpp_variable_templates`, 値は201304。
