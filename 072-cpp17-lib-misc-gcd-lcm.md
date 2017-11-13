## 最大公約数（gcd）と最小公倍数（lcm）

C++17ではヘッダーファイル`<numeric>`に最大公約数（`gcd`）と最小公倍数（`lcm`）が追加された。

~~~cpp
int main()
{
    int a, b ;

    while( std::cin >> a >> b )
    {
        std::cout
            << "gcd: " << gcd(a,b)
            << "\nlcm: " << lcm(a,b) << '\n' ;
    }
}
~~~

### gcd : 最大公約数

~~~c++
template <class M, class N>
constexpr std::common_type_t<M,N> gcd(M m, N n)
{
    if ( n == 0 )
        return m ;
    else
        return gcd( n, std::abs(m) % std::abs(n) ) ; 
}
~~~

`gcd(m, n)`は`m`と`n`がともにゼロの場合ゼロを返す。それ以外の場合、$|m|$と$|n|$の最大公約数（Greatest Common Divisor）を返す。

### lcm : 最小公倍数

~~~c++
template <class M, class N>
constexpr std::common_type_t<M,N> lcm(M m, N n)
{
    if ( m == 0 || n == 0 )
        return 0 ;
    else
        return std::abs(m) / gcd( m, n ) * std::abs(n) ;
}
~~~

`lcm(m,n)`は、`m`と`n`のどちらかがゼロの場合ゼロを返す。それ以外の場合、$|m|$と$|n|$の最小公倍数（Least Common Multiple）を返す。
