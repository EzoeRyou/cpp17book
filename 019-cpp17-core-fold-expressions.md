## fold式

C++17にはfold式が入った。foldは元は数学の概念で畳み込みとも呼ばれている。

C++におけるfold式とはパラメーターパックの中身に二項演算子を適用するための式だ。

今、可変長テンプレートを使って受け取った値をすべて加算した合計を返す関数sumを書きたいとする。

~~~cpp

template < typename T, typename ... Types >
auto sum( T x, Types ... args ) ;

int main()
{
    int result = sum(1,2,3,4,5,6,7,8,9) ; // 45
}
~~~

このような関数テンプレートsumは以下のように実装することができる。

~~~cpp
template < typename T >
auto sum( T x )
{
    return x ;
}

template < typename T, typename ... Types >
auto sum( T x, Types ... args )
{
    return x + sum( args... )  ;
}
~~~

sum(x, args)は1番目の引数をxで、残りをパラメーターパックargsで受け取る。そして、x + sum( args ... )を返す。すると、sum( args ... )はまたsum(x, args)に渡されて、1番目の引数、つまり最初から見て2番目の引数がxに入り、またsumが呼ばれる。このような再帰的な処理を繰り返していく。

そして、引数がひとつだけになると、可変長テンプレートではないsumが呼ばれる。これは重要だ。なぜならば可変長テンプレートは0個の引数を取ることができるので、そのまま可変長テンプレート版のsumが呼ばれてしまうと、次のsumの呼び出しができずにエラーとなる。これを回避するために、また再帰の終了条件のために、引数がひとつのsumのオーバーロード関数を書いておく。

可変長テンプレートでは任意個の引数に対応するために、このような再帰的なコードが必須になる。

しかし、ここで実現したいこととはN個あるパラメーターパックargsの中身に対して、仮にN番目をargs#Nとする表記を使うと、args#0 + args#1 + ... + args#Nのような展開をしたいだけだ。C++17のfold式はパラメーターパックに対して二項演算子を適用する展開を行う機能だ。

fold式を使うとsumは以下のように書ける。

~~~cpp
template < typename ... Types >
auto sum( Types ... args )
{
    return ( ... + args )  ;
}
~~~

( ... + args )は、args#0 + args#1 + ... + args#Nのように展開される。

fold式には、単項fold式と二項fold式がある。そして、演算子の結合順序に合わせて左foldと右foldがある。

fold式は必ず括弧で囲まなければならない。

~~~cpp
template < typename ... Types >
auto sum( Types ... args )
{
    // fold式
    ( ... + args )  ;
    // エラー、括弧がない
    ... + args ;
}
~~~

単項fold式の文法は以下のいずれかになる。


~~~
単項右fold
( cast-expression fold-operator ... )
単項左fold
( ... fold-operator cast-expression )
~~~

例

~~~cpp
template < typename ... Types >
void f( Types ... args )
{
    // 単項左fold
    ( ... + args )  ;
    // 単項右fold
    ( args + ... ) ;
}
~~~

cast-expressionには未展開のパラメーターパックが入っていなければならない。

例：

~~~c++
template < typename T >
T f( T x ) { return x ; }

template < typename ... Types >
auto g( Types ... args )
{
    // f(args#0) + f(args#1) + ... + f(args#N)
    return ( ... + f(args) )  ;
}
~~~

これはf(args)というパターンが展開される。

fold-operatorにはいかのいずれかの二項演算子を使うことができる。


~~~
+   -   *   /   %   ^   &   |   <<  >>
+=  -=  *=  /=  %=  ^=  &=  |=  <<= >>+ =
==  !=  <   >   <=  >=  &&  ||  ,   .*  ->*
~~~

fold式には左foldと右foldがある。

左fold式の( ... op pack )では、展開結果は((( pack#0 op pack#1 ) op pack#2 ) ... op pack#N )となる。右fold式の( pack op ... )では、展開結果は( pack#0 op ( pack#1 op ( pack#2 op ( ... op pack#N ))))となる。

~~~cpp
template < typename ... Types >
void sum( Types ... args )
{
    // 左fold
    // ((((1+2)+3)+4)+5)
    auto left = ( ... + args ) ;
    // 右fold
    // (1+(2+(3+(4+5))))
    auto right = ( args + ... ) ;
}

int main()
{
    sum(1,2,3,4,5) ;
}
~~~

浮動小数点数のような交換法則を満たさない型にfold式を適用する際には注意が必要だ。


二項fold式の文法は以下のいずれかになる。

~~~c++
( cast-expression fold-operator ... fold-operator cast-expression )
~~~

左右のcast-expressionのどちらか片方だけに未展開のパラメーターパックが入っていなければならない。2つのfold-operatorは同じ演算子でなければならない。


( e1 op1 ... op2 e2 )という二項fold式があったとき、e1にパラメーターパックがある場合は二項右fold式、e2にパラメーターパックがある場合は二項左fold式になる。


~~~cpp
template < typename ... Types >
void sum( Types ... args )
{
    // 左fold
    // (((((0+1)+2)+3)+4)+5)
    auto left = ( 0 + ... + args ) ;
    // 右fold
    // (0+(1+(2+(3+(4+5)))))
    auto right = ( args + ... + 0 ) ;
}

int main()
{
    sum(1,2,3,4,5) ;
}
~~~

fold式はパラメーターパックのそれぞれに二項演算子を適用したい時にわざわざ複雑な再帰的テンプレートを書かずにすむ方法を提供してくれる。

機能テストマクロは__cpp_fold_expressions, 値は201603。
