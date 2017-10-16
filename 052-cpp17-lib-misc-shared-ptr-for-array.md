## shared_ptr\<T[]\> : 配列に対するshared_ptr

C++17では、shared_ptrが配列に対応した。

~~~cpp
int main()
{
    // 配列対応のshared_ptr
    std::shared_ptr< int [] > ptr( new int[5] ) ;

    // operator []で配列に添字アクセスできる
    ptr[0] = 42 ;

    // shared_ptrのデストラクターがdelete[]を呼び出す
}
~~~
