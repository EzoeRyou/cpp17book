## void_t 

ヘッダーファイル`<type_traits>`で定義されている`void_t`は以下のように定義されている。

~~~c++
namespace std {

template < class ... >
using void_t = void ;

}
~~~

`void_t`は任意個の型をテンプレート実引数として受け取る`void`型だ。この性質はテンプレートメタプログラミングにおいてとても便利なので、標準ライブラリに追加された。
