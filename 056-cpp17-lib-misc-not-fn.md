## not_fn : 戻り値の否定ラッパー

~~~c++
template <class F> unspecified not_fn(F&& f);
~~~

関数オブジェクトfに対してnot_fn(f)を呼び出すと、戻り値として何らかの関数オブジェクトが帰ってくる。その関数オブジェクトを呼び出すと、実引数をfに渡してfを関数呼び出しして、戻り値をoperator !で否定して返す。

~~~cpp
int main()
{

    auto r1 = std::not_fn( []{ return true ; } ) ;

    r1() ; // false

    auto r2 = std::not_fn( []( bool b ) { return b ; } ) ;

    r2(true) ; // false
}
~~~

すでに廃止予定になったnot1, not2の代替品。
