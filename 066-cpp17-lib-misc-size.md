## コンテナーアクセス関数

ヘッダーファイル\<iterator\>に、コンテナーアクセス関数として、フリー関数版のsize, empty, dataが追加された。それぞれ、メンバー関数のsize, empty, dataを呼び出す。

~~~cpp
int main()
{
    std::vector<int> v ;

    std::size(v) ; // v.size()
    std::empty(v) ; // v.empty()
    std::data(v) ; // v.data() 
}
~~~

このフリー関数は配列やstd::initializer_list\<T\>にも使える。

~~~cpp
int main()
{
    int a[10] ;

    std::size(a) ; // 10
    std::empty(a) ; // 常にfalse
    std::data(a) ; // a
}
~~~
