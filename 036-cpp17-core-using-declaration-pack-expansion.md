## 可変長using宣言

この機能は超上級者向けだ。

C++17では`using`宣言をコンマで区切ることができるようになった。

~~~cpp
int x, y ;

int main()
{
    using ::x, ::y ;
}
~~~

これは、C++14で

~~~c++
using ::x ;
using ::y ;
~~~

と書くのと等しい。

C++17では、`using`宣言でパック展開ができるようになった。この機能に正式な名前は付いていないが、可変長`using`宣言（Variadic using declaration）と呼ぶのがわかりやすい。


~~~cpp
template < typename ... Types >
struct S : Types ...
{
    using Types::operator() ... ;
    void operator () ( long ) { }
} ;


struct A
{
    void operator () ( int ) { }
} ;

struct B
{
    void operator () ( double ) { }
} ;

int main()
{
    S<A, B> s ;
    s(0) ; // A::operator()
    s(0L) ; // S::operator()
    s(0.0) ; // B::operator()
}
~~~

機能テストマクロは`__cpp_variadic_using`, 値は201611。
