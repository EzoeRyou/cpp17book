## [[deprecated]]属性

[[deprecated]]属性は名前とエンティティが、まだ使えるものの利用は推奨されない状態であることを示すのに使える。deprecated属性が指定できる名前とエンティティは、クラス、typedef名、変数、非staticデータメンバー、関数、名前空間、enum、enumerator、テンプレートの特殊化だ

それぞれ以下のように指定できる。

~~~cpp
// 変数
[[deprecated]] int variable_name ;

// typedef名
[[deprecated]] typedef int typedef_name ;

// 関数
[[deprecated]] void function_name() { }


// クラス
// unionも同じ
class [[deprecated]] class_name
{
// 非staticデータメンバー
[[deprecated]] int non_static_data_member_name ;
} ;

// enum
enum class [[deprecated]] enum_name
{
// enumerator
enumerator_name [[deprecated]] = 42
} ;

// エイリアス宣言によるtypedef名
using typedef_name2 [[deprecated]] = int ;

// 名前空間
namespace [[deprecated]] namespace_name { int x ; }

// テンプレートの特殊化

template < typename T >
class template_name { } ;

template < >
class [[deprecated]] template_name<void> { }
~~~

deprecated属性が指定された名前やエンティティを使うと、C++コンパイラーは警告メッセージを出す。

deprecated属性には、文字列を付け加えることができる。これはC++装によっては警告メッセージに含まれるかもしれない。

~~~cpp
[[deprecated("Use of f() is deprecated. Use f(int option) instead.")]] void f() ;

void f( int option ) ;
~~~

機能テストマクロは__has_cpp_attribute(deprecated)。値は201309。
