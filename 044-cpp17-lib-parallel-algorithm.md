# 並列アルゴリズム

並列アルゴリズムはC++17で追加された新しいライブラリだ。このライブラリは既存の\<algorithm\>に、並列実行版を追加する。

## 並列実行について

C++11では、スレッドと同期処理が追加され、複数の実行媒体が同時に実行されるという概念がC++標準規格に入った。

C++17では、既存のアルゴリズムに、並列実行版が追加された。

例えば、all_of(first, last, pred)というアルゴリズムは、[first,last)の区間が空であるか、すべてのイテレーターiに対してpred(*i)がtrueを返すとき、trueを返す。それ以外の場合はfalseを返す。

すべての値が100未満であるかどうかを調べるには、以下のように書く。

~~~cpp
template < typename Container >
bool is_all_of_less_than_100( Container const & input )
{
    return std::all_of( std::begin(input), std::end(input),
        []( auto x ) { return x < 100 ; } ) ;
}

int main()
{
    std::vector<int> input ;
    std::copy( std::istream_iterator<int>(std::cin), std::istream_iterator<int>(), std::back_inserter(input) ) ;

    bool result = is_all_of_less_than_100( input ) ;

    std::cout << "result : " << result << std::endl ;
}
~~~

本書の執筆時点では、コンピューターはマルチコアが一般的になり、同時に複数のスレッドを実行できるようになった。さっそくこの処理を二つのスレッドで並列化してみよう。

~~~cpp
template < typename Container >
bool double_is_all_of_less_than_100( Container const & input )
{
    auto first = std::begin(input) ;
    auto last = first + (input.size()/2) ;

    auto r1 = std::async( [=]{ return std::all_of( first, last, [](auto x) { return x < 100 ; } ) ; } ) ;

    first = last ;
    last = std::end(input) ;

    auto r2 = std::async( [=]{ return std::all_of( first, last, [](auto x) { return x < 100 ; } ) ; } ) ;

    return r1.get() && r2.get() ;
}
~~~

なるほど、とてもわかりにくいコードだ。

筆者のコンピューターのCPUは二つの物理コア、4つの論理コアを持っているので、4スレッドまで同時に並列実行できる。読者の使っているコンピューターは、より高性能で更に多くのスレッドを同時に実行可能だろう。実行時に最大の効率を出すようにできるだけ頑張ってみよう。

~~~cpp
template < typename Container >
bool parallel_is_all_of_less_than_100( Container const & input )
{
    std::size_t cores = std::thread::hardware_concurrency() ;
    cores = std::min( input.size(), cores ) ;

    std::vector< std::future<bool> > futures( cores ) ;

    auto step = input.size() / cores ;
    auto remainder = input.size() % cores ;

    auto first = std::begin(input) ;
    auto last = first + step + remainder ;

    for ( auto & f : futures )
    {
        f = std::async( [=]{ return std::all_of( first, last, [](auto x){ return x < 100 ;} ) ; } ) ;

        first = last ;
        last = first + step ;
    }

    for ( auto & f : futures )
    {
        if ( f.get() == false )
            return false ;
    }
    return true ;
}
~~~

もうわけがわからない。

このような並列化をそれぞれのアルゴリズムに対して自前で実装するのは面倒だ。そこで、C++17では標準で並列実行してくれる並列アルゴリズム(Parallelism)が追加された。

## 使い方

並列アルゴリズムは既存のアルゴリズムのオーバーロードとして追加されている。

以下は既存のアルゴリズムであるall_ofの宣言だ。

~~~c++
template <class InputIterator, class Predicate>
bool all_of(InputIterator first, InputIterator last, Predicate pred);
~~~

並列アルゴリズム版のall_ofは以下のような宣言になる。

~~~c++
template <class ExecutionPolicy, class ForwardIterator, class Predicate>
bool any_of(ExecutionPolicy&& exec, ForwardIterator first, ForwardIterator last, Predicate pred);
~~~

並列アルゴリズムには、テンプレート仮引数としてExecutionPolicyが追加されていて第一引数に取る。これを実行時ポリシーと呼ぶ。

実行時ポリシーは\<execution\>で定義されている関数ディスパッチ用のタグ型で、std::execution::seq, std::execution::par, std::execution::par_unseqがある。

複数のスレッドによる並列実行を行うには、std::execution::parを使う。

~~~cpp
template < typename Container >
bool is_all_of_less_than_100( Container const & input )
{
    return std::all_of( std::execution::par,
        std::begin(input), std::end(input),
        []( auto x ){ return x < 100 ; } ) ;
}
~~~


std::execution::seqを渡すと既存のアルゴリズムと同じシーケンシャル実行になる。std::execution::parを渡すとパラレル実行になる。std::execution::par_unseqは並列実行かつベクトル実行になる。

C++17には実行ポリシーを受け取るアルゴリズムのオーバーロード関数が追加されている。

## 並列アルゴリズム詳細

### 並列アルゴリズム

並列アルゴリズム(parallel algorithm)とは、ExecutionPolicy(実行ポリシー)というテンプレートパラメーターのある関数テンプレートのことだ。既存の\<algorithm\>とC++14で追加された一部の関数テンプレートが、並列アルゴリズムに対応している。

並列アルゴリズムはイテレーター、仕様上定められた操作、ユーザーの提供する関数オブジェクトによる操作、仕様上定められた関数オブジェクトに対する操作によって、オブジェクトにアクセスする。そのような関数群を、要素アクセス関数(element access functions)と呼ぶ。

例えば、std::sortは以下のような要素アクセス関数を持つ。

+ テンプレート実引数で与えられたランダムアクセスイテレーター
+ 要素に対するswap関数の適用
+ ユーザー提供されたCompare関数オブジェクト

並列アルゴリズムが使う要素アクセス関数は、並列実行にともなう様々な制約を満たさなければならない。

### ユーザー提供する関数オブジェクトの制約

並列アルゴリズムのうち、テンプレートパラメーター名が、Predicate, BinaryPredicate, Compare, UnaryOperation, BinaryOperation, BinaryOperation1, BinaryOperation2となってるものは、関数オブジェクトとしてユーザーがアルゴリズムに提供するものである。このようなユーザー提供の関数オブジェクトには、並列アルゴリズムに渡す際の制約がある。

+ 実引数で与えられたオブジェクトを直接、間接に変更してはならない
+ 実引数で与えられたオブジェクトの一意性に依存してはならない
+ データ競合と同期

一部の特殊なアルゴリズムには例外もあるが、ほとんどの並列アルゴリズムではこの制約を満たさなければならない。

#### 実引数で与えられたオブジェクトを直接、間接に変更してはならない

ユーザー提供の関数オブジェクトは実引数で与えられたオブジェクトを直接、間接に変更してはならない。

つまり、以下のようなコードは違法だ。

~~~c++
int main()
{
    std::vector<int> c = { 1,2,3,4,5 } ;
    std::all_of( std::execution::par, std::begin(c), std::end(c),
        [](auto & x){ ++x ; return true ; } ) ;
    // エラー
}
~~~

これは、ユーザー提供の関数オブジェクトが実引数をlvalueリファレンスで受け取って変更しているので、並列アルゴリズムの制約を満たさない。

std::for_eachはイテレーターが変更可能な要素を返す場合、ユーザー提供の関数オブジェクトが実引数を変更することが可能だ。

~~~cpp
int main()
{
    std::vector<int> c = { 1,2,3,4,5 } ;
    std::for_each( std::execution::par, std::begin(c), std::end(c),
        [](auto & x ){ ++x ; } ) ;
    // OK
}
~~~

これは、for_eachは仕様上そのように定められているからだ。

#### 実引数で与えられたオブジェクトの一意性に依存してはならない

ユーザー提供の関数オブジェクトは実引数で与えられたオブジェクトの一意性に依存してはならない。

これはどういうことかというと、たとえば実引数で渡されたオブジェクトのアドレスを取得して、そのアドレスがアルゴリズムに渡したオブジェクトのアドレスと同じであることを期待するようなコードを書くことができない。

~~~c++
int main()
{
    std::vector<int> c = { 1,2,3,4,5 } ;

    // 最後の要素へのポインター
    int * ptr = &c[4] ;

    std::all_of( std::execution::par, std::begin(c), std::end(c),
        [=]( auto & x ){
            if ( ptr == &x )
                // 最後の要素なので特別な処理
                // エラー
        } ) ;
}
~~~

これはなぜかというと、並列アルゴリズムはその並列処理の一環として、要素のコピーを作成し、そのコピーをユーザー提供の関数オブジェクトに渡すかもしれないからだ。


~~~cpp
// 実装イメージ

template < typename ExecutionPolicy, typename ForwardIterator, typename Predicate >
bool all_of( ExecutionPolicy && exec, ForwardIterator first, ForwardIterator last, Predicate pred )
{
    if constexpr ( std::is_same_v< ExecutionPolicy, std::execution::parallel_policy> )
    {
        std::vector c( first, last ) ;
        do_all_of_par( std::begin(c), std::end(c), pred ) ;
    }
}
~~~

このため、オブジェクトの一意性に依存したコードを書くことはできない。

#### データ競合と同期

std::execution::sequenced_policyを渡した並列アルゴリズムによる要素アクセス関数の呼び出しは呼び出し側スレッドで実行される。パラレル実行ではない。

std::execution::parallel_policyを渡した並列アルゴリズムによる要素アクセス関数の呼び出しは、呼び出し側スレッドか、ライブラリ側で作られたスレッドのいずれかで実行される。それぞれの要素アクセス関数の呼び出しの同期は定められていない。そのため、要素アクセス関数はデータ競合やデッドロックを起こさないようにしなければならない。

以下のコードはデータ競合が発生するのでエラーとなる。

~~~c++
int main()
{
    int sum = 0 ;

    std::vector<int> c = { 1,2,3,4,5 } ;

    std::for_each( std::execution::par, std::begin(c), std::end(c),
        [&]( auto x ){ sum += x } ) ;
    // エラー、データ競合
}
~~~

なぜならば、ユーザー提供の関数オブジェクトは複数のスレッドから同時に呼び出されるかもしれないからだ。

std::execution::parallel_unsequenced_policyの実行は変わっている。未規定のスレッドから同期されない実行が許されている。これは、パラレルベクトル実行で想定している実行媒体がスレッドのような強い実行保証のある実行媒体ではなく、SIMDやGPGPUのような極めて軽い実行媒体であるからだ。

その結果、要素アクセス関数は通常のデータ競合やデッドロックを防ぐための手段すら取れなくなる。なぜならば、スレッドは実行の途中に中断して別の処理をしたりするからだ。

例えば、以下のコードは動かない。

~~~c++
int main()
{
    int sum = 0 ;
    std::mutex m ;

    std::vector<int> c = { 1,2,3,4,5 } ;

    std::for_each( std::execution::par_unseq, std::begin(c), std::end(c),
        [&]( auto x ) {
            std::scoped_lock l(m) ;
            sum += x ; 
        } ) ;
    // エラー
}
~~~

このコードはparallel_unsequenced_policyならば、非効率的ではあるが問題なく同期されてデータ競合なく動くコードだ。しかし、parallel_unsequenced_policyでは動かない。なぜならば、mutexのlockという同期をする関数を呼び出す体。

C++では、ストレージの確保解放以外の同期する標準ライブラリの関数をすべて、ベクトル化非安全(vectorization-unsafe)に分類している。ベクトル化非安全な関数はstd::execution::parallel_unsequenced_policyの要素アクセス関数内で呼び出すことはできない。

### 例外

並列アルゴリズムの実行中に、一時メモリーの確保が必要になったが確保できない場合、std::bad_allocがthrowされる。

並列アルゴリズムの実行中に、要素アクセス関数の外に例外が投げられた場合、std::terminateが呼ばれる。

### 実行ポリシー

実行ポリシーはヘッダーファイル\<execution\>で定義されている。その定義は以下のようになっている。

~~~c++
namespace std {
template<class T> struct is_execution_policy;
template<class T> inline constexpr bool is_execution_policy_v = is_execution_policy<T>::value;
}

namespace std::execution {

class sequenced_policy;
class parallel_policy;
class parallel_unsequenced_policy;

inline constexpr sequenced_policy seq{ };
inline constexpr parallel_policy par{ };
inline constexpr parallel_unsequenced_policy par_unseq{ };

}
~~~

#### is_execution_policy traits

std::is_execution_policy\<T\>はTが実行ポリシー型であるかどうかを返すtraitsだ。

~~~cpp
// false
constexpr bool b1 = std::is_execution_policy_v<int> ;
// true
constexpr bool b2 = std::is_execution_policy_v<std::execution::sequenced_policy> ;
~~~

#### シーケンス実行ポリシー

~~~c++
namespace std::execution {

class sequenced_policy ;
inline constexpr sequenced_policy seq { } ;

}
~~~

シーケンス実行ポリシーは、並列アルゴリズムにパラレル実行を行わせないためのポリシーだ。この実行ポリシーが渡された場合、処理は呼び出し元のスレッドだけで行われる。

#### パラレル実行ポリシー


~~~c++
namespace std::execution {

class parallel_policy ;
inline constexpr parallel_policy par { } ;

}
~~~

パラレル実行ポリシーは、並列アルゴリズムにパラレル実行を行わせるためのポリシーだ。この実行ポリシーが渡された場合、処理は呼び出し元のスレッドと、ライブラリが作成したスレッドを用いる。

#### パラレル非シーケンス実行ポリシー


~~~c++
namespace std::execution {

class parallel_unsequenced_policy ;
inline constexpr parallel_unsequenced_policy par_unseq { } ;

}
~~~

パラレル非シーケンス実行ポリシーは、並列アルゴリズムにパラレル実行かつベクトル実行を行わせるためのポリシーだ。この実行ポリシーが渡された場合、処理は複数のスレッドと、SIMDやGPGPUのようなベクトル実行による並列化を行う。

#### 実行ポリシーオブジェクト

~~~c++
namespace std::execution {

inline constexpr sequenced_policy seq{ };
inline constexpr parallel_policy par{ };
inline constexpr parallel_unsequenced_policy par_unseq{ };

}
~~~

実行ポリシーの型を直接書くのは面倒だ。

~~~c++
std::for_each( std::execution::parallel_policy{}, ... ) ;
~~~

そのため、標準ライブラリは実行ポリシーのオブジェクトを用意している。seqとparとpar_unseqがある。

~~~c++
std::for_each( std::execution::par, ... ) ;
~~~

並列アルゴリズムを使うには、このオブジェクトを並列アルゴリズムの第一引数に渡すことになる。
