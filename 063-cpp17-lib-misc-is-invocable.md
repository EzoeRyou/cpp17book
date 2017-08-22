## is_invocable: 呼び出し可能か確認するtraits


~~~c++
template <class Fn, class... ArgTypes>
struct is_invocable;

template <class R, class Fn, class... ArgTypes>
struct is_invocable_r;

template <class Fn, class... ArgTypes>
struct is_nothrow_invocable;

template <class R, class Fn, class... ArgTypes>
struct is_nothrow_invocable_r;
~~~


ヘッダーファイル\<type_traits\>に追加されたis_invocableはテンプレート実引数で与えられた型FnがパラメーターパックArgTypesをパック展開した結果を実引数に関数呼び出しできるかどうか、そしてその戻り値はRかどうかを確認するtraitsだ。呼び出せるのであればtrue_type、そうでなければfalse_typeを基本クラスに持つ。


is_invocableは関数呼び出しした結果の戻り値の型については問わない。

is_invocable_rは呼び出し可能性に加えて、関数呼び出しした結果の戻り値の型がRであることが確認される。

is_nothrow_invocableとis_nothrow_invocableは、関数呼び出しが無例外保証されていることも確認する。
