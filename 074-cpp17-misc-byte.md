## std::byte

std::byteはヘッダーファイル\<cstddef\>で以下のように定義されている。

~~~c++
namespace std {

    enum class byte : unsigned char {};

    // byte型に対する演算子のオーバーロード
}
~~~

std::byte型は、生のバイト列を表すための型として使うことができる。生の1バイトを表すにはchar型が慣習的に使われてきたが、std::byte型は生の1バイトを表現する型として、新たにC++17で追加された。

std::byte型は強い型によって、暗黙の型変換を防ぐ。

~~~cpp
int main()
{
    // OK、暗黙の型変換
    char c = 0 ;
    c += 1 ;

    // エラー、int型からstd::byte型に変換できない
    std::byte b = 0 ;
    // エラー、int型からstd::byte型に変換できない
    b += 1 ;
}
~~~

std::byteを扱うには、明示的なキャストが必要だ。

~~~cpp
int main()
{
    std::byte b = static_cast<std::byte>(0) ;
    b += static_cast<std::byte>(1) ;
}
~~~

これによって、型の取り違えを防ぐことができる。

~~~cpp
void f()
{
    // 数字の1
    int va1 = 20 ;

    // 長いコード


    
    std::byte b = static_cast<std::byte>(0b00000001) ;
    // アルファベットl
    std::byte val = static_cast<std::byte>(0b11110000) ;

    b |= va1 ; // エラー
}
~~~

std::byteは内部のストレージをバイト単位でアクセスできるようにするため、規格上charと同じ様な配慮が行われている。

~~~cpp
int main()
{
    int x = 42 ;

    std::byte * rep = reinterpret_cast< std::byte *>(&x) ;
}
~~~
