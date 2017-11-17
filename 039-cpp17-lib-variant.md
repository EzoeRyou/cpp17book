## variant : 型安全なunion

### 使い方

ヘッダーファイル`<variant>`で定義されている`variant`は、型安全な`union`として使うことができる。

~~~cpp
#include <variant>

int main()
{
    using namespace std::literals ;

    // int, double, std::stringのいずれかを格納するvariant
    // コンストラクターは最初の型をデフォルト構築
    std::variant< int, double, std::string > x ;

    x = 0 ;         // intを代入
    x = 0.0 ;       // doubleを代入
    x = "hello"s ;  // std::stringを代入

    // intが入っているか確認
    // falseを返す
    bool has_int = std::holds_alternative<int>( x ) ;
    // std::stringが入っているか確認
    // trueを返す
    bool has_string = std::holds_alternative<std::string> ( x ) ;

    // 入っている値を得る
    // "hello"
    std::string str = std::get<std::string>(x) ;
}
~~~

### 型非安全な古典的union

C++が従来から持っている古典的な`union`は、複数の型のいずれかひとつだけの値を格納する型だ。`union`のサイズはデータメンバーのいずれかの型をひとつ表現できるだけのサイズとなる。

~~~cpp
union U
{
    int i ;
    double d ;
    std::string s ;
} ;

struct S
{
    int i ;
    double d ;
    std::string s ;
}
~~~

この場合、`sizeof(U)`は

$$\texttt{sizeof(U)} = \max \{ \texttt{sizeof(int)}, \texttt{sizeof(double)}, \texttt{sizeof(std::string)} \} + \texttt{パディングなど}$$

になる。`sizeof(S)`は、

$$\texttt{sizeof(S)} = \texttt{sizeof(int)} + \texttt{sizeof(double)} + \texttt{sizeof(std::string)} + \texttt{パディングなど}$$

になる。



`union`はメモリ効率がよい。`union`は`variant`と違い型非安全だ。どの型の値を保持しているかという情報は保持しないので、利用者が適切に管理しなければならない。

試しに、冒頭のコードを`union`で書くと、以下のようになる。

~~~cpp
union U
{
    int i ;
    double d ;
    std::string s ;

    // コンストラクター
    // int型をデフォルト初期化する
    U() : i{} { }
    // デストラクター
    // 何もしない。オブジェクトの破棄は利用者の責任に任せる
    ~U() { }
} ;

// デストラクター呼び出し
template < typename T >
void destruct ( T & x )
{
    x.~T() ;
}

int main()
{
    U u ;

    // 基本型はそのまま代入できる
    // 破棄も考えなくて良い
    u.i = 0 ;
    u.d = 0.0 ;

    // 非トリビアルなコンストラクターを持つ型
    // placement newが必要
    new(&u.s) std::string("hello") ;

    // 利用者はどの型を入れたか別に管理しておく必要がある
    bool has_int = false ;
    bool has_string = true ;

    std::cout << u.s << '\n' ;

    // 非トリビアルなデストラクターを持つ型
    // 破棄が必要
    destruct( u.s ) ;
}
~~~

このようなコードは書きたくない。`variant`を使えば、このような面倒で冗長なコードを書かずに、型安全に`union`と同等機能を実現できる。

### variantの宣言

`variant`はテンプレート実引数で保持したい型を与える。

~~~cpp
std::variant< char, short, int, long > v1 ;
std::variant< int, double, std::string > v2 ;
std::variant< std::vector<int>, std::list<int> > v3 ;
~~~

### variantの初期化

#### デフォルト初期化

`variant`はデフォルト構築すると、最初に与えた型の値をデフォルト構築して保持する。

~~~cpp
// int
std::variant< int, double > v1 ;
// double
std::variant< double, int > v2 ;
~~~

`variant`にデフォルト構築できない型を最初に与えると、`variant`もデフォルト構築できない。

~~~c++
// デフォルト構築できない型
struct non_default_constructible
{
    non_default_constructible() = delete ;
} ;

// エラー
// デフォルト構築できない
std::variant< non_default_constructible > v ;
~~~


デフォルト構築できない型だけを保持する`variant`をデフォルト構築するためには、最初の型をデフォルト構築可能な型にすればよい。

~~~cpp
struct A { A() = delete ; } ;
struct B { B() = delete ; } ;
struct C { C() = delete ; } ;

struct Empty { } ;


int main()
{
    // OK、Emptyを保持
    std::variant< Empty, A, B, C > v ;
}
~~~

このような場合に、`Empty`のようなクラスをわざわざ独自に定義するのは面倒なので、標準ライブラリには`std::monostate`クラスが以下のように定義されている。

~~~c++
namespace std {
    struct monostate { } ;
}
~~~

したがって、上の例は以下のように書ける。

~~~cpp
// OK、std::monostateを保持
std::variant< std::monostate, A, B, C > v ;
~~~

`std::monostate`は`variant`の最初のテンプレート実引数として使うことで`variant`をデフォルト構築可能にするための型だ。それ以上の意味はない。

#### コピー初期化

`variant`に同じ型の`variant`を渡すと、コピー/ムーブする。

~~~cpp
int main()
{
    std::variant<int> a ;
    // コピー
    std::variant<int> b ( a ) ;
}
~~~

#### variantのコンストラクターに値を渡した場合

`variant`のコンストラクターに上記以外の値を渡した場合、`variant`のテンプレート実引数に指定した型の中から、オーバーロード解決により最適な型が選ばれ、その型の値に変換され、値を保持する。

~~~cpp
using val = std::variant< int, double, std::string > ;

int main()
{
    // int
    val a(42) ;
    // double
    val b( 0.0 ) ; 

    // std::string
    // char const *型はstd::string型に変換される
    val c("hello") ;

    // int
    // char型はIntegral promotionによりint型に優先的に変換される
    val d( 'a' ) ;
}
~~~

#### in_place_typeによるemplace構築

`variant`のコンストラクターの第一引数に`std::in_place_type<T>`を渡すことにより、`T`型の要素を構築するために`T`型のコンストラクターに渡す実引数を指定できる。

ほとんどの型はコピーかムーブができる。

~~~cpp
struct X
{
    X( int, int, int ) { }
} ;

int main()
{
    // Xを構築
    X x( a, b, c ) ;
    // xをコピー
    std::variant<X> v( x ) ;
}
~~~

しかし、もし型`X`がコピーもムーブもできない型だったとしたら、上記のコードは動かない。

~~~cpp
struct X
{
    X( int, int, int ) { }
    X( X const & ) = delete ;
    X( X && ) = delete ; 
} ;

int main()
{
    // Xを構築
    X x( 1, 2, 3 ) ;
    // エラー、Xはコピーできない
    std::variant<X> v( x ) ;
}
~~~

このような場合、`variant`が内部で`X`を構築する際に、構築に必要なコンストラクターの実引数を渡して、`variant`に`X`を構築させる必要がある。そのために`std::in_place_type<T>`が使える。`T`に構築したい型を指定して第一引数とし、第二引数以降を`T`のコンストラクターに渡す値にする。


~~~cpp
struct X
{
    X( int, int, int ) { }
    X( X const & ) = delete ;
    X( X && ) = delete ; 
} ;

int main()
{
    // Xの値を構築して保持
    std::variant<X> v( std::in_place_type<X>, 1, 2, 3 ) ;
}
~~~


### variantの破棄

`variant`のデストラクターは、そのときに保持している値を適切に破棄してくれる。

~~~cpp
int main()
{
    std::vector<int> v ;
    std::list<int> l ;
    std::deque<int> d ;
    std::variant< 
        std::vector<int>, 
        std::list<int>,
        std::deque<int>
    > val ;

    val = v ;
    val = l ;
    val = d ;

    // variantのデストラクターはdeque<int>を破棄する
}
~~~

`variant`のユーザーは何もする必要がない。


### variantの代入

`variant`の代入はとても自然だ。`variant`を渡せばコピーするし、値を渡せばオーバーロード解決に従って適切な型の値を保持する。

### variantのemplace

`variant`は`emplace`をサポートしている。`variant`の場合、構築すべき型を知らせる必要があるので、`emplace<T>`の`T`で構築すべき型を指定する。


~~~cpp
struct X
{
    X( int, int, int ) { }
    X( X const & ) = delete ;
    X( X && ) = delete ; 
} ;

int main()
{
    std::variant<std::monostate, X, std::string> v ;

    // Xを構築
    v.emplace<X>( 1, 2, 3 ) ;
    // std::stringを構築
    v.emplace< std::string >( "hello" ) ;
}
~~~

### variantに値が入っているかどうかの確認

#### valueless_by_exceptionメンバー関数

~~~c++
constexpr bool valueless_by_exception() const noexcept;
~~~

`valueless_by_exception`メンバー関数は、`variant`が値を保持している場合、`false`を返す。

~~~cpp
void f( std::variant<int> & v )
{

    if ( v.valueless_by_exception() ) 
    { // true
        // vは値を保持していない
    }
    else
    { // false
        // vは値を保持している
    }
}
~~~

`variant`はどの値も保持しない状態になることがある。例えば、`std::string`はコピーにあたって動的なメモリ確保を行うかもしれない。`variant`が`std::string`をコピーする際に、動的メモリ確保に失敗した場合、コピーは失敗する。なぜならば、`variant`は別の型の値を構築する前に、以前の値を破棄しなければならないからだ。`variant`は値を持たない状態になりうる。

~~~cpp
int main()
{
    std::variant< int, std::string > v ;
    try {
        std::string s("hello") ;
        v = s ; // 動的メモリ確保が発生するかもしれない
    } catch( std::bad_alloc e )
    {
        // 動的メモリ確保が失敗するかもしれない
    }

    // 動的メモリ確保の失敗により
    // trueになるかもしれない
    bool b = v.valueless_by_exception() ;
}
~~~

#### indexメンバー関数

~~~cpp
constexpr size_t index() const noexcept;
~~~

`index`メンバー関数は、`variant`に指定したテンプレート実引数のうち、現在`variant`が保持している値の型を0ベースのインデックスで返す。

~~~cpp
int main()
{
    std::variant< int, double, std::string > v ;

    auto v0 = v.index() ; // 0
    v = 0.0 ;
    auto v1 = v.index() ; // 1
    v = "hello" ;
    auto v2 = v.index() ; // 2
}
~~~

もし`variant`が値を保持しない場合、つまり`valueless_by_exception()`が`true`を返す場合は、`std::variant_npos`を返す。

~~~cpp
// variantが値を持っているかどうか確認する関数
template < typename ... Types  >
void has_value( std::variant< Types ... > && v )
{
    return v.index() != std::variant_npos ;

    // これでもいい
    // return v.valueless_by_exception() == false ;
}
~~~

`std::variant_npos`の値は$-1$だ。

### swap

`variant`は`swap`に対応している。

~~~cpp
int main()
{
    std::variant<int> a, b ;

    a.swap(b) ;
    std::swap( a, b ) ;
}
~~~

### variant_size\<T\> : variantが保持できる型の数を取得

`std::variant_size<T>`は、`T`に`variant`型を渡すと、`variant`が保持できる型の数を返してくれる。

~~~cpp
using t1 = std::variant<char> ;
using t2 = std::variant<char, short> ;
using t3 = std::variant<char, short, int> ;

// 1
constexpr std::size_t t1_size = std::variant_size<t1>::size ;
// 2
constexpr std::size_t t2_size = std::variant_size<t2>::size ;
// 3
constexpr std::size_t t2_size = std::variant_size<t3>::size ;
~~~

`variant_sizeはintegral_constant`を基本クラスに持つクラスなので、デフォルト構築した結果をユーザー定義変換することでも値を取り出せる。

~~~cpp
using type = std::variant<char, short, int> ;

constexpr std::size_t size = std::variant_size<type>{} ;
~~~

`variant_size`を以下のようにラップした変数テンプレートも用意されている。

~~~c++
template <class T>
    inline constexpr size_t variant_size_v = variant_size<T>::value;
~~~

これを使えば、以下のようにも書ける。

~~~cpp
using type = std::variant<char, short, int> ;

constexpr std::size_t size = std::variant_size_v<type> ;
~~~

### variant_alternative\<I, T\> : インデックスから型を返す

`std::variant_alternative<I, T>`は`T`型の`variant`の保持できる型のうち、`I`番目の型をネストされた型名`type`で返す。

~~~cpp
using type = std::variant< char, short, int > ;

// char
using t0 = std::variant_alternative< 0, type >::type ;
// short
using t1 = std::variant_alternative< 1, type >::type ;
// int
using t2 = std::variant_alternative< 2, type >::type ;
~~~

`variant_alternative_t`というテンプレートエイリアスが以下のように定義されている。

~~~c++
template <size_t I, class T>
    using variant_alternative_t 
        = typename variant_alternative<I, T>::type ;
~~~

これをつかえば、以下のようにも書ける。


~~~cpp
using type = std::variant< char, short, int > ;

// char
using t0 = std::variant_alternative_t< 0, type > ;
// short
using t1 = std::variant_alternative_t< 1, type > ;
// int
using t2 = std::variant_alternative_t< 2, type > ;
~~~

### holds_alternative : variantが指定した型の値を保持しているかどうかの確認

`holds_alternative<T>(v)`は、`variant v`が`T`型の値を保持しているかどうかを確認する。保持しているのであれば`true`を、そうでなければ`false`を返す。

~~~cpp
int main()
{
    // int型の値を構築
    std::variant< int, double > v ;

    // true
    bool has_int = std::holds_alternative<int>(v) ;
    // false
    bool has_double = std::holds_alternative<double>(v) ;
}
~~~

型`T`は実引数に与えられた`variant`が保持できる型でなければならない。以下のようなコードはエラーとなる。


~~~c++
int main()
{
    std::variant< int > v ;

    // エラー
    std::holds_alternative<double>(v) ;
}
~~~

### get\<I\>(v) : インデックスから値の取得

`get<I>(v)`は、`variant v`の型のインデックスから`I`番目の型の値を返す。インデックスは0ベースだ。

~~~cpp
int main()
{
    // 0: int
    // 1: double
    // 2: std::string
    std::variant< int, double, std::string > v(42) ;

    // int, 42
    auto a = std::get<0>(v) ;

    v = 3.14 ;
    // double, 3.14
    auto b = std::get<1>(v) ;

    v = "hello" ;
    // std::string, "hello"
    auto c = std::get<2>(v) ;
}
~~~

`I`がインデックスの範囲を超えているとエラーとなる。

~~~c++
int main()
{
    // インデックスは0, 1, 2まで
    std::variant< int, double, std::string > v ;

    // エラー、範囲外
    std::get<3>(v) ;
}
~~~

もし、`variant`が値を保持していない場合、つまり`v.index() != I`の場合は、`std::bad_variant_access`が`throw`される。

~~~cpp
int main()
{
    // int型の値を保持
    std::variant< int, double > v( 42 ) ;

    try {
        // double型の値を要求
        auto d = std::get<1>(v) ;
    } catch ( std::bad_variant_access & e )
    {
        // doubleは保持していなかった
    }
}
~~~

`get`の実引数に渡す`variant`が`lvalue`の場合は、戻り値は`lvalue`リファレンス、`rvalue`の場合は戻り値は`rvalue`リファレンスになる。

~~~cpp
int main()
{
    std::variant< int > v ;

    // int &
    decltype(auto) a = std::get<0>(v) ;
    // int &&
    decltype(auto) b = std::get<0>( std::move(v) ) ;
}
~~~

`get`の実引数に渡す`variant`がCV修飾されている場合、戻り値の型も実引数と同じくCV修飾される。

~~~cpp
int main()
{
    std::variant< int > const cv ;
    std::variant< int > volatile vv ;
    std::variant< int > const volatile cvv ;

    // int const &
    decltype(auto) a = std::get<0>( cv ) ;
    // int volatile &
    decltype(auto) b = std::get<0>( vv ) ;
    // int const volatile &
    decltype(auto) c = std::get<0>( cvv ) ;
}
~~~

### get\<T\>(v) : 型から値の取得

`get<T>(v)`は、`variant v`の保有する型`T`の値を返す。型`T`の値を保持していない場合、`std::bad_variant_access`が`throw`される。

~~~cpp
int main()
{
    std::variant< int, double, std::string > v( 42 ) ;

    // int
    auto a = std::get<int>( v ) ;

    v = 3.14 ;
    // double
    auto b = std::get<double>( v ) ;

    v = "hello" ;
    // std::string
    auto c = std::get<std::string>( v ) ;
}
~~~

その他はすべて`get<I>`と同じ。

### get_if : 値を保持している場合に取得

`get_if<I>(vp)`と`get_if<T>(vp)`は、`variant`へのポインター`vp`を実引数にとり、`*vp`がインデックス`I`、もしくは型`T`の値を保持している場合、その値へのポインターを返す。

~~~cpp
int main()
{
    std::variant< int, double, std::string > v( 42 ) ;

    // int *
    auto a = std::get_if<int>( &v ) ; 

    v = 3.14 ;
    // double *
    auto b = std::get_if<1>( &v ) ;

    v = "hello" ;
    // std::string
    auto c = std::get_if<2>( &v ) ;

}
~~~

もし、`vp`が`nullptr`の場合、もしくは`*vp`が指定された値を保持していない場合は、`nullptr`を返す。

~~~cpp
int main()
{
    // int型の値を保持
    std::variant< int, double > v( 42 ) ;

    // nullptr
    auto a = std::get_if<int>( nullptr ) ;

    // nullptr
    auto a = std::get_if<double>( &v ) ;
}
~~~

### variantの比較

`variant`は比較演算子がオーバーロードされているため比較できる。`variant`同士の比較は、一般のプログラマーは自然だと思う結果になるように実装されている。

#### 同一性の比較

`variant`の同一性の比較のためには、`variant`のテンプレート実引数に与える型は自分自身と比較可能でなければならない。

つまり、`variant v`, `w`に対して、式`get<i>(v) == get<i>(w)`がすべての`i`に対して妥当でなければならない。

`variant v`, `w`の同一性の比較は、`v == w`の場合、以下のように行われる。

1. `v.index() != w.index()`ならば、`false`
2. それ以外の場合、`v.value_less_by_exception()`ならば、`true`
3. それ以外の場合、`get<i>(v) == get<i>(w)`。ただし`i`は`v.index()`

二つの`variant`が別の型を保持している場合は等しくない。ともに値なしの状態であれば等しい。それ以外は保持している値同士が比較される。

~~~cpp
int main()
{
    std::variant< int, double > a(0), b(0) ;

    // true
    // 同じ型の同じ値を保持している
    a == b ;

    a = 1.0 ;

    // false
    // 型が違う
    a == b ;
}
~~~

例えば`operator ==`は以下のような実装になる。

~~~c++
template <class... Types>
constexpr bool 
operator == (const variant<Types...>& v, const variant<Types...>& w)
{
    if ( v.index() != w.index() )
        return false ;
    else if ( v.valueless_by_exception() )
        return true ;
    else
        return std::visit( 
            []( auto && a, auto && b ){ return a == b ; },
            v, w ) ;
}
~~~

`operator !=`はこの逆だと考えてよい。

#### 大小比較


`variant`の大小の比較のためには、`variant`のテンプレート実引数に与える型は自分自身と比較可能でなければならない。


つまり、`operator <`の場合、`variant v`, `w`に対して、式`get<i>(v) < get<i>(w)`がすべての`i`に対して妥当でなければならない。


`variant v`, `w`の大小比較は、`v < w`の場合、以下のように行われる。

1. `w.valueless_by_exception()`ならば、`false`
2. それ以外の場合、`v.valueless_by_exception()`ならば、`true`
3. それ以外の場合、`v.index() < w.index()`ならば、`true`
4. それ以外の場合、`v.index() > w.index()`ならば、`false`
5. それ以外の場合、`get<i>(v) < get<i>(w)`。ただし`i`は`v.index()`

値なしの`variant`は最も小さいとみなされる。インデックスの小さいほうが小さいとみなされる。どちらも同じ型の値があるのであれば、値同士の比較となる。

~~~cpp
int main()
{
    std::variant< int, double > a(0), b(0) ;

    // false
    // 同じ型の同じ値を比較
    a < b ;

    a = 1.0 ;

    // false
    // インデックスによる比較
    a < b ;
    // true
    // インデックスによる比較
    b < a ;
}
~~~

`operator <`は以下のような実装になる。

~~~c++
template <class... Types>
constexpr bool 
operator<(const variant<Types...>& v, const variant<Types...>& w)
{
    if ( w.valueless_by_exception() )
        return false ;
    else if ( v.valueless_by_exception() )
        return true ;
    else if ( v.index() < w.index() )
        return true ;
    else if ( v.index() > w.index() )
        return false ;
    else
        return std::visit( 
            []( auto && a, auto && b ){ return a < b ; },
            v, w ) ;
}
~~~

残りの大小比較も同じ方法で比較される。

### visit : variantが保持している値を受け取る。

`std::visit`は、`variant`の保持している型を実引数に関数オブジェクトを呼んでくれるライブラリだ。

~~~cpp
int main()
{
    using val = std::variant<int, double> ;

    val v(42) ;
    val w(3.14) ;

    auto visitor =  []( auto a, auto b ) 
                    { std::cout << a << b << '\n' ; } ;

    // visitor( 42, 3.14 )が呼ばれる
    std::visit( visitor, v, w ) ;
    // visitor( 3.14, 42 ) が呼ばれる
    std::visit( visitor, w, v ) ;
}
~~~

このように、`variant`にどの型の値が保持されていても扱うことができる。

`std::visit`は以下のように宣言されている。

~~~c++
template < class Visitor, class... Variants >
constexpr auto visit( Visitor&& vis, Variants&&... vars ) ;
~~~

第一引数に関数オブジェクトを渡し、第二引数以降に`variant`を渡す。すると、`vis( get<i>(vars)... )`のように呼ばれる。

~~~cpp
int main()
{
    std::variant<int> a(1), b(2), c(3) ;

    // ( 1 ) 
    std::visit( []( auto x ) {}, a ) ;

    // ( 1, 2, 3 )
    std::visit( []( auto x, auto y, auto z ) {}, a, b, c ) ;
}
~~~


