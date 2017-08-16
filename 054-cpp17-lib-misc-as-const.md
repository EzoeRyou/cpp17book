## as_const: const性の付与

以下のような関数テンプレートstd::as_constが追加される。

~~~c++
template <class T> constexpr add_const_t<T>& as_const(T& t) noexcept
{
    return t ;
}
~~~

as_constは引数として渡したlvalueリファレンスをconstなlvalueリファレンスにキャストする関数だ。const性を付与する手軽なヘルパー関数として使うことができる。

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
