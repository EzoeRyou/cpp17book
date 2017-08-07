## constexprラムダ式

C++17ではラムダ式がconstexprになった。より正確に説明すると、ラムダ式のクロージャーオブジェクトのoperator ()は条件を満たす場合constexprになる。

~~~cpp
int main()
{
    auto f = []{ return 42 ; } ;

    constexpr int value = f() ; // OK
}
~~~

constexprの条件を満たすラムダ式はコンパイル時定数を必要とする場所で使うことができる。例えばconstexpr変数や配列の添字やstatic_assertなどだ。

~~~cpp
int main()
{
    auto f = []{ return 42 ; } ;

    int a[f()] ;
    static_assert( f() == 42 ) ;
    std::array<int, f()> b ;
}
~~~

constexprの条件を満たすのであれば、キャプチャーもできる。

~~~c++
int main()
{
    int a = 0 ; // 実行時の値
    constexpr int b = 0 ; // コンパイル時定数 

    auto f = [=]{ return a ; } ;
    auto g = [=]{ return b ; } ;

    // エラー、constexprの条件を満たさない
    constexpr int c = f() ;

    // Ok、constexprの条件を満たす
    constexpr int d = g() ;
}
~~~


機能テストマクロは__cpp_constexpr, 値は201603。

__cpp_constexprマクロの値は、C++11の時点で200704、C++14の時点で201304だ。
