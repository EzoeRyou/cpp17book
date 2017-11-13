## scoped_lock : 可変長引数lock_guard

`std::scoped_lock`クラス`<T ...>`は可変長引数版の`lock_guard`だ。

~~~cpp
int main()
{
    std::mutex a, b, c, d ;

    {
        // a,b,c,dをlockする
        std::scoped_lock l( a, b, c, d ) ;
        // a,b,c,dをunlockする
    }
}
~~~

`std::scoped_lock`のコンストラクターは複数のロックのオブジェクトのリファレンスを取り、それぞれにデッドロックを起こさない方法でメンバー関数`lock`を呼び出す。デストラクターはメンバー関数`unlock`を呼び出す。
