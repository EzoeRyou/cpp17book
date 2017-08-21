## 論理演算traits

C++17では、ヘッダーファイル\<type_traits\>にクラステンプレートconjunction, disjunction, negationが追加された。このはテンプレートメタプログラミングで

### conjunction : 論理和

~~~c++
template<class... B> struct conjunction
~~~

クラステンプレートconjunction\<B1, B2, ..., BN\>はテンプレート実引数B1, B2, ... BNに論理積を適用する。conjunctionはそれぞれのテンプレート実引数Biに対して、bool(Bi::value)がfalseとなる最初の型を基本クラスに持つか、あるいは最後のBNを基クラスに持つ。

~~~cpp
int main()
{
    using namespace std ;

    // is_void<void>を基本クラスに持つ
    using t1 = conjunction< is_same<int, int>, is_integral<int>, is_void<void> > ;

    // is_integral<double>を基本クラスに持つ
    using t2 = conjunction< is_same<int, int>, is_integral<double>, is_void<void> > ;

}
~~~

### disjunction


~~~c++
template<class... B> struct disjunction
~~~


クラステンプレートdisjunction\<B1, B2, ..., BN\>はテンプレート実引数B1, B2, ... BNに論理和を適用する。conjunctionはそれぞれのテンプレート実引数Biに対して、bool(Bi::value)がtrueとなる最初の型を基本クラスに持つか、あるいは最後のBNを基本クラスに持つ。

~~~cpp
int main()
{
    using namespace std ;

    // is_same<int,int>を基本クラスに持つ
    using t1 = disjunction< is_same<int, int>, is_integral<int>, is_void<void> > ;

    // is_void<int>を基本クラスに持つ
    using t2 = disjunction< is_same<int, double>, is_integral<double>, is_void<int> > ;

}
~~~

### negation

~~~c++
template<class... B> struct disjunction
~~~

クラステンプレートnegation\<B\>はBに否定を適用する。negationは基本クラスとしてbool_constant\<!bool\<B::value\>\>を持つ。

~~~cpp
int main()
{
    using namespace std ;

    // falae
    constexpr bool b1 = negation< true_type >::value ;
    // true
    constexpr bool b2 = negation< false_type >::value ; 
}
~~~


