## scoped_lock : 可変長引数lock_guard

std::scoped_lockクラス\<T ...\>は可変長引数版のlock_guardだ。

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

std::scoped_lockのコンストラクターは複数のロックのオブジェクトのリファレンスを取り、それぞれにデッドロックを起こさない方法でメンバー関数lockを呼び出す。デストラクターはメンバー関数unlockを呼び出す。
