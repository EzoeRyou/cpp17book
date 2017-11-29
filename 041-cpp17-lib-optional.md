## optional : 値を保有しているか、していないクラス


### 使い方

ヘッダーファイル`<optional>`で定義されている`optional<T>`は、`T`型の値を保有しているか、保有していないライブラリだ。

条件次第で値が用意できない場合が存在する。たとえば割り算の結果の値を返す関数を考える。

~~~c++
int divide( int a, int b )
{
    if ( b == 0 )
    {
        // エラー処理
    }
    else
        return a / b ;
}
~~~

ゼロで除算はできないので、`b`の値が0の場合、この関数は値を用意することができない。問題は、`int`型のすべての値は通常の除算結果として使われるので、エラーであることを示す特別な値を返すこともできない。

このような場合にエラーや値を通知する方法として、過去にさまざまな方法が考案された。たとえば、ポインターやリファレンスを実引数として受け取る方法、グローバル変数を使う方法、例外だ。

`optional`はこのような値が用意できない場合に使える共通の方法を提供する。

~~~cpp
std::optional<int> divide( int a, int b )
{
    if ( b == 0 )
        return {} ;
    else
        return { a / b } ;
}

int main()
{
    auto result = divide( 10, 2 ) ;
    // 値の取得
    auto value = result.value() ;

    // ゼロ除算
    auto fail = divide( 10, 0 ) ;

    // false、値を保持していない
    bool has_value = fail.has_value() ;

    // throw bad_optional_access
    auto get_value_anyway = fail.value() ;
}
~~~


### optionalのテンプレート実引数

`optional<T>`は`T`型の値を保持するか、もしくは保持しない状態を取る。


~~~cpp
int main()
{
    // int型の値を保持するかしないoptional
    using a = std::optional<int> ;
    // double型の値を保持するかしないoptional
    using b = std::optional<double> ;
}
~~~

### optionalの構築

`optional`をデフォルト構築すると、値を保持しない`optional`になる。

~~~cpp
int main()
{
    // 値を保持しない
    std::optional<int> a ;
}
~~~

コンストラクターの実引数に`std::nullopt`を渡すと、値を保持しない`optional`になる。


~~~cpp
int main()
{
    // 値を保持しない
    std::optional<int> a( std::nullopt ) ;
}
~~~

`optional<T>`のコンストラクターの実引数に`T`型に変換できる型を渡すと、`T`型の値に型変換して保持する。

~~~cpp
int main()
{
    // int型の値42を保持する
    std::optional<int> a(42) ;

    // double型の値1.0を保持する
    std::optional<double> b( 1.0 ) ;

    // intからdoubleへの型変換が行われる
    // int型の値1を保持する
    std::optional<int> c ( 1.0 ) ;
}
~~~

`T`型から`U`型に型変換できるとき、`optional<T>`のコンストラクターに`optional<U>`を渡すと`U`から`T`に型変換されて`T`型の値を保持する`optional`になる。

~~~cpp
int main()
{
    // int型の値42を保持する
    std::optional<int> a( 42 ) ;

    // long型の値42を保持する
    std::optional<long> b ( a ) ;
}
~~~

`optional`のコンストラクターの第一引数に`std::in_place_type<T>`を渡すと、後続の引数を使って`T`型のオブジェクトが`emplace`構築される。

~~~cpp
struct X
{
    X( int, int ) { }
} ;

int main()
{
    // X(1, 2)
    std::optional<X> o( std::in_place_type<X>, 1, 2 ) ;
}
~~~

### optionalの代入

通常のプログラマーの期待どおりの挙動をする。`std::nullopt`を代入すると値を保持しない`optional`になる。



### optionalの破棄

`optional`が破棄されるとき、保持している値があれば、適切に破棄される。


~~~cpp
struct X
{
    ~X() { }
} ;

int main()
{
    {
        // 値を保持する
        std::optional<X> o ( X{} ) ;
        // Xのデストラクターが呼ばれる
    }

    {
        // 値を保持しない
        std::optional<X> o ;
        // Xのデストラクターは呼ばれない
    }   
}
~~~

### swap

`optional`は`swap`に対応している。


~~~cpp
int main()
{
    std::optional<int> a(1), b(2) ;

    a.swap(b) ;
}
~~~

### has_value : 値を保持しているかどうか確認する

~~~c++
constexpr bool has_value() const noexcept;
~~~

`has_value`メンバー関数は`optional`が値を保持している場合、`true`を返す。


~~~cpp
int main()
{
    std::optional<int> a ;
    // false
    bool b1 = a.has_value() ;

    std::optional<int> b(42) ;
    // true
    bool b2 = b.has_value() ;
}
~~~

### operator bool : 値を保持しているかどうか確認する
~~~c++
constexpr explicit operator bool() const noexcept;
~~~

`optional`を文脈上`bool`に変換すると、値を保持している場合にのみ`true`として評価される。

~~~c++
int main()
{
    std::optional<bool> a = some_function();
    // OK、文脈上boolに変換
    if ( a )
    {
        // 値を保持
    }
    else
    {
        // 値を不保持
    }

    // エラー、暗黙の型変換は行われない
    bool b1 = a ;
    // OK、明示的な型変換
    bool b2 = static_cast<bool>(a) ;
}
~~~



### value : 保持している値を取得

~~~c++
constexpr const T& value() const&;
constexpr T& value() &;
constexpr T&& value() &&;
constexpr const T&& value() const&&;
~~~

`value`メンバー関数は`optional`が値を保持している場合、値へのリファレンスを返す。値を保持していない場合、`std::bad_optional_access`が`throw`される。


~~~cpp
int main()
{
    std::optional<int> a(42) ;

    // OK
    int x = a.value () ;

    try {
        std::optional<int> b ;
        int y = b.value() ;
    } catch( std::bad_optional_access e )
    {
        // 値を保持していなかった
    }
}
~~~

### value_or : 値もしくはデフォルト値を返す

~~~c++
template <class U> constexpr T value_or(U&& v) const&;
template <class U> constexpr T value_or(U&& v) &&;
~~~

`value_or(v)`メンバー関数は、`optional`が値を保持している場合はその値を、保持していない場合は`v`を返す。

~~~cpp
int main()
{
    std::optional<int> a( 42 ) ;

    // 42
    int x = a.value_or(0) ;

    std::optional<int> b ;

    // 0
    int x = b.value_or(0) ;
}
~~~

### reset : 保持している値を破棄する

`reset`メンバー関数を呼び出すと、保持している値がある場合破棄する。`reset`メンバー関数を呼び出した後の`optional`は値を保持しない状態になる。


~~~cpp
int main()
{
    std::optional<int> a( 42 ) ;

    // true
    bool b1 = a.has_value() ;

    a.reset() ;

    // false
    bool b2 = a.has_value() ;
}
~~~

### optional同士の比較

`optional<T>`を比較するためには、`T`型のオブジェクト同士が比較できる必要がある。

#### 同一性の比較

値を保持しない2つの`optional`は等しい。片方のみが値を保持している`optional`は等しくない。両方とも値を保持している`optional`は値による比較になる。

~~~cpp
int main()
{
    std::optional<int> a, b ;

    // true
    // どちらも値を保持しないoptional
    bool b1 = a == b ;

    a = 0 ;

    // false
    // aのみ値を保持
    bool b2 = a == b ;

    b = 1 ;

    // false
    // どちらも値を保持。値による比較
    bool b3 = a == b ;
}
~~~

#### 大小比較

`optional`同士の大小比較は、`a < b`の場合

1. `b`が値を保持していなければ`false`
2. それ以外の場合で、`a`が値を保持していなければ`true`
3. それ以外の場合、`a`と`b`の保持している値同士の比較

となる。

~~~cpp
int main()
{
    std::optional<int> a, b ;

    // false
    // bが値なし
    bool b1 = a < b ;

    b = 0 ;

    // true
    // bは値ありでaが値なし
    bool b2 = a < b ;

    a = 1 ;

    // false
    // どちらとも値があるので値同士の比較
    // 1 < 0はfalse
    bool b3 = a < b ;
}
~~~

### optionalとstd::nulloptとの比較

`optional`と`std::nullopt`との比較は、`std::nullopt`が値を持っていない`optional`として扱われる。

### optional\<T\>とTの比較

`optional<T>`と`T`型の比較をする場合、`T`側が値を保持している`optional`として扱われる。

### make_optional\<T\> : optional\<T\>を返す

~~~c++
template <class T>
constexpr optional<decay_t<T>> make_optional(T&& v);
~~~

`make_optional<T>(T t)`は`optional<T>(t)`を返す。

~~~cpp
int main()
{
    // std::optional<int>、値は0
    auto o1 = std::make_optional( 0 ) ;

    // std::optional<double>、値は0.0
    auto o2 = std::make_optional( 0.0 ) ;
}
~~~

### make_optional\<T, Args ... \> : optional\<T\>をin_place_type構築して返す

`make_optional`の第一引数が`T`型ではない場合、`in_place_type`構築するオーバーロード関数が選ばれる。

~~~cpp
struct X
{
    X( int, int ) { }
} ;

int main()
{
    // std::optional<X>( std::in_place_type<X>, 1, 2 )
    auto o = std::make_optional<X>( 1, 2 ) ;
}
~~~
