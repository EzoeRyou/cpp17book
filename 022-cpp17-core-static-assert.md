## 文字列なしstatic_assert

C++17ではstatic_assertに文字列リテラルをとらないものが追加された。


~~~cpp
static_assert( true ) ;
~~~

C++11で追加されたstatic_asserには、文字列リテラルが必須だった。

~~~cpp
static_assert( true, "this shall not be asserted.") ;
~~~

特に文字列を指定する必要がない場合もあるので、文字列リテラルを取らないstatic_assertが追加された。


機能テストマクロは__cpp_static_assert, 値は201411。

C++11の時点で__cpp_static_assertの値は200410。
