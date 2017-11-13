## constexprラムダ式

C++17ではラムダ式が`constexpr`になった。より正確に説明すると、ラムダ式のクロージャーオブジェクトの`operator ()`は条件を満たす場合`constexpr`になる。

~~~cpp
int main()
{
    auto f = []{ return 42 ; } ;

    constexpr int value = f() ; // OK
}
~~~

`constexpr`の条件を満たすラムダ式はコンパイル時定数を必要とする場所で使うことができる。例えば`constexpr`変数や配列の添字や`static_assert`などだ。

~~~cpp
int main()
{
    auto f = []{ return 42 ; } ;

    int a[f()] ;
    static_assert( f() == 42 ) ;
    std::array<int, f()> b ;
}
~~~

`constexpr`の条件を満たすのであれば、キャプチャーもできる。

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

`constexpr`ラムダ式はSFINAEの文脈で使うことができない。

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

機能テストマクロは`__cpp_constexpr`, 値は201603。

`__cpp_constexpr`マクロの値は、C++11の時点で200704、C++14の時点で201304だ。
