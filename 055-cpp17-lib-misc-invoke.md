## invoke : 指定した関数を指定した実引数で呼び出す

~~~c++
template <class F, class... Args>
invoke_result_t<F, Args...> invoke(F&& f, Args&&... args)
noexcept(is_nothrow_invocable_v<F, Args...>);
~~~

invoke( f, t1, t2, ... , tN )は、関数fをf( a1, a2, ... , aN )のように呼び出す。

より正確には、C++標準規格のINVOKE(f, t1, t2, ... , tN)と同じ規則で呼び出す。これには様々な規則があり、たとえばメンバー関数へのポインターやデータメンバーへのポインター、またその場合に与えるクラスへのオブジェクトがリファレンスかポインターかreference_wrapperかによっても異なる。その詳細はここでは解説しない。

INVOKEはstd::functionやstd::bindでも使われている規則なので、標準ライブラリと同じ挙動ができるようになると覚えておけばよい。

例

~~~cpp
void f( int ) { }

struct S
{
    void f( int ) ;
    int data ;
} ;

int main()
{
    // f( 1 ) 
    std::invoke( f, 1 ) ;

    S s ;

    // (s.*&S::f)(1)
    std::invoke( &S::f, s, 1 ) ;
    // ((*&s).*&S::f)(1)
    std::invoke( &S::f, &s, 1 ) ;
    // s.*&S::data 
    std::invoke( &S::data, s ) ;
}
~~~
