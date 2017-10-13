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

    // OK、constexprの条件を満たす
    constexpr int d = g() ;
}
~~~

以下の内容は上級者向けの解説であり、通常の読者は理解する必要がない。

constexprラムダ式はSFINAEの文脈で使うことができない。

~~~c++
// エラー
template < typename T,
    bool b = []{
        T t ;
        t.func() ;
        return true ;
    }() ; >
void f()
{
    T t ;
    t.func() ;
}
~~~

なぜならば、これを許してしまうとテンプレート仮引数に対して任意の式や文がテンプレートのSubstitutionに失敗するかどうかをチェックできてしまうからだ。

上級者向けの解説終わり。

機能テストマクロは__cpp_constexpr, 値は201603。

__cpp_constexprマクロの値は、C++11の時点で200704、C++14の時点で201304だ。
