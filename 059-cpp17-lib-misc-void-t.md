## void_t 

ヘッダーファイル\<type_traits\>で定義されているvoid_tは以下のように定義されている。

~~~c++
namespace std {

template < class ... >
using void_t = void ;

}
~~~

void_tは任意個の型をテンプレート実引数として受け取るvoid型だ。この性質はテンプレートメタプログラミングにおいてとても便利なので、標準ライブラリに追加された。
