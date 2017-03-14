## constexpr関数の制限緩和

C++11で追加されたconstexpr関数はとても制限が強い。constexpr関数の本体には実質return文一つしか書けない。

C++14では、ほとんど何でも書けるようになった。

~~~cpp
constexpr int f( int x )
{
    // 変数を宣言できる。
    int sum = 0 ;

    // 繰り返し文を書ける。
    for ( int i = 1 ; i < x ; ++i )
    {
        // 変数を変更できる
        sum += i ;
    }

    return sum ;
}
~~~


