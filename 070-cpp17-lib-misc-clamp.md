## clamp

~~~c++
template<class T>
constexpr const T& clamp(const T& v, const T& lo, const T& hi);
template<class T, class Compare>
constexpr const T& clamp(const T& v, const T& lo, const T& hi, Compare comp);
~~~

ヘッダーファイル\<algorithm\>に追加されたclamp(v, lo, hi)は値vがloより小さい場合はloを、hiより高い場合はhiを、それ以外の場合はvを返す。

~~~cpp
int main()
{
    std::clamp( 5, 0, 10 ) ; // 5
    std::clamp( -5, 0, 10 ) ; // 0
    std::clamp( 50, 0, 10 ) ; // 10
}
~~~

compを実引数に取るclampはcompを値の比較に使う

clampには浮動小数点数も使えるが、NaNは渡せない。
