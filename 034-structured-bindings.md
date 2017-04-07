## 構造化束縛

C++17で追加された構造化束縛は多値を分解して受け取るための変数宣言の文法だ。

~~~cpp
int main()
{
    int a[] = { 1,2,3 } ;
    auto [a,b,c] = a ;

    // a == 1
    // b == 2
    // c == 3
}
~~~


C++では、様々な方法で多値を扱うことができる。例えば配列、クラス、tuple, pairだ。

~~~cpp
int a[] = { 1,2,3 } ;
struct B
{
    int a ;
    double b ;
    std::string c ;
} ;

B b{ 1, 2.0, "hello"} ;

std::tuple<int, double, std::string> c { 1, 2.0, "hello" } ;

std::pair< int, int> d{ 1, 2 } ;
~~~


C++の関数は配列以外の多値を返すことができる。

~~~cpp
std::tuple< int, double, std::string > f()
{
    return { 1, 2.0, "hello" } ;
}
~~~

多値を受け取るには、これまでは多値を塊として受け取るか、ライブラリで分解して受け取るしかなかった。

多値を塊で受け取るには以下のように書く。

~~~cpp
std::tuple< int, double, std::string > f()
{
    return { 1, 2.0, "hello" } ;
}

int main()
{
    auto result = f() ;
    
    std::cout << std::get<0>(result) << '\n' 
        << std::get<1>(result) << '\n'
        << std::get<2>(result) << std::endl ;
}
~~~

多値をライブラリで受け取るには以下のように書く。

~~~cpp
std::tuple< int, double, std::string > f()
{
    return { 1, 2.0, "hello" } ;
}

int main()
{
    int a ;
    double b ;
    std::string c ;

    std::tie(a, b, c ) = f() ;
    
    std::cout << a << '\n' 
        << b << '\n'
        << c << std::endl ;
}
~~~

構造化束縛を使うと、以下のように書ける。

~~~cpp
std::tuple< int, double, std::string > f()
{
    return { 1, 2.0, "hello" } ;
}

int main()
{
    auto [a, b, c] = f() ;
    
    std::cout << a << '\n' 
        << b << '\n'
        << c << std::endl ;
}
~~~

変数の型はそれぞれ対応する多値の型になる。この場合、a, b, cはそれぞれint, double, std::string型になる。

tupleだけではなく、pairも使える。

~~~cpp
int main()
{
    std::pair<int, int> p( 1, 2 ) ;

    auto [a,b] = p ;

    // aはint型、値は1
    // bはint型、値は2
}
~~~

構造化束縛はif文とswitch文、for文でも使える。

~~~cpp
int main()
{
    int expr[] = {1,2,3} ;

    if ( auto[a,b,c] = expr ; a )
    { }
    switch( auto[a,b,c] = expr ; a )
    { }
    for ( auto[a,b,c] = expr ; false ; ) 
    { }
}
~~~

構造化束縛はrange-based for文にも使える。

~~~cpp
int main()
{
    std::map< std::string, std::string > translation_table
    {
        {"dog", "犬"},
        {"cat", "猫"},
        {"answer", "42"} 
    } ;
    
    for ( auto [key, value] : translation_table )
    {
        std::cout<<
            "key="<< key <<
            ", value=" << value << '\n' ;
    }
}
~~~

これは、mapの要素型std::pair\<const std::string, std::string\>を構造化束縛[key, value]で受けている。

構造化束縛は配列にも使える。

~~~cpp
int main()
{
    int values[] = {1,2,3} ;
    auto [a,b,c] = values ;
}
~~~

構造化束縛はクラスにも使える。

~~~cpp
struct Values
{
    int a ;
    double d ;
    std::string c ;
} ;

int main()
{
    Values values{ 1, 2.0, "hello"} ;

    auto [a,b,c] = values ;
}
~~~

構造化束縛でクラスを使う場合は、非staticデータメンバーはすべてひとつのクラスのpublicなメンバーでなければならない。

構造化束縛はconstexprにはできない。

~~~c++
int main()
{
    int expr[] = { 1,2 } ;

    // エラー
    constexpr auto [a,b] = expr ;
}
~~~


### 超上級者向け解説

構造化束縛は、変数の宣言のうち、**構造化束縛宣言(structured binding declaration)**に分類される文法で記述する。構造化束縛宣言となる宣言は、単純宣言(simple-declaration)とfor-range宣言(for-range-declaration)のうち、[識別子リスト]があるものだ。

~~~c++
単純宣言:
    属性 auto CV修飾子(省略可) リファレンス修飾子(省略可) [ 識別子リスト ] 初期化子 ;

for-range宣言:
    属性 auto CV修飾子(省略可) リファレンス修飾子(省略可) [ 識別子リスト ] ;

識別子リスト:
    コンマで区切られた識別子

初期化子:
    = 式
    { 式 }
    ( 式 )
~~~


以下は単純宣言のコード例だ。

~~~cpp
int main()
{
    int e1[] = {1,2,3} ;
    struct { int a,b,c ; } e2{1,2,3} ;
    auto e3 = std::make_tuple(1,2,3) ;
    
    // "= 式"の例
    auto [a,b,c] = e1 ;
    auto [d,e,f] = e2 ;
    auto [g,h,i] = e3 ;
    
    // "{式}", "(式)"の例
    auto [j,k,l]{e1} ;
    auto [m,n,o](e1) ;

    // CV修飾子とリファレンス修飾子を使う例
    auto const & [p,q,r] = e1 ;
}
~~~

以下はfor-range宣言の例だ。

~~~cpp
int main()
{
    std::pair<int, int> pairs[] = { {1,2}, {3,4}, {5,6}} ;
    
    for ( auto [a, b] : pairs )
    {
        std::cout << a << ", " << b << '\n' ;
    }
}
~~~

### 構造化束縛宣言の仕様

構造化束縛の構造化束縛宣言は以下のように解釈される。

構造化束縛宣言によって宣言される変数の数は、初期化子の多値の数と一致していなければならない。

~~~c++
int main()
{
    // 2個の値を持つ
    int expr[] = {1,2} ;

    // エラー、変数が少なすぎる
    auto[a] = expr ; 
    // エラー、変数が多すぎる
    auto[b,c,d] = expr ;
}
~~~

構造化束縛宣言で宣言されるそれぞれの変数名について、記述された通りの属性、CV修飾子、リファレンス修飾子の変数が宣言される。

### 初期化子の型が配列の場合

初期化子が配列の場合、それぞれの変数はそれぞれの配列の要素で初期化される。

リファレンス修飾子がない場合、それぞれの変数はコピー初期化される。

~~~cpp
int main()
{
    int expr[3] = {1,2,3} ;
    auto [a,b,c] = expr ;
}
~~~

これは、以下と同じ意味になる。

~~~cpp
int main()
{

    int expr[3] = {1,2,3} ;

    int a = expr[0] ;
    int b = expr[1] ;
    int c = expr[2] ;
}
~~~

リファレンス修飾子がある場合、変数はリファレンスとなる。

~~~cpp
int main()
{
    int expr[3] = {1,2,3} ;
    auto & [a,b,c] = expr ;
    auto && [d,e,f] = expr ;
}
~~~

これは、以下と同じ意味になる。

~~~cpp
int main()
{
    int expr[3] = {1,2,3} ;

    int & a = expr[0] ;
    int & b = expr[1] ;
    int & c = expr[2] ;

    int && d = expr[0] ;
    int && e = expr[1] ;
    int && f = expr[2] ;
}
~~~

もし、変数の型が配列の場合、配列の要素はそれぞれ対応する配列の要素で初期化される。

~~~cpp
int main()
{
    int expr[][2] = {{1,2},{1,2}} ;
    auto [a,b] = expr ;
}
~~~

これは、以下と同じ意味になる。

~~~cpp
int main()
{
    int expr[][2] = {{1,2},{1,2}} ;

    int a[2] = { expr[0][0], expr[0][1] } ;
    int b[2] = { expr[1][0], expr[1][1] } ;    
}
~~~

### 初期化子の型が配列ではなく、std::tuple_size\<E\>が完全形の名前である場合

構造化束縛宣言の初期化子の型Eが配列ではない場合で、std::tuple_size\<E\>が完全形の名前である場合、

構造化束縛宣言の初期化子の型をE、その値をeとする。構造化束縛宣言で宣言されるひとつ目の変数を0, ふたつ目の変数を1...とインクリメントされていくインデックスをiとする。


std::tuple_size\<E\>::valueは整数のコンパイル時定数式で、その値は初期化子の値の数でなければならない。

~~~cpp
int main()
{
    // std::tuple< int, int, int >
    auto e = std::make_tuple( 1, 2, 3 ) ;
    auto [a,b,c] = e ;

    // std::tuple_size<decltype(e)>::sizeは3
}
~~~~

それぞれの値を取得するために、非修飾名getが型Eのクラススコープから探される。getが見つかった場合、それぞれの変数の初期化子はe.get\<i\>()となる。



~~~c++
auto [a,b,c] = e ;
~~~~

という構造化束縛宣言は、以下の意味になる。

~~~c++
type a = e.get<0>() ;
type b = e.get<1>() ;
type c = e.get<2>() ;
~~~

そのようなgetの宣言が見つからない場合、初期化子はget\<i\>(e)となる。この場合、getは連想名前空間から探される。通常の非修飾名前検索は行われない。

~~~c++
// ただし通常の非修飾名前検索は行われない。
type a = get<0>(e) ;
type b = get<1>(e) ;
type c = get<2>(e) ;
~~~

構造化束縛宣言で宣言される変数の型は以下のように決定される。

変数の型typeは"std::tuple_element\<i, E\>::type"となる。

~~~c++
std::tuple_element<0, E>::type a = get<0>(e) ;
std::tuple_element<1, E>::type b = get<1>(e) ;
std::tuple_element<2, E>::type c = get<2>(e) ;
~~~

以下のコードは、

~~~cpp
int main()
{
    auto e = std::make_tuple( 1, 2, 3 ) ;
    auto [a,b,c] = e ;
}
~~~~

以下とほぼ同等の意味になる。

~~~cpp
int main()
{
    auto e = std::make_tuple( 1, 2, 3 ) ;
    
    using E = decltype(e) ;

    std::tuple_element<0, E >::type & a = std::get<0>(e) ;
    std::tuple_element<1, E >::type & b = std::get<1>(e) ;
    std::tuple_element<2, E >::type & c = std::get<2>(e) ;
}
~~~~


以下のコードは、

~~~cpp
int main()
{
    auto e = std::make_tuple( 1, 2, 3 ) ;
    auto && [a,b,c] = std::move(e) ;
}
~~~~

以下のような意味になる。

~~~cpp
int main()
{
    auto e = std::make_tuple( 1, 2, 3 ) ;
    
    using E = decltype(e) ;

    std::tuple_element<0, E >::type && a = std::get<0>(std::move(e)) ;
    std::tuple_element<1, E >::type && b = std::get<1>(std::move(e)) ;
    std::tuple_element<2, E >::type && c = std::get<2>(std::move(e)) ;
}
~~~~

### 上記以外の場合

上記以外の場合、構造化束縛宣言の初期化子の型Eはクラス型で、すべての非staticデータメンバーはpublicの直接のメンバーであるか、あるいは単一の曖昧ではないpublic基本クラスのメンバーである必要がある。Eに匿名unionメンバーがあってはならない。

以下は型Eとして適切なクラスの例である

~~~c++
struct A
{
    int a, b, c ;
} ;

struct B : A { } ;
~~~

以下は型Eとして不適切なクラスの例である。

~~~c++
// public以外の非staticデータメンバーがある
struct A
{
public :
    int a ;
private :
    int b ;
} ;



struct B
{
    int a ;
} ;
// クラスにも基本クラスにも非staticデータメンバーがある。
struct C : B
{
    int b ;
} ;

// 匿名unionメンバーがある
struct D
{
    union
    {
        int i ;
        double d ;
    }
} ;
~~~


型Eの非staticデータメンバーは宣言された順番で多値として認識される。

以下のコードは、

~~~cpp
int main()
{
    struct { int x, y, z ; } e{1,2,3} ;

    auto [a,b,c] = e ;
}
~~~

以下のコードと意味的に等しい。


~~~cpp
int main()
{
    struct { int x, y, z ; } e{1,2,3} ;

    int a = e.x ;
    int b = e.y ;
    int c = e.z ;
}
~~~

構造化束縛はビットフィールドに対応している。

~~~cpp
struct S
{
    int x : 2 ;
    int y : 4 ;
} ;

int main()
{
    S e{1,3} ; ;
    auto [a,b] = e ;
}
~~~

機能テストマクロは__cpp_structured_bindings, 値は201606。
