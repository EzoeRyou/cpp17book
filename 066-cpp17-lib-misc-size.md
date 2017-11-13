## コンテナーアクセス関数

ヘッダーファイル`<iterator>`に、コンテナーアクセス関数として、フリー関数版の`size`, `empty`, `data`が追加された。それぞれ、メンバー関数の`size`, `empty`, `data`を呼び出す。

~~~cpp
int main()
{
    std::vector<int> v ;

    std::size(v) ; // v.size()
    std::empty(v) ; // v.empty()
    std::data(v) ; // v.data() 
}
~~~

このフリー関数は配列や`std::initializer_list<T>`にも使える。

~~~cpp
int main()
{
    int a[10] ;

    std::size(a) ; // 10
    std::empty(a) ; // 常にfalse
    std::data(a) ; // a
}
~~~
