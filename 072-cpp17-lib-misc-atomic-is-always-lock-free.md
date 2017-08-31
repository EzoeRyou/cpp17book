## atomic\<T\>::is_always_lock_free

~~~c++
template < typename T >
struct atomic
{
    static constexpr bool is_always_lock_free = ... ;
} ;
~~~

C++17で\<atomic\>に追加されたatomic\<T\>::is_always_lock_freeは、atomic\<T\>の実装がすべての実行においてロックフリーであるとコンパイル時に保証できる場合、trueになるstatic constexprなbool型のデータメンバーだ。

atomicには、他にもboolを返すメンバー関数is_lock_freeがあるが、これは実行時にロックフリーであるかどうかを判定できる。is_always_lock_freeはコンパイル時にロックフリーであるかどうかを判定できる。
