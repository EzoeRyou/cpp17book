## constexpr関数の制限緩和

C++11で追加された`constexpr`関数はとても制限が強い。`constexpr`関数の本体には実質`return`文1つしか書けない。

C++14では、ほとんど何でも書けるようになった。

~~~cpp
constexpr int f( int x )
{
    // 変数を宣言できる
    int sum = 0 ;

    // 繰り返し文を書ける
    for ( int i = 1 ; i < x ; ++i )
    {
        // 変数を変更できる
        sum += i ;
    }

    return sum ;
}
~~~

機能テストマクロは`__cpp_constexpr`, 値は201304。

C++11の`constexpr`関数に対応しているがC++14の`constexpr`関数に対応していないC++実装では、`__cpp_constexpr`マクロの値は200704になる。
