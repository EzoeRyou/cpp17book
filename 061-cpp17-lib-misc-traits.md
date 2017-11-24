## type_traits

C++17では`<type_traits>`に機能追加が行われた。

### 変数テンプレート版traits

C++17では、既存の`traits`に変数テンプレートを利用した`_v`版が追加された。

たとえば、`is_integral<T>::value`と書く代わりに`is_integral_v<T>`と書くことができる。

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

C++17ではクラステンプレート`conjunction`, `disjunction`, `negation`が追加された。これはテンプレートメタプログラミングで論理積、論理和、否定を手軽に扱うための`traits`だ。

#### conjunction : 論理積

~~~c++
template<class... B> struct conjunction;
~~~

クラステンプレート`conjunction<B1, B2, ..., BN>`はテンプレート実引数`B1`, `B2`, ..., `BN`に論理積を適用する。`conjunction`はそれぞれのテンプレート実引数`Bi`に対して、`bool(Bi::value)`が`false`となる最初の型を基本クラスに持つか、あるいは最後の`BN`を基本クラスに持つ。

~~~cpp
int main()
{
    using namespace std ;

    // is_void<void>を基本クラスに持つ
    using t1 =
        conjunction<
            is_same<int, int>, is_integral<int>,
            is_void<void> > ;

    // is_integral<double>を基本クラスに持つ
    using t2 =
        conjunction<
            is_same<int, int>, is_integral<double>,
            is_void<void> > ;

}
~~~

#### disjunction: 論理和


~~~c++
template<class... B> struct disjunction;
~~~


クラステンプレート`disjunction<B1, B2, ..., BN>`はテンプレート実引数`B1`, `B2`, ..., `BN`に論理和を適用する。`disjunction`はそれぞれのテンプレート実引数`Bi`に対して、`bool(Bi::value)`が`true`となる最初の型を基本クラスに持つか、あるいは最後の`BN`を基本クラスに持つ。

~~~cpp
int main()
{
    using namespace std ;

    // is_same<int,int>を基本クラスに持つ
    using t1 =
        disjunction<
            is_same<int, int>, is_integral<int>,
            is_void<void> > ;

    // is_void<int>を基本クラスに持つ
    using t2 =
        disjunction<
            is_same<int, double>, is_integral<double>,
            is_void<int> > ;
}
~~~

### negation: 否定

~~~c++
template<class B> struct negation;
~~~

クラステンプレート`negation<B>`は`B`に否定を適用する。`negation`は基本クラスとして`bool_constant<!bool(B::value)>`を持つ。

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


`is_invocable`はテンプレート実引数で与えられた型`Fn`がパラメーターパック`ArgTypes`をパック展開した結果を実引数に関数呼び出しできるかどうか、そしてその戻り値は`R`へ暗黙変換できるかどうかを確認する`traits`だ。呼び出せるのであれば`true_type`, そうでなければ`false_type`を基本クラスに持つ。


`is_invocable`は関数呼び出しした結果の戻り値の型については問わない。

`is_invocable_r`は呼び出し可能性に加えて、関数呼び出しした結果の戻り値の型が`R`へ暗黙変換できることが確認される。

`is_nothrow_invocable`と`is_nothrow_invocable_r`は、関数呼び出し（および戻り値型`R`への暗黙変換）が無例外保証されていることも確認する。

~~~cpp

int f( int, double ) ;

int main()
{
    // true
    constexpr bool b1 =
        std::is_invocable< decltype(&f), int, double >{} ;
    // true
    constexpr bool b2 =
        std::is_invocable< decltype(&f), int, int >{} ;

    // false
    constexpr bool b3 =
        std::is_invocable< decltype(&f), int >{} ;
    // false
    constexpr bool b4 =
        std::is_invocable< decltype(&f), int, std::string >{} ;
    
    // true
    constexpr bool b5 = 
        std::is_invocable_r< int, decltype(&f), int, double >{} ;
    // false
    constexpr bool b6 =
        std::is_invocable_r< double, decltype(&f), int, double >{} ;
}
~~~


### has_unique_object_representations : 同値の内部表現が同一か確認するtraits

~~~c++
template <class T>
struct has_unique_object_representations ;
~~~

`has_unique_object_representations<T>`は、`T`型がトリビアルにコピー可能で、かつ`T`型の同値である2つのオブジェクトの内部表現が同じ場合に、`true`を返す。

`false`を返す例としては、オブジェクトがパディング（padding）と呼ばれるアライメント調整などのための値の表現に影響しないストレージ領域を持つ場合だ。パディングビットの値は同値に影響しないので、`false`を返す。

たとえば以下のようなクラス`X`は、

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

この場合、`unused_padding`の値には意味がなく、クラス`X`の同値比較には用いられない。この場合、`std::has_unique_representations_v<X>`は`false`になる。

### is_nothrow_swappable: 無例外swap可能か確認するtraits

~~~c++
template <class T>
struct is_nothrow_swappable;

template <class T, class U>
struct is_nothrow_swappable_with;
~~~

`is_nothrow_swappable<T>`は`T`型が`swap`で例外を投げないときに`true`を返す。

`is_nothrow_swappable_with<T, U>`は、`T`型と`U`型を相互に`swap`するときに例外を投げないときに`true`を返す。
