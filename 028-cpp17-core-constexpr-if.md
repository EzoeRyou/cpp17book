## constexpr if文 : コンパイル時条件分岐

constexpr if文はコンパイル時の条件分岐ができる機能だ。

constexpr if文は、通常のif文をif constexprで置き換える。


~~~c++
// if文
if ( expression )
    statement ;

// constexpr if文
if constexpr ( expression )
    statement ;
~~~

constexpr if文という名前だが、実際に記述するときはif constexprだ。

コンパイル時の条件分岐とは何を意味するのか。以下はconstexpr ifが**行わないもの**の一覧だ。

+ 最適化
+ 非テンプレートコードにおける挙動の変化


コンパイル時の条件分岐の機能を理解するには、まずC++の既存の条件分岐について理解する必要がある。

### 実行時の条件分岐

通常の実行時の条件分岐は、実行時の値を取り、実行に条件分岐を行う。

~~~c++
void f( bool runtime_value )
{
    if ( runtime_value )
        do_true_thing() ;
    else
        do_false_thing() ;
}
~~~

この場合、runtime_valueがtrueの場合は関数do_true_thingが呼ばれ、falseの場合は関数do_false_thingが呼ばれる。

実行時の条件分岐の条件には、コンパイル時定数を指定できる。

~~~c++
if ( true )
    do_true_thing() ;
else
    do_false_thing() ;
~~~

この場合、賢いコンパイラーは以下のように処理を最適化するかもしれない。

~~~c++
do_true_thing() ;
~~~

なぜならば、条件は常にtrueだからだ。このような最適化は実行時の条件分岐でもコンパイル時に行える。コンパイル時の条件分岐はこのような最適化が目的ではない。

もう一度コード例に戻ろう。こんどは完全なコードをみてみよう。

~~~c++
// do_true_thingの宣言
void do_true_thing() ;

// do_false_thingの宣言は存在しない

void f( bool runtime_value )
{
    if ( true )
        do_true_thing() ;
    else
        do_false_thing() ; // エラー
}
~~~


このコードはエラーになる。その理由は、do_false_thingという名前が宣言されていないからだ。C++コンパイラーは、コンパイル時にコードを以下の形に変形することで最適化することはできるが、

~~~c++
void do_true_thing() ;

void f( bool runtime_value )
{
    do_true_thing() ;
}
~~~

最適化の結果失われたものも、依然としてコンパイル時にコードとして検証はされる。コードとして検証されるということは、コードとして誤りがあればエラーとなる。名前do_false_thingは宣言されていないのでエラーとなる。


### プリプロセス時の条件分岐

C++がC言語から受け継いだCプリプロセッサーには、プリプロセス時の条件分岐の機能がある。

~~~c++
// do_true_thingの宣言
void do_true_thing() ;

// do_false_thingの宣言は存在しない

void f( bool runtime_value )
{

#if true
    do_true_thing() ;
#else
    do_false_thing() ;
#endif
}
~~~

このコードは、プリプロセスの結果、以下のように変換される。

~~~c++
void do_true_thing() ;

void f( bool runtime_value )
{
    do_true_thing() ;
}
~~~

この結果、プリプロセス時の条件分岐では、選択されない分岐はコンパイルされないので、コンパイルエラーになるコードも書くことができる。

プリプロセス時の条件分岐は、条件が整数とかbool型のリテラルか、リテラルに比較演算子を適用した結果ではうまくいく。しかし、プリプロセス時とはコンパイル時ではないので、コンパイル時計算はできない。

~~~c++
constexpr int f()
{
    return 1 ;
}

void do_true_thing() ;

int main()
{
// エラー
// 名前fはプリプロセッサーマクロではない。
#if f()
    do_true_thing() ;
#else
    do_false_thing() ;
#endif
}
~~~

### コンパイル時の条件分岐

コンパイル時の条件分岐とは、分岐の条件にコンパイル時計算の結果を使い、かつ、選択されない分岐にコンパイルエラーが含まれていても、使われないのでコンパイルエラーにはならない条件分岐のことだ。


たとえば、std::distanceという標準ライブラリを実装してみよう。std::distance(first, last)は、イテレーターfirstとlastの距離を返す。

~~~cpp
template < typename Iterator >
constexpr typename std::iterator_traits<Iterator>::difference_type
distance( Iterator first, Iterator last )
{
    return last - first ;
}
~~~

残念ながら、この実装はIteratorがランダムアクセスイテレーターの場合にしか動かない。入力イテレーターに対応させるには、イテレーターを一つづつインクリメントしてlastと等しいかどうか比較する実装が必要になる。

~~~cpp
template < typename Iterator >
constexpr typename std::iterator_traits<Iterator>::difference_type
distance( Iterator first, Iterator last )
{
    typename std::iterator_traits<Iterator>::difference_type n = 0 ;

    while ( first != last )
    {
        ++n ;
        ++first ;
    }

    return n ;
}
~~~

残念ながら、この実装はIteratorにランダムアクセスイテレーターを渡した時に効率が悪い。

ここで必要な実装は、Iteratorがランダムアクセスイテレーターならばlast - firstを使い、そうでなければ地道にインクリメントする遅い実装を使うことだ。Iteratorがランダムアクセスイテレーターかどうかは、以下のコードを使えば、is_random_access_iterator\<iterator\>で確認できる。

~~~c++
template < typename Iterator >
constexpr bool is_random_access_iterator =
    std::is_same_v<
        typename std::iterator_traits<std::decay_t<Iterator> >::iterator_category,
        std::random_access_iterator_tag > ;
~~~

すると、distanceは以下のように書けるのではないか。

~~~cpp
// ランダムアクセスイテレーターかどうかを判定するコード
template < typename Iterator >
constexpr bool is_random_access_iterator =
    std::is_same_v<
        typename std::iterator_traits< std::decay_t<Iterator> >::iterator_category,
        std::random_access_iterator_tag > ;

// distance
template < typename Iterator >
constexpr typename std::iterator_traits<Iterator>::difference_type
distance( Iterator first, Iterator last )
{
    // ランダムアクセスイテレーターかどうか確認する
    if ( is_random_access_iterator<Iterator> )
    {// ランダムアクセスイテレーターなので速い方法を使う
        return last - first ;
    }
    else
    { // ランダムアクセスイテレーターではないので遅い方法を使う
        typename std::iterator_traits<Iterator>::difference_type n = 0 ;

        while ( first != last )
        {
            ++n ;
            ++first ;
        }

        return n ;
    }
}
~~~

残念ながら、このコードは動かない。ランダムアクセスイテレーターではないイテレーターを渡すと、last - firstというコードがコンパイルされるので、コンパイルエラーになる。コンパイラーは、

~~~c++
if ( is_random_access_iterator<Iterator> )
~~~

という部分について、is_random_access_iterator\<Iterator\>の値はコンパイル時に計算できるので、最終的なコード生成の結果としては、if (true)かif (false)なると判断できる。したがってコンパイラーは選択されない分岐のコード生成を行わないことはできる。しかしコンパイルはするので、コンパイルエラーになる。

constexpr ifを使うと、選択されない部分の分岐はコンパイルエラーであってもコンパイルエラーとはならなくなる。

~~~c++
// distance
template < typename Iterator >
constexpr typename std::iterator_traits<Iterator>::difference_type
distance( Iterator first, Iterator last )
{
    // ランダムアクセスイテレーターかどうか確認する
    if constexpr ( is_random_access_iterator<Iterator> )
    {// ランダムアクセスイテレーターなので速い方法を使う
        return last - first ;
    }
    else
    { // ランダムアクセスイテレーターではないので遅い方法を使う
        typename std::iterator_traits<Iterator>::difference_type n = 0 ;

        while ( first != last )
        {
            ++n ;
            ++first ;
        }

        return n ;
    }
}
~~~



### 超上級者向け解説

constexpr ifは、実はコンパイル時条件分岐ではない。テンプレートの実体化時に、選択されないブランチのテンプレートの実体化の抑制を行う機能だ。

constexpr ifによって選択されない文はdiscarded statementとなる。discarded statementはテンプレートの実体化の際に実体化されなくなる。

~~~cpp
struct X
{
   int get() { return 0 ; } 
} ;

template < typename T >
int f(T x)
{
    if constexpr ( std::is_same_v<std::decay_t<T>, X > )
        return x.get() ;
    else
        return x ;

}

int main()
{
    X x ;
    f( x ) ; // return x.get() 
    f( 0 ) ; // return x
}
~~~

f(x)では、return xがdiscarded statementとなるため実体化されない。Xはint型に暗黙に変換できないが問題がなくなる。f(0)ではreturn x.get()がdiscarded statementとなるため実体化されない。int型にはメンバー関数getはないが問題はなくなる。

discarded statementは実体化されないだけで、もちろんテンプレートのエンティティの一部だ。discarded statementがテンプレートのコードとして文法的、意味的に正しくない場合は、もちろんコンパイルエラーとなる。

~~~c++
template < typename T >
void f( T x )
{
    // エラー、名前gは宣言されていない
    if constexpr ( false )
        g() ; 

    // エラー、文法違反
    if constexpr ( false )
        !#$%^&*()_+ ;
}
~~~

何度も説明しているように、constexpr ifはテンプレートの実体化を条件付きで抑制するだけだ。条件付きコンパイルではない。

~~~cpp
template < typename T >
void f()
{
    if constexpr ( std::is_same_v<T, int> )
    {
        // 常にコンパイルエラー
        static_assert( false ) ;
    }
}
~~~

このコードは常にコンパイルエラーになる。なぜならば、static_assert( false ) はテンプレートに依存しておらず、テンプレートの宣言を解釈するときに、依存名ではないから、そのまま解釈される。

このようなことをしたければ、最初からstatic_assertのオペランドに式を書けばよい。

~~~cpp
template < typename T >
void f()
{
    static_assert( std::is_same_v<T, int> ) ;

    if constexpr ( std::is_same_v<T, int> )
    {
    }
}
~~~

もし、どうしてもconstexpr文の条件に合うときにだけstatic_assertが使いたい場合もある。これは、constexpr ifをネストしたりしていて、その内容を全部static_assertに書くのが冗長な場合だ。

~~~cpp
template < typename T >
void f()
{
    if constexpr ( E1 )
        if constexpr ( E2 )
            if constexpr ( E3 )
            {
                // E1 && E2 && E3のときにコンパイルエラーにしたい
                // 実際には常にコンパイルエラー
                static_assert( false ) ;
            }
}
~~~

現実には、E1, E2, E3は複雑な式なので、static_assert( E1 && E2 && E3 )と書くのは冗長だ。同じ内容を二度書くのは間違いの元だ。

このような場合、static_assertのオペランドをテンプレート引数に依存するようにすると、constexpr ifの条件に合うときにだけ発動するstatic_assertが書ける。

~~~cpp
template  <typename ... >
bool false_v = false ;

template < typename T >
void f()
{
    if constexpr ( E1 )
        if constexpr ( E2 )
            if constexpr ( E3 )
            {
                static_assert( false_v<T> ) ;
            }
}
~~~

このようにfalse_vを使うことで、static_assertをテンプレート引数Tに依存させる。その結果、static_assertの発動をテンプレートの実体化まで遅延させることができる。

constexpr ifは非テンプレートコードでも書くことができるが、その場合は普通のif文と同じだ。

### constexpr ifでは解決できない問題

constexpr ifは条件付きコンパイルではなく、条件付きテンプレート実体化の抑制なので、最初の問題の解決には使えない。例えば以下のコードはエラーになる。

~~~c++
// do_true_thingの宣言
void do_true_thing() ;

// do_false_thingの宣言は存在しない

void f( bool runtime_value )
{
    if ( true )
        do_true_thing() ;
    else
        do_false_thing() ; // エラー
}
~~~

理由は、名前do_false_thingは非依存名なのでテンプレートの宣言時に解決されるからだ。

### constexpr ifで解決できる問題

constexpr ifは依存名が関わる場合で、テンプレートの実体化がエラーになる場合に、実体化を抑制させることができる。

例えば、特定の型に対して特別な操作をしたい場合。

~~~cpp
struct X
{
    int get_value() ;
} ;

template < typename T >
void f(T t)
{
    
    int value{} ;

    // Tの型がXならば特別な処理を行いたい
    if constexpr ( std::is_same<T, X>{} )
    {
        value = t.get_value() ;
    }
    else
    {
        value = static_cast<int>(t) ;
    }
}
~~~

もしconstexpr ifがなければ、Tの型がXではないときもt.get_value()という式が実体化され、エラーとなる。

再帰的なテンプレートの特殊化をやめさせたいとき

~~~cpp
// factorial<N>はNの階乗を返す
template < std::size_t I  >
constexpr std::size_t factorial()
{
    if constexpr ( I == 1 )
    { return 1 ; }
    else
    { return I * factorial<I-1>() ; }
}
~~~

もしconstexpr ifがなければ、factorial<N-1>が永遠に実体化されコンパイル時ループが停止しない。


機能テストマクロは__cpp_if_constexpr, 値は201606。
