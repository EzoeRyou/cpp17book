## apply: tupleの要素を実引数に関数を呼び出す

~~~c++
template <class F, class Tuple>
constexpr decltype(auto) apply(F&& f, Tuple&& t);
~~~

std::applyはtupleのそれぞれの要素を順番に実引数に渡して関数を呼び出すヘルパー関数だ。

ある要素数Nのtuple tと関数オブジェクトfに対して、apply( f, t )は、f( get<0>(t), get<1>(t), ... , get<N>(t) )のようにfを関数呼び出しする。

例

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
