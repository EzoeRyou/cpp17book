## 初期化ラムダキャプチャー

初期化ラムダキャプチャーはラムダキャプチャーする変数の名前と式を書くことができる機能だ。

ラムダ式は書かれた場所から見えるスコープの変数をキャプチャーする。

~~~cpp
int main()
{
    int x = 0 ;
    auto f = [=]{ return x ; } ;
    f() ;
}
~~~

初期化ラムダキャプチャーはラムダキャプチャーに初期化子を書くことができる機能だ。


~~~cpp

int main()
{
    int x = 0 ;
    [ x = x, y = x, &ref = x, x2 = x * 2 ]
    {// キャプチャーされた変数を使う
        x ;
        y ;
        ref ;
        x2 ;
    } ;
}
~~~~

初期化ラムダキャプチャーは、"識別子 = expr" という文法でラムダ導入子[]の中に書く。するとあたかも"auto 識別子 = expr ;"と書いたかのように変数が作られる。これによりキャプチャーする変数の名前を変えたり、まったく新しい変数を宣言することができる。

初期化ラムダキャプチャーの識別子の前に&をつけると、リファレンスキャプチャー扱いになる。

~~~cpp
int main()
{
    int x = 0 ;
    [ &ref = x ]()
    {
        ref = 1 ;
    }() ;

    // xは1
}
~~~


初期化ラムダキャプチャーが追加された理由には変数の名前を変えたり全く新しい変数を導入したいという目的の他に、非staticデータメンバーをコピーキャプチャーするという目的がある。

以下のコードには問題があるが、わかるだろうか。

~~~cpp
struct X
{
    int data = 42 ;

    auto get_closure_object()
    {
        return [=]{ return data ; } ;
    }
} ;


int main()
{
    std::function< int() > f ;

    {
        X x ;
        f = x.get_closure_object() ;
    }

    std::cout << f() << std::endl ;
}
~~~

X::get_closure_objectはX::dataを返すクロージャーオブジェクトを返す。

~~~c++
auto get_closure_object()
{
    return [=]{ return data ; } ;
}
~~~

これを見ると、コピーキャプチャである[=]を使っているので、dataはクロージャーオブジェクト内にコピーされているように思える。しかし、ラムダ式は非staticデータメンバーをキャプチャーしてはいない。ラムダ式がキャプチャーしているのはthisポインターだ。上のコードと下のコードは同じ意味になる。

~~~c++
auto get_closure_object()
{
    return [this]{ return this->data ; } ;
}
~~~

さて、main関数をもう一度見てみよう。

~~~c++
int main()
{
    // クロージャーオブジェクトを代入するための変数
    std::function< int() > f ;

    {
        X x ; // xが構築される
        f = x.get_closure_object() ;
        // xが破棄される
    }

    // すでにxは破棄された
    // return &x->dataで破棄されたxを参照する
    std::cout << f() << std::endl ;
}
~~~

なんと、すでに破棄されたオブジェクトへのリファレンスを参照してしまっている。これは未定義動作だ。

初期化ラムダキャプチャーを使えば、非staticデータメンバーもコピーキャプチャーできる。

~~~c++
auto get_closure_object()
{
    return [data=data]{ return data ; } ;
}
~~~

なお、ムーブキャプチャーは存在しない。ムーブというのは特殊なコピーなので初期化ラムダキャプチャーがあれば実現できるからだ。

~~~cpp
auto f()
{
    std::string str ;
    std::cin >> str ;
    // ムーブ
    return [str = std::move(str)]{ return str ; } ;
}
~~~

機能テストマクロは__cpp_init_captures, 値は201304。
