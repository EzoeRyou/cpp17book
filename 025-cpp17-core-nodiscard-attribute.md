## [[nodiscard]]属性

`[[nodiscard]]`属性は関数の戻り値が無視されてほしくないときに使うことができる。`[[nodiscard]]`属性が付与された関数の戻り値を無視すると警告メッセージが表示される。


~~~cpp
[[nodiscard]] int f()
{
    return 0 ;
}

void g( int ) { }

int main()
{
    // エラー、戻り値が無視されている
    f() ;

    // OK、戻り値は無視されていない
    int result = f() ;
    g( f() ) ;
    f() + 1 ;
    (void) f() ;
}
~~~

戻り値を無視する、というのは万能ではない。上の例でも、意味的には戻り値は無視されていると言えるが、コンパイラーはこの場合に戻り値が無視されているとは考えない。

`[[nodiscard]]`の目的は、戻り値を無視してほしくない関数をユーザーが利用したときの初歩的な間違いを防ぐためにある。`void`型にキャストするような意図的な戻り値の無視まで防ぐようには作られていない。


`[[nodiscard]]`属性を使うべき関数は、戻り値を無視してほしくない関数だ。どのような関数が戻り値を無視してほしくないかというと大きく2つある。


戻り値をエラーなどのユーザーが確認しなければならない情報の通知に使う関数。

~~~c++
enum struct error_code
{
    no_error, some_operations_failed,  serious_error
} ;

// 失敗するかもしれない処理
error_code do_something_that_may_fail()
{
    // 処理

    if ( is_error_condition() )
        return error_code::serious_error ;

    // 処理

    return error_code::no_error ;
}

// エラーがいっさい発生しなかったときの処理
int do_something_on_no_error() ;

int main()
{
    // エラーを確認していない
    do_something_that_may_fail() ;

    // エラーがない前提で次の処理をしようとする
    do_something_on_no_error() ;
}
~~~


関数に`[[nodiscard]]`属性を付与しておけば、このようなユーザー側の初歩的なエラー確認の欠如に警告メッセージを出せる。

`[[nodiscard]]`属性は、クラスと`enum`にも付与することができる。

~~~cpp
class [[nodiscard]] X { } ;
enum class [[nodiscard]] Y { } ;
~~~

`[[nodiscard]]`が付与されたクラスか`enum`が戻り値の型である関数は`[[nodiscard]]`が付与された扱いとなる。

~~~cpp
class [[nodiscard]] X { } ;

X f() { return X{} ; } 

int main()
{
    // 警告、戻り値が無視されている
    f() ;
}
~~~

機能テストマクロは`__has_cpp_attribute(nodiscard)`, 値は201603。
