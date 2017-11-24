## sample: 乱択アルゴリズム

~~~c++
template <  class PopulationIterator, class SampleIterator,
            class Distance, class UniformRandomBitGenerator >

SampleIterator sample(
    PopulationIterator first, PopulationIterator last,
    SampleIterator out,
    Distance n, UniformRandomBitGenerator&& g) ;
~~~

C++17で`<algorithm>`に追加された`std::sample`は、標本を確率的に選択するための乱択アルゴリズムだ。

`[first, last)`は標本を選択する先の集合を指すイテレーター。`out`は標本を出力する先のイテレーター。`n`は選択する標本の個数。`g`は標本を選択するのに使う乱数生成器。戻り値は`out`。

ある要素の集合から、`n`個の要素を確率的に公平に選択したい場合に使うことができる。

### 乱択アルゴリズム

`std::sample`を使う前に、まず正しい乱択アルゴリズムについて学ぶ必要がある。乱択アルゴリズムについて詳しくは、Donald E. Knuthの _The Arf of Computer Programming_ （以下TAOCP、邦訳はアスキードワンゴから同名の書名で出版されている）を参照。

ユーザーからの入力、計測した気象情報のデータ、サーバーへのアクセスログなど、世の中には膨大な量のデータが存在する。これらの膨大なデータをすべて処理するのではなく、標本を採取することによって、統計的にそれなりに信頼できる確率で正しい全体のデータを推定することができる。そのためには$n$個の標本をバイアスがかからない方法で選択する必要がある。バイアスのかからない方法で$n$個の標本を取り出すには、集合の先頭から$n$個とか、1つおきに$n$個といった方法で選択してはならない。それはバイアスがかかっている。

ある値の集合から、バイアスのかかっていない$n$個の標本を得るには、集合のすべての値が等しい確率で選ばれた上で$n$個を選択しなければならない。いったいどうすればいいのだろうか。

`std::sample`を使えば、100個の値から10個の標本を得るのは、以下のように書くことが可能だ。

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
    std::generate( std::begin(a), std::end(a), [&]{ return r() ; } ) ;
    std::seed_seq seed( std::begin(a), std::end(a) ) ;
    std::knuth_b g( seed ) ;

    // 10個の標本を得る
    sample( std::begin(pop), std::end(pop), std::begin(out), 10, g ) ;

    // 標本を出力
    std::copy(  std::begin(out), std::end(out),
                std::ostream_iterator<int>(std::cout, ", ") ) ;
}
~~~

集合に含まれる値の数が$N$個だとわかっているならば、それぞれの値について$n/m$の確率で選ぶというのはどうだろうか。100個中10個を選ぶのであれば、$1/10$の確率でそれぞれの値を標本として選択することになる。

この考えに基づく乱択アルゴリズムは以下のようになる。

1. 集合の要素数を$N$、選択すべき標本の数を$n$, $i$を0とする。
2. 0ベースインデックスで$i$番目の値を$n/m$の確率で標本として選択する
3. $i$をインクリメントする
4. $i\ != N$ならばgoto 2.

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

ちなみに、TAOCP Vol. 2によれば、このとき選ばれる標本数の標準偏差は$\sqrt{n(1-n/N)}$になる。

正しいアルゴリズムは、要素の集合のうちの$(t+1)$番目の要素は、すでに$m$個の要素が標本として選ばれたとき、$(n-m)(N-t)$の確率で選ぶものだ。


### アルゴリズムS：選択標本、要素数がわかっている集合からの標本の選択

KnuthのTAOCP Vol. 2では、アルゴリズムSと称して、要素数のわかっている集合から標本を選択する方法を解説している。

アルゴリズムRは以下のとおり。

$0 < n \leq N$ のとき、$N$個の集合から$n$個の標本をランダムに選択する。

1. $t$, $m$を0とする。$t$はこれまでに処理した要素数、$m$は標本として選択した要素数とする。
2. $0 \leq U \leq N - t$の範囲の乱数$U$を生成する。
3. $U \geq n - m$であればgoto 5。
4. 次の要素を標本として選択する。$m$と$t$をインクリメントする。$m < n$であれば、goto 2。そうでなければ標本は完了したのでアルゴリズムは終了する。
5. 次の要素を標本として選択しない。$t$をインクリメントする。goto 2。

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

アルゴリズムSは集合の要素数が$N$個であるとわかっている場合に、$n$個の標本を選択するアルゴリズムだ。では、もし$N$がわからない場合はどうすればいいのだろうか。

現実には$N$がわからない状況がよくある。

+ ユーザーからの入力
+ シーケンシャルアクセスしか提供しておらず全部読み込まなければ要素数のわからないテープデバイスからの入力
+ ガイガーカウンターからの入力

このような要素数のわからない入力にアルゴリズムSを適用するには、まず一度全部入力を得て、全体の要素数を確定させた上で、全要素に対してアルゴリズムSを適用させるという2段階の方法を使うことができる。

しかし、1段階の要素の巡回だけで済ませたい。要素数のわからない入力を処理して、その時点で公平に選択された標本を得たい。

アルゴリズムRはそのような状況で使えるアルゴリズムだ。

アルゴリズムRでは、要素数のわからない要素の集合から$n$個の標本を選択する。そのために標本として選択した要素を保管しておき、新しい入力が与えられるたびに、標本として選択するかどうかの判断をし、選択をするのであれば、保管しておいた既存の標本と置き換える。

アルゴリズムRは以下のとおり（このアルゴリズムはKnuth本とは違う）

$n > 0$のとき、$size \geq n$である未確定の$size$個の要素数を持つ入力から、$n$個の標本をランダムに選択する。標本の候補は$n$個まで保管される。$1 \leq j \leq n$のとき$I[j]$は保管された標本を指す。

1. 入力から最初のn個を標本として選択し、保管する。$1 \leq j \leq n$の範囲で$I[j]$に$j$番目の標本を保管する。$t$の値を$n$とする。$I[1]$, ..., $I[n]$は現在の標本を指す。$t$は現在処理した入力の個数を指す。
2. 入力の終わりであればアルゴリズムを終了する。
3. $t$をインクリメントする。$1 \leq M \leq t$の範囲の乱数$M$を生成する。$M > n$ ならばgoto 5。
4. 次の入力を$I[M]$に保管する。goto 2。
5. 次の入力を保管しない。goto 2。

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

    for ( ; (first != last) && (t != n) ; ++first, ++t, ++result )
    {
        out[t] = *first ;
    }

    if ( t != n )
        return result ;


    auto I = [&](Distance j) -> decltype(auto) { return out[j-1] ; } ;

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

ここまで説明したように、乱択アルゴリズムには2種類ある。入力の要素数がわかっている場合のアルゴリズムS（選択標本）と、入力の要素数がわからない場合のアルゴリズムR（保管標本）だ。

しかし、C++に追加された乱択アルゴリズムの関数テンプレートの宣言は、はじめに説明したように以下の1つしかない。並列アルゴリズムには対応していない。

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

`[first, last)`は標本を選択する先の集合を指すイテレーター。`out`は標本を出力する先のイテレーター。`n`は選択する標本の個数。`g`は標本を選択するのに使う乱数生成器。戻り値は`out`。

`sample`は`PopulationIterator`と`SampleIterator`のイテレーターカテゴリーによって、どちらのアルゴリズムを使うべきか判断している。

アルゴリズムS（選択標本）を使う場合、`PopulationIterator`は前方イテレーター、`SampleIterator`は出力イテレーターを満たさなければならない。

アルゴリズムR（保管標本）を使う場合、`PopulationIterator`は入力イテレーター、`SampleIterator`はランダムアクセスイテレーターを満たさなければならない。

これはどういうことかというと、要素数の取得のためには、入力元の`PopulationIterator [first, last)`から要素数を得る必要があり、そのためには`PopulationIterator`は前方イテレーターを満たしていなければならない。その場合、選択した標本はそのままイテレーターに出力すればいいので、出力先の`SampleIterator`は出力イテレーターを満たすだけでよい。

もし入力元の`PopulationIterator`が入力イテレーターしか満たさない場合、この場合は`PopulationIterator`の`[first, last)`から要素数を得ることができないので、要素数がわからないときに使えるアルゴリズムR（保管標本）を選択せざるを得ない。その場合、入力を処理するに連れて、新たに選択した標本が既存の標本を上書きするので、出力先の`SampleIterator`はランダムアクセスイテレーターである必要がある。

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
    std::sample(
        std::istream_iterator<int>(std::cin),
        std::istream_iterator<int>{},
        std::begin(sample), 100, g ) ;

}
~~~

注意が必要なこととして、C++の`sample`は入力元の`PopulationIterator`が前方イテレーター以上を満たす場合は、かならずアルゴリズムS（選択標本）を使うということだ。これはつまり、要素数を得るために`std::distance(first, last)`が行われるということを意味する。もしこの処理が非効率的なイテレーターを渡した場合、必要以上に非効率的なコードになってしまう。


たとえば以下のコードは、

~~~cpp
int main()
{
    std::list<int> input(10000) ;
    std::list<int> sample(100) ;
    std::knuth_b g ;

    std::sample(    std::begin(input), std::end(input),
                    std::begin(sample), 100, g ) ;
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

`std::list`のメンバー関数`size`は定数時間であることが保障されているため、このコードにおけるイテレーターを回すループは1回に抑えられる。しかし、`std::sample`は要素数を渡す実引数がないために要素数がイテレーターを全走査しなくてもわかっている場合でも、非効率的な処理を行わなければならない。

もしランダムアクセスイテレーター未満、前方イテレーター以上のイテレーターカテゴリーのイテレーターの範囲から標本を選択したい場合で、イテレーターの範囲の指す要素数があらかじめわかっている場合は、自前でアルゴリズムSを実装したほうが効率がよい。


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
