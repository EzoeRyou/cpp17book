## as_const: const性の付与

`as_const`はヘッダーファイル`<utility>`で定義されている。

~~~c++
template <class T> constexpr add_const_t<T>& as_const(T& t) noexcept
{
    return t ;
}
~~~

`as_const`は引数として渡した`lvalue`リファレンスを`const`な`lvalue`リファレンスにキャストする関数だ。`const`性を付与する手軽なヘルパー関数として使うことができる。

~~~cpp
// 1
template < typename T >
void f( T & ) {}
// 2、こちらを呼び出したい
template < typename T >
void f( T const & ) { }

int main()
{
    int x{} ;

    f(x) ; // 1

    // constを付与する冗長な方法
    int const & ref = x ;
    f(ref) ; // 2

    // 簡潔
    f( std::as_const(x) ) ; // 2
}
~~~
