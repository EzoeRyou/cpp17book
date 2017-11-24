## 文字列なしstatic_assert

C++17では`static_assert`に文字列リテラルを取らないものが追加された。


~~~cpp
static_assert( true ) ;
~~~

C++11で追加された`static_assert`には、文字列リテラルが必須だった。

~~~cpp
static_assert( true, "this shall not be asserted." ) ;
~~~

特に文字列を指定する必要がない場合もあるので、文字列リテラルを取らない`static_assert`が追加された。


機能テストマクロは`__cpp_static_assert`, 値は201411。

C++11の時点で`__cpp_static_assert`の値は200410。
