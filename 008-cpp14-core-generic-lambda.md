## ジェネリックラムダ

ジェネリックラムダはラムダ式の引数の型を書かなくてもすむようにする機能だ。

通常のラムダ式は以下のように書く。

~~~cpp
int main()
{
    []( int i, double d, std::string s ) { } ;
}
~~~

ラムダ式の引数には型が必要だ。しかし、クロージャーオブジェクトのoperator ()に渡す型はコンパイル時にわかる。コンパイル時にわかるということはわざわざ人間が指定する必要はない。ジェネリックラムダを使えば、引数の型を書くべき場所にautoキーワードを書くだけで型を推定してくれる。

~~~cpp
int main()
{
    []( auto i, auto d, auto s ) { } ;
}
~~~

ジェネリックラムダ式の結果のクロージャー型には呼出しごとに違う型を渡すことができる。

~~~cpp
int main()
{
    auto f = []( auto x ) { std::cout << x << '\n' ; } ;

    f( 123 ) ; // int
    f( 12.3 ) ; // double
    f( "hello" ) ; // char const *
}
~~~

仕組みは簡単で、以下のようなメンバーテンプレートのoperator ()を持ったクロージャーオブジェクトが生成されているだけだ。

~~~cpp
struct closure_object
{
    template < typename T >
    auto operator () ( T x )
    {
        std::cout << x << '\n' ;
    }
} ;
~~~

機能テストマクロは__cpp_generic_lambdas, 値は201304。
