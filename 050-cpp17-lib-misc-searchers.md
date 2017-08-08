## Searcher : 検索

C++17では\<functional\>にsearcherというライブラリが追加された。これは順序のあるオブジェクトの集合に、ある部分集合(パターン)が含まれているかどうかを検索するためのライブラリだ。その最も一般的な応用例は文字列検索となる。

searcherの基本的な設計としては、クラスのオブジェクトを構築して、コンストラクターで検索したい部分集合(パターン)を与え、operator ()で部分集合が含まれているかを検索したい集合を与える。

この設計のライブラリが追加された理由は、パターンの検索のために何らかの事前の準備を状態として保持しておきたい検索アルゴリズムを実装するためだ。

### default_searcher

クラスstd::default_searcherは以下のように宣言されている。

~~c++
template < class ForwardIterator1, class BinaryPredicate = equal_to<> >
class default_searcher {
public:
    // コンストラクター
    default_searcher( 
        ForwardIterator1 pat_first, ForwardIterator1 pat_last
        , BinaryPredicate pred = BinaryPredicate() ) ;

    // operator ()
    template <class ForwardIterator2>
    pair<ForwardIterator2, ForwardIterator2>
    operator()(ForwardIterator2 first, ForwardIterator2 last) const ;
} ;
~~~

コンストラクターで部分集合を受け取る。operator ()で集合を受け取り、部分集合(パターン)と一致した場所をイテレーターのペアで返す。見つからない場合、イテレーターのペアは[last, last)になっている。

以下のように使う。

~~~c++
int main()
{
    std::string pattern("fox") ;
    std::default_searcher fox_searcher( std::begin(pattern), std::end(pattern) ) ;

    std::string corpus = "The quick brown fox jumps over the lazy dog" ;

    auto[first, last] = fox_searcher( std::begin(s), std::end(s) ) ;
    std::string fox( first, last ) ;
}
~~~

default_searcherの検索は、内部的にstd::searchが使われる。

### boyer_moore_searcher

std::boyer_moore_searcherはBoyer-Moore文字列検索アルゴリズムを使って部分集合の検索を行う。

Boyer-Moore文字列検索アルゴリズムは極めて効率的な文字列検索のアルゴリズムだ。Boyer-MooreアルゴリズムはBob BoyerとStrother Mooreによって発明され、1977年のCommunications of the ACMで発表された。その内容は以下のURLで読むことができる。

<http://www.cs.utexas.edu/~moore/publications/fstrpos.pdf>

Boyer-Mooreアルゴリズムは事前に検索するパターンから二つのテーブルを生成する必要がある。このため、Boyer-Mooreアルゴリズムはメモリ使用量と検索前の準備時間というコストがかかる。そのコストは、より効率的な検索により相殺できる。特に、パターンが長い場合は効果的だ。

C++17に入るBoyer_mooreアルゴリズムに基づく検索は、テンプレートを使った汎用的なchar型のような状態数の少ない型に対して

クラスboyer_moore_searcherは以下のように宣言されている。

~~~c++
template < class RandomAccessIterator1,
            class Hash = hash<typename iterator_traits<RandomAccessIterator1>::value_type>,
            class BinaryPredicate = equal_to<> >
class boyer_moore_searcher {
public:
    // コンストラクター
    boyer_moore_searcher(
        RandomAccessIterator1 pat_first, RandomAccessIterator1 pat_last,
        Hash hf = Hash(),
        BinaryPredicate pred = BinaryPredicate() ) ;

    // operator ()
    template <class RandomAccessIterator2>
    pair<RandomAccessIterator2, RandomAccessIterator2>
    operator()(RandomAccessIterator2 first, RandomAccessIterator2 last) const;
} ;
~~~

boyer_moore_searcheは、文字列以外にも適用できる汎用的な設計のため、ハッシュ関数を取る。char型のような取りうる状態数の少ない型以外が渡された場合は、std::unordered_mapのようなメモリ使用量を削減できる何らかのデータ構造を使ってテーブルを構築する。

使い方はdefault_searcherとほとんど変わらない。


~~~c++
int main()
{
    std::string pattern("fox") ;
    std::boyer_moore_searcher fox_searcher( std::begin(pattern), std::end(pattern) ) ;

    std::string corpus = "The quick brown fox jumps over the lazy dog" ;

    auto[first, last] = fox_searcher( std::begin(s), std::end(s) ) ;
    std::string fox( first, last ) ;
}
~~~


### boyer_moore_horspool_searcher

std::boyer_moore_horspool_searcherはBoyer-Moore-Horspool検索アルゴリズムを使って部分集合の検索を行う。Boyer_Moore-HorspoolアルゴリズムはNigel Horspoolによって1980年に発表された。

参考: "Practical fast searching in strings" 1980

Boyer-Moore-Horspoolアルゴリズムは内部テーブルに使うメモリー使用量を削減しているが、最悪計算量の点でオリジナルのBoyer-Mooreアルゴリズムには劣っている。つまり、実行時間の増大を犠牲にしてメモリ使用量を削減したトレードオフなアルゴリズムと言える。

クラスboyer_moore_horspool_searcherの宣言は以下の通り。

~~~c++
template <  class RandomAccessIterator1,
            class Hash = hash<typename iterator_traits<RandomAccessIterator1>::value_type>,
            class BinaryPredicate = equal_to<> >
class boyer_moore_horspool_searcher {
public:
    // コンストラクター
    boyer_moore_horspool_searcher(
        RandomAccessIterator1 pat_first, RandomAccessIterator1 pat_last,
        Hash hf = Hash(),
        BinaryPredicate pred = BinaryPredicate() );

    // operator () 
    template <class RandomAccessIterator2>
    pair<RandomAccessIterator2, RandomAccessIterator2>
    operator()(RandomAccessIterator2 first, RandomAccessIterator2 last) const;
} ;
~~~

使い方はboyer_moore_horspool_searcherと変わらない。




~~~c++
int main()
{
    std::string pattern("fox") ;
    std::boyer_moore_horspool_searcher fox_searcher( std::begin(pattern), std::end(pattern) ) ;

    std::string corpus = "The quick brown fox jumps over the lazy dog" ;

    auto[first, last] = fox_searcher( std::begin(s), std::end(s) ) ;
    std::string fox( first, last ) ;
}
~~~
