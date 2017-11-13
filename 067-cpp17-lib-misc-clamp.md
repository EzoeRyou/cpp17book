## clamp

~~~c++
template<class T>
constexpr const T&
clamp(const T& v, const T& lo, const T& hi);
template<class T, class Compare>
constexpr const T&
clamp(const T& v, const T& lo, const T& hi, Compare comp);
~~~

ヘッダーファイル`<algorithm>`に追加された`clamp(v, lo, hi)`は値`v`が`lo`より小さい場合は`lo`を、`hi`より高い場合は`hi`を、それ以外の場合は`v`を返す。

~~~cpp
int main()
{
    std::clamp( 5, 0, 10 ) ; // 5
    std::clamp( -5, 0, 10 ) ; // 0
    std::clamp( 50, 0, 10 ) ; // 10
}
~~~

`comp`を実引数に取る`clamp`は`comp`を値の比較に使う

`clamp`には浮動小数点数も使えるが、NaNは渡せない。
