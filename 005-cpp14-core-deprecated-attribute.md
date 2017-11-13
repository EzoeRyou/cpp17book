## [[deprecated]]属性

`[[deprecated]]`属性は名前とエンティティが、まだ使えるものの利用は推奨されない状態であることを示すのに使える。`deprecated`属性が指定できる名前とエンティティは、クラス、`typedef`名、変数、非`static`データメンバー、関数、名前空間、`enum`、`enumerator`、テンプレートの特殊化だ。

それぞれ以下のように指定できる。

~~~cpp
// 変数
// どちらでもよい
[[deprecated]] int variable_name1 { } ;
int variable_name2 [[deprecated]] { } ;

// typedef名
[[deprecated]] typedef int typedef_name1 ;
typedef int typedef_name2 [[deprecated]] ;
using typedef_name3 [[deprecated]] = int ;

// 関数
// メンバー関数も同じ文法
// どちらでもよい
[[deprecated]] void function_name1() { }
void function_name2 [[deprecated]] () { }


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


// 名前空間
namespace [[deprecated]] namespace_name { int x ; }

// テンプレートの特殊化

template < typename T >
class template_name { } ;

template < >
class [[deprecated]] template_name<void> { } ;
~~~

`deprecated`属性が指定された名前やエンティティを使うと、C++コンパイラーは警告メッセージを出す。

`deprecated`属性には、文字列を付け加えることができる。これはC++実装によっては警告メッセージに含まれるかもしれない。

~~~cpp
[[deprecated("Use of f() is deprecated. Use f(int option) instead.")]]
void f() ;

void f( int option ) ;
~~~

機能テストマクロは`__has_cpp_attribute(deprecated)`, 値は201309。
