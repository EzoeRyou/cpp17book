## 変数テンプレート版のtraits

C++17では、既存のtraitsに変数テンプレートを利用した_v版が追加された。

例えば、is_integral\<T\>::valueと書く代わりにis_integral_v\<T\>と書くことができる。

~~~cpp
template < typename T >
void f( T x )
{
    constexpr bool b1 = std::is_integral<T>::value ; // データメンバー
    constexpr bool b2 = std::is_integral_v<T> ; // 変数テンプレート
    constexpr bool b3 = std::is_integral<T>{} ; // operator bool()
}
~~~
