## 初期化文つき条件文

C++17では、条件文に初期化文を記述できるようになった。


~~~c++
if ( int x = 1 ; x )
     /*...*/ ;

switch( int x = 1 ; x )
{
    case 1 :
        /*... */;
}
~~~

これは、以下のコードと同じ意味になる。

~~~c++
{
    int x = 1 ;
    if ( x ) ;
}

{
    int x = 1 ;
    switch( x )
    {
        case 1 : ;
    }
}
~~~

なぜこのような機能が追加されたかというと、変数を宣言し、if文の条件に変数を使い、if文を実行後は変数を使用しない、というパターンは現実のコードで頻出するからだ。

~~~c++
void * ptr = std::malloc(10) ;
if ( ptr != nullptr )
{
    // 処理
    std::free(ptr) ;
}
// これ以降ptrは使わない

FILE * file = std::fopen("text.txt", "r") ;
if ( file != nullptr )
{
    // 処理
    std::fclose( file ) ;
}
// これ以降fileは使わない

auto int_ptr = std::make_unique<int>(42) ;
if ( ptr )
{
    // 処理
}
// これ以降int_ptrは使わない
~~~


上記のコードには問題がある。これ以降変数は使わないが、変数自体は使えるからだ。

~~~c++
auto ptr = std::make_unique<int>(42) ;
if ( ptr )
{
    // 処理
}
// これ以降ptrは使わない

// でも使える
int value = *ptr ;
~~~

変数を使えないようにするには、ブロックスコープで囲むことで、変数をスコープから外してやればよい。

~~~c++
{
    auto int_ptr = std::make_unique<int>(42) ;
    if ( ptr )
    {
        // 処理
    }
    // ptrは破棄される
}
// これ以降ptrは使わないし使えない
~~~

このようなパターンは頻出するので、初期化文つきの条件文が追加された。

~~~c++
if ( auto ptr = std::make_unique<int>(42) ; ptr )
{
    // 処理
}
~~~


