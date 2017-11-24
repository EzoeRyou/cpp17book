## 通常の関数の戻り値の型推定

関数の戻り値の型として`auto`を指定すると、戻り値の型を`return`文から推定してくれる。

~~~cpp
// int ()
auto a(){ return 0 ; }
// double ()
auto b(){ return 0.0 ; }

// T(T)
template < typename T >
auto c(T t){ return t ; }
~~~

`return`文の型が一致していないとエラーとなる。

~~~cpp
auto f()
{
    return 0 ; // エラー、一致していない
    return 0.0 ; // エラー、一致していない
}
~~~

すでに型が決定できる`return`文が存在する場合、関数の戻り値の型を参照するコードも書ける。

~~~cpp
auto a()
{
    &a ; // エラー、aの戻り値の型が決定していない
    return 0 ;
}

auto b()
{
    return 0 ;
    &b ; // OK、戻り値の型はint
}
~~~

関数`a`へのポインターを使うには関数`a`の型が決定していなければならないが、`return`文の前に型は決定できないので関数`a`はエラーになる。関数`b`は`return`文が現れた後なので戻り値の型が決定できる。

再帰関数も書ける。

~~~cpp
auto sum( unsigned int i )
{
    if ( i == 0 )
        return i ; // 戻り値の型はunsigned int
    else
        return sum(i-1)+i ; // OK
}
~~~

このコードも、`return`文の順番を逆にすると戻り値の型が決定できずエラーとなるので注意。


~~~cpp
auto sum( unsigned int i )
{
    if ( i != 0 )
        return sum(i-1)+i ; // エラー
    else
        return i ;
}
~~~

機能テストマクロは`__cpp_return_type_deduction`, 値は201304。
