## make_from_tuple : tupleの要素を実引数にコンストラクターを呼び出す

`make_from_tuple`はヘッダーファイル`<tuple>`で定義されている。

~~~c++
template <class T, class Tuple>
constexpr T make_from_tuple(Tuple&& t);
~~~

`apply`は`tuple`の要素を実引数に関数を呼び出すライブラリだが、`make_from_tuple`は`tuple`の要素を実引数にコンストラクターを呼び出すライブラリだ。

ある型`T`と要素数`N`の`tuple t`に対して、`make_from_tuple<T>(t)`は、`T`型を`T( get<0>(t), get<1>(t), ... , get<N-1>(t) )`のように構築して、構築した`T`型のオブジェクトを返す。

~~~cpp
class X
{
    template < typename ... Types >
    T( Types ... ) { }
} ;

int main()
{
    // int, int, int
    std::tuple t1(1,2,3) ;

    // X(1,2,3)
    X x1 = std::make_from_tuple<X>( t1 ) 

    // int, double, const char *
    std::tuple t2( 123, 4.56, "hello" ) ;

    // X(123, 4.56, "hello")
    X x2 = std::make_from_tuple<X>( t2 ) ;
}
~~~
