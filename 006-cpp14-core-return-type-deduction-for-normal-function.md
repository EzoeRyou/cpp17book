## 通常の関数の戻り値の型推定

関数の戻り値の型としてautoを指定すると、戻り値の型をreturn文から推定してくれる。

~~~cpp
// int ()
auto a(){ return 0 ; }
// double ()
auto b(){ return 0.0 ; }

// T(T)
template < typename T >
auto c(T t){ return t ; }
~~~

return文の型が一致していないとエラーとなる。

~~~cpp
auto f()
{
    return 0 ; // エラー、一致してない
    return 0.0 ; // エラー、一致していない
}
~~~

すでに型が決定できるreturn文が存在する場合、関数の戻り値の型を参照するコードも書ける。

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

関数aへのポインターを使うには関数aの型が決定していなければならないが、return文の前に型は決定できないので関数aはエラーになる。関数bはreturn文が現れた後なので戻り値の型が決定できる。

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

このコードも、return文の順番を逆にすると戻り値の型が決定できずエラーとなるので注意。


~~~cpp
auto sum( unsigned int i )
{
    if ( i != 0 )
        return sum(i-1)+i ; // エラー
    else
        return i ;
}
~~~

機能テストマクロは__cpp_decltype_auto。値は201304。

機能テストマクロがこの名前になっている理由は、次の機能を参照。
