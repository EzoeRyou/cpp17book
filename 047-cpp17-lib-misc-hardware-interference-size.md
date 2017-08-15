## ハードウェア干渉サイズ(キャッシュライン)

C++17にはハードウェアの干渉サイズを取得するライブラリが入った。ハードウェアの干渉サイズとは、俗にキャッシュライン(cache line)とも呼ばれている概念だ。

残念ながら、この2017年では、メモリーは極めて遅い。そのため、プロセッサーはより高速にアクセスできるキャッシュメモリーを用意している。メモリーに対するキャッシュはある程度のまとまったバイト数単位で行われる。この単位が何バイトであるのかは実装依存だ。C++17にはこのサイズを取得できるライブラリが入った。

ハードウェア干渉サイズを知りたい理由は二つある。二つのオブジェクトを同一の局所性を持つキャッシュに載せたくない場合と載せたい場合だ。

二つのオブジェクトのうち、一方は頻繁に変更し、もう一方はめったに変更しない場合で、二つのオブジェクトが同じ局所性をもつキャッシュに載っている場合、よく変更するオブジェクトを変更しただけで、めったに変更しないオブジェクトも、メモリとの同期が発生する。

~~~cpp
struct Data
{
    int counter ;
    int status ;
} ;
~~~

ここで、counterは頻繁に変更するが、statusはめったに変更しない場合、counterとstatusの間に適切なパディングを挿入することで、二つのオブジェクトが同じ局所性を持たないようにしたい。

この場合には、std::hardware_destructive_interference_sizeが使える。

~~~cpp
struct Data
{
    int counter ;
    std::byte padding[std::hardware_destructive_interference_size - sizeof(int)] ;
    int status ;
} ;
~~~

反対に、二つのオブジェクトを同一の局所性を持つキャッシュに載せたい場合、std::hardware_constructive_interference_sizeが使える。



ハードウェア干渉サイズは\<new\>ヘッダーで以下のように定義されている。

~~~c++
namespace std {
    inline constexpr size_t hardware_destructive_interference_size = 実装依存 ;
    inline constexpr size_t hardware_constructive_interference_size = 実装依存 ;
}
~~~

