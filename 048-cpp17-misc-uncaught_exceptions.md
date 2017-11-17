## std::uncaught_exceptions

C++14までは、まだ`catch`されていない例外がある場合は、`bool std::uncaught_exception()`で判定することができた。

~~~c++
struct X
{
    ~X()
    {
        if ( std::uncaught_exception() )
        {
            // デストラクターはスタックアンワインディング中に呼ばれた
        }
        else
        {
            // 通常の破棄
        }
    }
} ;

int main()
{
    {
        X x ;
    }// 通常の破棄

    {
        X x ;
        throw 0 ;
    }// スタックアンワインディング中

}
~~~

`bool std::uncaught_exception()`は、C++17では非推奨扱いになった。いずれ廃止される見込みだ。

廃止の理由としては、単に以下のような例で役に立たないからだ。

~~~c++
struct X
{
    ~X()
    {
        try {
            // true
            bool b = std::uncaught_exception() ;
        } catch( ... ) { }
    }
} ;
~~~

このため、`int std::uncaught_exceptions()`が新たに追加された。この関数は現在`catch`されていない例外の個数を返す。

~~~c++
struct X
{
    ~X()
    {
        try {
            if ( int x = std::uncaught_exceptions() ; x > 1 )
            {
                // ネストされた例外
            }
        } catch( ... )
    }

} ;
~~~
