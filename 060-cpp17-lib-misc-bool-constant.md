## bool_constant

ヘッダーファイル`<type_traits>`に`bool_constant`が追加された。

~~~c++
template <bool B>
using bool_constant = integral_constant<bool, B>;

using true_type = bool_constant<true>;
using false_type = bool_constant<false>;
~~~

今まで`integral_constant`を使っていた場面で特に`bool`だけが必要な場面では、C++17以降は単に`std::true_type`か`std::false_type`と書くだけでよくなる。
