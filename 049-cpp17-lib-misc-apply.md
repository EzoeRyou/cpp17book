## apply: tupleの要素を実引数に関数を呼び出す

~~~c++
template <class F, class Tuple>
constexpr decltype(auto) apply(F&& f, Tuple&& t);
~~~

`std::apply`は`tuple`のそれぞれの要素を順番に実引数に渡して関数を呼び出すヘルパー関数だ。

ある要素数`N`の`tuple t`と関数オブジェクト`f`に対して、`apply( f, t )`は、`f( get<0>(t), get<1>(t), ... , get<N-1>(t) )`のように`f`を関数呼び出しする。

__例__

~~~cpp
template < typename ... Types >
void f( Types ... args ) { }

int main()
{
    // int, int, int
    std::tuple t1( 1,2,3 ) ;

    // f( 1, 2, 3 )の関数呼び出し
    std::apply( f, t1 ) ;

    // int, double, const char *
    std::tuple t2( 123, 4.56, "hello" ) ;

    // f( 123, 4.56, "hello" )の関数呼び出し
    std::apply( f, t2 ) ;
}
~~~
