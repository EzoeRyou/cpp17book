## autoによる非型テンプレートパラメーターの宣言

C++17では非型テンプレートパラメーターの宣言にautoを使うことができるようになった。

~~~cpp
template < auto x >
struct X { } ;

void f() { }

int main()
{
    X<0> x1 ;
    X<0l> x2 ;
    X<&f> x3 ;
}
~~~

これはC++14までであれば、以下のように書かなければならなかった。

~~~cpp
template < typename T, T x >
struct X { } ;

void f() { }

int main()
{
    X<int, 0> x1 ;
    X<long, 0l> x2 ;
    X<void(*)(), &f> x3 ;
}
~~~

機能テストマクロは__cpp_template_auto, 値は201606。
