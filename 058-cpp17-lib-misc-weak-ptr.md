## shared_ptr::weak_type

C++17では`shared_ptr`に`weak_type`というネストされた型名が追加された。これは`shared_ptr`に対する`weak_ptr`の`typedef`名となっている。

~~~c++
namespace std {

template < typename T >
class shared_ptr
{
    using weak_type = weak_ptr<T> ;
} ;

}
~~~

使い方。

~~~cpp
template < typename Shared_ptr >
void f( Shared_ptr sptr )
{
    // C++14
    auto wptr1 = std::weak_ptr<
                    typename Shared_ptr::element_type
                >( sptr ) ;

    // C++17
    auto wptr2 = typename Shared_ptr::weak_type( sptr ) ;
}
~~~
