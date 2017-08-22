## has_unique_object_representations : 同値の内部表現が同一か確認するtraits

~~~c++
template <class T>
struct has_unique_object_representations ;
~~~

ヘッダーファイル\<type_traits\>で定義されているhas_unique_object_representations\<T>は、T型がトリビアルにコピー可能で、かつT型の同値である2つのオブジェクトの内部表現が同じ場合に、trueを返す。

falseを返す例としては、オブジェクトがパディング(padding)と呼ばれるアライメント調整などのための値の表現に影響しないストレージ領域を持つ場合だ。パディングビットの値は同値に影響しないので、falseを返す。

例えば以下のようなクラスXは、

~~~cpp
struct X
{
    std::uint8_t a ;
    std::uint32_t b ;
} ;
~~~

ある実装においては、4バイトにアライメントする必要があり、そのオブジェクトの本当のレイアウトは以下のようになっているかもしれない。

~~~cpp
struct X
{
    std::uint8_t a ;

    std::byte unused_padding[3] ;

    std::uint32_t b ;
} ;
~~~

この場合、unused_paddingの値には意味がなく、クラスXの同値比較には用いられない。この場合、std::has_unique_representations_v\<X\>はfalseになる。
