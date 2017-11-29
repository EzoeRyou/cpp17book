## クラステンプレートのコンストラクターからの実引数推定

C++17ではクラステンプレートのコンストラクターの実引数からテンプレート実引数の推定が行えるようになった。

~~~cpp
template < typename T >
struct X
{
    X( T t ) { }
} ;

int main()
{
    X x1(0) ; // X<int>
    X x2(0.0) ; // X<double>
    X x3("hello") ; // X<char const *>
}
~~~

これは関数テンプレートが実引数からテンプレート実引数の推定が行えるのと同じだ。

~~~cpp
template < typename T >
void f( T t ) { }

int main()
{
    f( 0 ) ; // f<int>
    f( 0.0 ) ; // f<double>
    f( "hello" ) ; // f<char const *>
}
~~~



### 推定ガイド

クラステンプレートのコンストラクターからの実引数は便利だが、クラスのコンストラクターはクラステンプレートのテンプレートパラメーターに一致しない場合もある。そのような場合はそのままでは実引数推定ができない。

~~~cpp
// コンテナー風のクラス
template < typename T >
class Container
{
    std::vector<T> c ;
public :
    // 初期化にイテレーターのペアを取る
    // IteratorはTではない
    // Tは推定できない
    template < typename Iterator >
    Container( Iterator first, Iterator last )
        : c( first, last )
    { }
} ;


int main()
{
    int a[] = { 1,2,3,4,5 } ;

    // エラー
    // Tを推定できない
    Container c( std::begin(a), std::end(a) ) ;
}
~~~

このため、C++17には推定ガイドという機能が提供されている。

~~~c++
テンプレート名( 引数リスト ) -> テンプレートid ;
~~~

これを使うと、以下のように書ける。

~~~c++
template < typename Iterator >
Container( Iterator, Iterator )
-> Container< typename std::iterator_traits< Iterator >::value_type > ;
~~~

C++コンパイラーはこの推定ガイドを使って、`Container<T>::Container(Iterator, Iterator)`からは、`T`を`std::iterator_traits<Iterator>::value_type`として推定すればいいのだと判断できる。

たとえば、初期化リストに対応するには以下のように書く。

~~~cpp
template < typename T >
class Container
{
    std::vector<T> c ;
public :

    Container( std::initializer_list<T> init )
        : c( init )
    { }
} ;


template < typename T >
Container( std::initializer_list<T> ) -> Container<T> ;


int main()
{
    Container c = { 1,2,3,4,5 } ;
}
~~~

C++コンパイラーはこの推定ガイドから、`Container<T>::Container( std::initializer_list<T> )`の場合は`T`を`T`として推定すればよいことがわかる。

機能テストマクロは`__cpp_deduction_guides`, 値は201606。
