## type_traits

C++17では\<type_traits\>に機能追加が行われた。

### 変数テンプレート版traits

C++17では、既存のtraitsに変数テンプレートを利用した_v版が追加された。

例えば、is_integral\<T\>::valueと書く代わりにis_integral_v\<T\>と書くことができる。

~~~cpp
template < typename T >
void f( T x )
{
    constexpr bool b1 = std::is_integral<T>::value ; // データメンバー
    constexpr bool b2 = std::is_integral_v<T> ; // 変数テンプレート
    constexpr bool b3 = std::is_integral<T>{} ; // operator bool()
}
~~~


### 論理演算traits

C++17ではクラステンプレートconjunction, disjunction, negationが追加された。これはテンプレートメタプログラミングで論理積、論理和、否定を手軽に扱うためのtraitsだ。

#### conjunction : 論理積

~~~c++
template<class... B> struct conjunction;
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

#### disjunction: 論理和


~~~c++
template<class... B> struct disjunction;
~~~


クラステンプレートdisjunction\<B1, B2, ..., BN\>はテンプレート実引数B1, B2, ... BNに論理和を適用する。disjunctionはそれぞれのテンプレート実引数Biに対して、bool(Bi::value)がtrueとなる最初の型を基本クラスに持つか、あるいは最後のBNを基本クラスに持つ。

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

### negation: 否定

~~~c++
template<class B> struct negation;
~~~

クラステンプレートnegation\<B\>はBに否定を適用する。negationは基本クラスとしてbool_constant\<!bool\(B::value\)\>を持つ。

~~~cpp
int main()
{
    using namespace std ;

    // false
    constexpr bool b1 = negation< true_type >::value ;
    // true
    constexpr bool b2 = negation< false_type >::value ; 
}
~~~


### is_invocable: 呼び出し可能か確認するtraits


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


is_invocableはテンプレート実引数で与えられた型FnがパラメーターパックArgTypesをパック展開した結果を実引数に関数呼び出しできるかどうか、そしてその戻り値はRかどうかを確認するtraitsだ。呼び出せるのであればtrue_type、そうでなければfalse_typeを基本クラスに持つ。


is_invocableは関数呼び出しした結果の戻り値の型については問わない。

is_invocable_rは呼び出し可能性に加えて、関数呼び出しした結果の戻り値の型がRであることが確認される。

is_nothrow_invocableとis_nothrow_invocable_rは、関数呼び出しが無例外保証されていることも確認する。

~~~cpp

int f( int, double ) ;

int main()
{
    // true
    constexpr bool b1 = std::is_invocable< decltype(&f), int, double >{} ;
    // true
    constexpr bool b2 = std::is_invocable< decltype(&f), int, int >{} ;

    // false
    constexpr bool b3 = std::is_invocable< decltype(&f), int >{} ;
    // false
    constexpr bool b4 = std::is_invocable< decltype(&f), int, std::string >{} ;
    
    // true
    constexpr bool b5 = std::is_invocable_r< int, decltype(&f), int, double >{} ;
    // false
    constexpr bool b6 = std::is_invocable_r< double, decltype(&f), int, double >{} ;
}
~~~


### has_unique_object_representations : 同値の内部表現が同一か確認するtraits

~~~c++
template <class T>
struct has_unique_object_representations ;
~~~

has_unique_object_representations\<T>は、T型がトリビアルにコピー可能で、かつT型の同値である2つのオブジェクトの内部表現が同じ場合に、trueを返す。

falseを返す例としては、オブジェクトがパディング(padding)と呼ばれるアライメント調整などのための値の表現に影響しないストレージ領域を持つ場合だ。パディングビットの値は同値に影響しないので、falseを返す。

例えば以下のようなクラスXは、

~~~cpp
struct X
{
    std::uint8_t a ;
    std::uint32_t b ;
} ;
~~~

ある実装においては、4バイトにアライメントする必要があり、そのオブジェクトの本当のレイアウトは以下のようになっているかもしれない。

~~~cpp
struct X
{
    std::uint8_t a ;

    std::byte unused_padding[3] ;

    std::uint32_t b ;
} ;
~~~

この場合、unused_paddingの値には意味がなく、クラスXの同値比較には用いられない。この場合、std::has_unique_representations_v\<X\>はfalseになる。

### no_throw_swappable: 無例外swap可能か確認するtraits

~~~c++
template <class T>
struct is_nothrow_swappable;

template <class T, class U>
struct is_nothrow_swappable_with;
~~~

is_nothrow_swappable\<T\>はT型がswapで例外を投げないときにtrueを返す。

is_nothrow_swappable_with\<T, U\>は、T型とU型を相互にswapするときに例外を投げないときにtrueを返す。
