## bool_constant

ヘッダーファイル\<type_traits\>にbool_constantが追加された。

~~~c++
template <bool B>
using bool_constant = integral_constant<bool, B>;

using true_type = bool_constant<true>;
using false_type = bool_constant<false>;
~~~

今までintegral_constantを使っていた場面で特にboolだけが必要な場面では、C++17以降は単にstd::true_typeかstd::false_typeと書くだけでよくなる。
