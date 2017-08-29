## sample: 乱択アルゴリズム

~~~c++
template <  class PopulationIterator, class SampleIterator,
            class Distance, class UniformRandomBitGenerator >

SampleIterator sample(
    PopulationIterator first, PopulationIterator last,
    SampleIterator out,
    Distance n, UniformRandomBitGenerator&& g) ;
~~~

C++17で\<algorithm\>に追加されたstd::sampleは、標本を確率的に選択するための乱択アルゴリズムだ。

[first, last)は標本を選択する先の集合を指すイテレーター。outは標本を出力する先のイテレーター。nは選択する標本の個数。gは標本を選択するのに使う乱数生成器。戻り値はout。

ある要素の集合から、n個の要素を確率的に公平に選択したい場合に使うことができる。

### 乱択アルゴリズム

std::sampleを使う前に、まず正しい乱択アルゴリズムについて学ぶ必要がある。乱択アルゴリズムについて詳しくは、Donald E. KnuthのThe Arf of Computer Programming(以下TAOCP、邦訳はアスキードワンゴから同名の書名で出版されている)を参照。

ユーザーからの入力、計測した気象情報のデータ、サーバーへのアクセスログなど、世の中には膨大な量のデータが存在する。これらの膨大なデータをすべて処理するのではなく、標本を採取することによって、統計的にそれなりに信頼できる確率で正しい全体のデータを推定することができる。そのためにはn個の標本をバイアスがかからない方法で選択する必要がある。バイアスのかからない方法でn個の標本を取り出すには、集合の先頭からn個とか、一つおきにn個といった方法で選択してはならない。それはバイアスがかかっている。

ある値の集合から、バイアスのかかっていないn個の標本を得るには、集合のすべての値が等しい確率で選ばれた上でn個を選択しなければならない。一体どうすればいいのだろうか。

std::sampleを使えば、100個の値から10個の標本を得るのは、以下のように書くことが可能だ。

~~~cpp
int main()
{
    // 100個の値の集合
    std::vector<int> pop(100) ;
    std::iota( std::begin(pop), std::end(pop), 0 ) ;

    // 標本を格納するコンテナー
    std::vector<int> out(10) ;

    // 乱数生成器
    std::array<std::uint32_t, sizeof(std::knuth_b)/4> a ;
    std::random_device r ;
    std::generate( std::begin( a ), std::end(a), [&]{ return r() ; } ) ;
    std::seed_seq seed( std::begin(a), std::end(a) ) ;
    std::knuth_b g( seed ) ;

    // 10個の標本を得る。
    sample( std::begin(pop), std::end(pop), std::begin(out), 10, g ) ;

    // 標本を出力
    std::copy( std::begin(out), std::end(out), std::ostream_iterator<int>(std::cout, ", ") ) ;
}
~~~

集合に含まれる値の数がN個だと分かっているならば、それぞれの値について$n/m$の確率で選ぶというのはどうだろうか。100個中10個を選ぶのであれば、$1/10$の確率でそれぞれの値を標本として選択することになる。

この考えに基づく乱択アルゴリズムは以下のようになる。

1. 集合の要素数をN、選択すべき標本の数をn、iを0とする。
2. 0ベースインデックスでi番目の値を$n/m$の確率で標本として選択する
3. iをインクリメントする
4. i != Nならばgoto 2.

このアルゴリズムをコードで書くと以下のようになる。

~~~c++
template <  class PopulationIterator, class SampleIterator,
            class Distance, class UniformRandomBitGenerator >
SampleIterator sample(
    PopulationIterator first, PopulationIterator last,
    SampleIterator out,
    Distance n, UniformRandomBitGenerator&& g)
{
    auto N = std::distance( first, last ) ;

    // 確率n/Nでtrueを返すベルヌーイ分布
    double probability = double(n)/double(N) ;
    std::bernoulli_distribution d( probability ) ;

    // それぞれの値に対して
    std::for_each( first, last,
        [&]( auto && value )
        {
            if ( d(g) )
            {// n/Nの確率で標本として選択する
                *out = value ;
                ++out ;
            }
        } ) ;

    return out ;
}
~~~

残念ながらこのアルゴリズムは正しく動かない。この例では、100個の値の集合から10個の標本を選択したい。しかし、選ばれる標本の数はプログラムの実行ごとに異なる。このアルゴリズムは、標本の数が平均的に10個選ばれることが期待できるが、運が悪いと0個や100個の標本が選ばれてしまう可能性がある。

ちなみに、TAOCP Vol.2によれば、このとき選ばれる標本数の標準偏差は$\sqrt{n(1-n/N)}$になる。

正しいアルゴリズムは、要素の集合のうちの$(t+1)$番目の要素は、すでにm個の要素が標本として選ばれたとき、$(n-m)(N-t)$の確率で選ぶものだ。


### アルゴリズムS：選択標本、要素数が分かっている集合からの標本の選択

KnuthのTAOCP Vol.2では、アルゴリズムSと称して、要素数の分かっている集合から標本を選択する方法を解説している。

アルゴリズムRは以下の通り。

$0 < n \leq N$ のとき、N個の集合からn個の標本をランダムに選択する。

1. t, mを0とする。tはこれまでに処理した要素数、mは標本として選択した要素数とする。
2. $0 \leq U \leq N - t$の範囲の乱数Uを生成する
3. $U \geq n - m$であればgoto 5.
4. 次の要素を標本として選択する。mとtをインクリメントする。$m < n$であれば、goto 2. そうでなければ標本は完了したのでアルゴリズムは終了する
5. 次の要素を標本として選択しない。tをインクリメントする。goto 2.

実装は以下のようになる。

~~~cpp
template <  class PopulationIterator, class SampleIterator,
            class Distance, class UniformRandomBitGenerator >
SampleIterator
sample_s(
    PopulationIterator first, PopulationIterator last,
    SampleIterator out,
    Distance n, UniformRandomBitGenerator&& g)
{
    // 1.
    Distance t = 0 ;
    Distance m = 0 ;
    const auto N = std::distance( first, last ) ;

    auto r = [&]{
        std::uniform_int_distribution<> d(0, N-t) ;
        return d(g) ;
    } ;

    while ( m < n  && first != last )
    {
        // 2. 3.
        if ( r() >= n - m )
        {// 5.
            ++t ;
            ++first ;
        }
        else { // 4.
            *out = *first ;
            ++first ; ++out ;
            ++m ; ++t ;
        }
    }
    
    return out ;
}
~~~


### アルゴリズムR：保管標本、要素数がわからない集合からの標本の選択

アルゴリズムSは集合の要素数がN個であると分かっている場合に、n個の標本を選択するアルゴリズムだ。では、もしNがわからない場合はどうすればいいのだろうか。

現実にはNがわからない状況がよくある。

+ ユーザーからの入力
+ シーケンシャルアクセスしか提供しておらず全部読み込まなければ要素数のわからないテープデバイスからの入力
+ ガイガーカウンターからの入力

このような要素数のわからない入力にアルゴリズムSを適用するには、まず一度全部入力を得て、全体の要素数を確定させた上で、全要素に対してアルゴリズムSを適用させるという2段階の方法を使うことができる。

しかし、1段階の要素の巡回だけで済ませたい。要素数のわからない入力を処理して、その時点で公平に選択された標本を得たい。

アルゴリズムRはそのような状況で使えるアルゴリズムだ。

アルゴリズムRでは、要素数のわからない要素の集合からn個の標本を選択する。そのために標本として選択した要素を保管しておき、新しい入力が与えられるたびに、標本として選択するかどうかの判断をし、選択をするのであれば、保管しておいた既存の標本と置き換える。

アルゴリズムRは以下の通り(このアルゴリズムはknuth本とは違う)

$n > 0$のとき、$size \geq n$である未確定のsize個の要素数をもつ入力から、n個の標本をランダムに選択する。標本の候補はn個まで保管される。$1 \leq j \leq n$のときI[j]は保管された標本を指す。

1. 入力から最初のn個を標本として選択し、保管する。$1 \leq j \leq n$の範囲でI[j]にj番目の標本を保管する。tの値をnとする。I[1], ..., I[n]は現在の標本を指す。tは現在処理した入力の個数を指す。
2. 入力の終わりであればアルゴリズムを終了する。
3. tをインクリメントする。$1 \leq M \leq t$の範囲の乱数Mを生成する。$M > n$ ならばgoto 5.
4. 次の入力をI[M]に保管する。goto 2.
5. 次の入力を保管しない。goto 2.

実装は以下のようになる。

~~~cpp
template <  class PopulationIterator, class SampleIterator,
            class Distance, class UniformRandomBitGenerator >

SampleIterator sample_r(
    PopulationIterator first, PopulationIterator last,
    SampleIterator out,
    Distance n, UniformRandomBitGenerator&& g)
{
    Distance t = 0 ;

    auto result = out ;

    for ( ; (first != last) && (t != n) ; ++first, ++t, ++result  )
    {
        out[t] = *first ;
    }

    if ( t != n )
        return result ;


    auto I = [&](Distance j) -> decltype(auto) { return out[j-1] ;} ;

    while ( first != last )
    {
        ++t ;
        std::uniform_int_distribution<Distance> d( 1, t ) ;
        auto M = d(g) ;

        if ( M > n )
        {
            ++first ;
        }
        else {
            I(M) = *first ;
            ++first ;
        }
    }

    return result ;
}
~~~

### C++のsample

個々まで説明したように、乱択アルゴリズムには2種類ある。入力の要素数が分かっている場合のアルゴリズムS(選択標本)と、入力の要素数がわからない場合のアルゴリズムR(保管標本)だ。

しかし、C++に追加された乱択アルゴリズムの関数テンプレートの宣言は、はじめに説明したように以下の一つしかない。並列アルゴリズムには対応していない。

~~~c++
template<
    class PopulationIterator, class SampleIterator,
    class Distance, class UniformRandomBitGenerator >
SampleIterator
sample(
    PopulationIterator first, PopulationIterator last,
    SampleIterator out,
    Distance n, UniformRandomBitGenerator&& g) ;
~~~

[first, last)は標本を選択する先の集合を指すイテレーター。outは標本を出力する先のイテレーター。nは選択する標本の個数。gは標本を選択するのに使う乱数生成器。戻り値はout。

sampleはPopulationIteratorとSampleIteratorのイテレーターカテゴリーによって、どちらのアルゴリズムを使うべきか判断している。

アルゴリズムS(選択標本)を使う場合、PopulationIteratorは前方イテレーター、SampleIteratorは出力イテレーターを満たさなければならない。

アルゴリズムR(保管標本)を使う場合、PopulationIteratorは入力イテレーター、SampleIteratorはランダムアクセスイテレーターを満たさなければならない。

これはどういうことかというと、要素数の取得のためには、入力元のPopulationIterator [first, last)から要素数を得る必要があり、そのためにはPopulationIteratorは前方イテレーターを満たしていなければならない。その場合、選択した標本はそのままイテレーターに出力すればいいので、出力先のSampleIteratorは出力イテレーターを満たすだけでよい。

もし入力元のPopulationIteratorが入力イテレーターしか満たさない場合、この場合はPopulationIteratorの[first, last)から要素数を得ることができないので、要素数がわからないときに使えるアルゴリズムR(保管標本)を選択せざるを得ない。その場合、入力を処理するに連れて、新たに選択した標本が既存の標本を上書きするので、出力先のSampleIteratorはランダムアクセスイテレーターである必要がある。

~~~cpp
int main()
{
    std::vector<int> input ;

    std::knuth_b g ;

    // PopulationIteratorは前方イテレーターを満たす
    // SampleIteratorは出力イテレーターでよい
    std::sample(    std::begin(input), std::end(input),
                    std::ostream_iterator<int>(std::cout), 100
                    g ) ;

    std::vector<int> sample(100) ;

    // PopulationIteratorは入力イテレーターしか満たさない
    // SampleIteratorにはランダムアクセスイテレーターが必要
    std::sample(    std::istream_iterator<int>(std::cin), std::istream_iterator<int>{},
                    std::begin(sample), 100,
                    g ) ;

}
~~~

注意が必要なこととして、C++のsampleは入力元のPopulationIteratorが前方イテレーター以上を満たす場合は、かならずアルゴリズムS(選択標本)を使うということだ。これはつまり、要素数を得るためにstd::distance(first, last)が行われるということを意味する。もしこの処理が非効率的なイテレーターを渡した場合、必要以上に非効率的なコードになってしまう。


例えば以下のコードは、

~~~cpp
int main()
{
    std::list<int> input(10000) ;
    std::list<int> sample(100) ;
    std::knuth_b g ;

    std::sample( std::begin(input), std::end(input), std::begin(sample), 100, g ) ;
}
~~~

以下のような意味を持つ。

~~~cpp
int main()
{
    std::list<int> input(10000) ;
    std::list<int> sample(100) ;
    std::knuth_b g ;

    std::size_t count = 0 ;
    
    // 要素数の得るためにイテレーターを回す
    // 非効率的
    for( auto && e : input )
    { ++count ; }

    // 標本の選択のためにイテレーターを回す
    for ( auto && e : input )
    {/* 標本の選択 */}
}
~~~

std::listのメンバー関数sizeは定数時間であることが保障されているため、このコードにおけるイテレーターを回すループは一回に抑えられる。しかし、std::sampleは要素数を渡す実引数がないために要素数がイテレーターを全走査しなくても分かっている場合でも、非効率的な処理を行わなければならない。

もしランダムアクセスイテレーター未満、前方イテレーター以上のイテレーターカテゴリーのイテレーターの範囲から標本を選択したい場合で、イテレーターの範囲の指す要素数が予め分かっている場合は、自前でアルゴリズムSを実装したほうが効率がよい。


~~~cpp
template <  class PopulationIterator, class SampleIterator,
            class Distance, class UniformRandomBitGenerator >
SampleIterator
sample_s(
    PopulationIterator first, PopulationIterator last,
    Distance size,
    SampleIterator out,
    Distance n, UniformRandomBitGenerator&& g)
{
    // 1.
    Distance t = 0 ;
    Distance m = 0 ;
    const auto N = size ;

    auto r = [&]{
        std::uniform_int_distribution<> d(0, N-t) ;
        return d(g) ;
    } ;

    while ( m < n  && first != last )
    {
        // 2. 3.
        if ( r() >= n - m )
        {// 5.
            ++t ;
            ++first ;
        }
        else { // 4.
            *out = *first ;
            ++first ; ++out ;
            ++m ; ++t ;
        }
    }
    
    return out ;
}
~~~
