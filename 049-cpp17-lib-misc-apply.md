## 関数にtupleの中身を実引数に渡して呼ぶapply

C++17で追加されたヘッダーファイル\<tuple\>で定義されているapplyは関数にtupleの中身を実引数に渡して呼ぶライブラリだ。

~~~cpp
int main()
{
    auto f = [](int, double, std::string){} ;

    // int, double, const char *
    std::tuple t( 1, 2.0, "hello" ) ;

    // f( std::get<0>(t), std::get<1>(t), std::get<2>(t) )と同じ
    // つまり、f( 1, 2.0, "hello" )と同じ
    std::apply( f, t ) ;
}
~~~

このように、apply( f, t )は、関数オブジェクトfに対して、tuple tの要素を順番にfの実引数に渡してfを呼び出す。
