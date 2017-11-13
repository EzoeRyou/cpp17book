## atomic\<T\>::is_always_lock_free

~~~c++
template < typename T >
struct atomic
{
    static constexpr bool is_always_lock_free = ... ;
} ;
~~~

C++17で`<atomic>`に追加された`atomic<T>::is_always_lock_free`は、`atomic<T>`の実装がすべての実行においてロックフリーであるとコンパイル時に保証できる場合、`true`になる`static constexpr`な`bool`型のデータメンバーだ。

`atomic`には、他にも`bool`を返すメンバー関数`is_lock_free`があるが、これは実行時にロックフリーであるかどうかを判定できる。`is_always_lock_free`はコンパイル時にロックフリーであるかどうかを判定できる。
