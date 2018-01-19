## メモリー管理アルゴリズム

C++17ではヘッダーファイル`<memory>`にメモリー管理用のアルゴリズムが追加された。

### addressof

~~~c++
template <class T> constexpr T* addressof(T& r) noexcept;
~~~

`addressof`はC++17以前からもある。`addressof(r)`は`r`のポインターを取得する。たとえ、`r`の型が`operator &`をオーバーロードしていても正しいポインターを取得できる。

~~~cpp
struct S
{
    S * operator &() const noexcept
    { return nullptr ; } 
} ;

int main()
{
    S s ;

    // nullptr
    S * p1 = & s ;
    // 妥当なポインター
    S * p2 = std::addressof(s) ;

}
~~~

### uninitialized_default_construct

~~~c++
template <class ForwardIterator>
void uninitialized_default_construct(
    ForwardIterator first, ForwardIterator last);

template <class ForwardIterator, class Size>
ForwardIterator uninitialized_default_construct_n(
    ForwardIterator first, Size n);
~~~

`[first, last)`の範囲、もしくは`first`から`n`個の範囲の未初期化のメモリーを`typename iterator_traits<ForwardIterator>::value_type`でデフォルト初期化する。2つ目のアルゴリズムは`first`から`n`個をデフォルト初期化する。

~~~cpp
int main()
{
    std::shared_ptr<void> raw_ptr
    (   ::operator new( sizeof(std::string) * 10 ),
        [](void * ptr){ ::operator delete(ptr) ; } ) ;
 
    std::string * ptr = static_cast<std::string *>( raw_ptr.get() ) ;

    std::uninitialized_default_construct_n( ptr, 10 ) ;
    std::destroy_n( ptr, 10 ) ;
}
~~~

### uninitialized_value_construct

~~~c++
template <class ForwardIterator>
void uninitialized_value_construct(
    ForwardIterator first, ForwardIterator last);

template <class ForwardIterator, class Size>
ForwardIterator uninitialized_value_construct_n(
    ForwardIterator first, Size n);
~~~

使い方は`uninitialized_default_construct`と同じ。ただし、こちらはデフォルト初期化ではなく値初期化する。

### uninitialized_copy

~~~c++
template <class InputIterator, class ForwardIterator>
ForwardIterator
uninitialized_copy( InputIterator first, InputIterator last,
                    ForwardIterator result);

template <class InputIterator, class Size, class ForwardIterator>
ForwardIterator
uninitialized_copy_n(   InputIterator first, Size n,
                        ForwardIterator result);
~~~

`[first, last)`の範囲、もしくは`first`から`n`個の範囲の値を、`result`の指す未初期化のメモリーにコピー構築する。

~~~cpp
int main()
{
    std::vector<std::string> input(10, "hello") ;

    std::shared_ptr<void> raw_ptr
    (   ::operator new( sizeof(std::string) * 10 ),
        [](void * ptr){ ::operator delete(ptr) ; } ) ;
 
    std::string * ptr = static_cast<std::string *>( raw_ptr.get() ) ;


    std::uninitialized_copy_n( std::begin(input), 10, ptr ) ;
    std::destroy_n( ptr, 10 ) ;
}
~~~

### uninitialized_move

~~~c++
template <class InputIterator, class ForwardIterator>
ForwardIterator
uninitialized_move( InputIterator first, InputIterator last,
                    ForwardIterator result);

template <class InputIterator, class Size, class ForwardIterator>
pair<InputIterator, ForwardIterator>
uninitialized_move_n(   InputIterator first, Size n,
                        ForwardIterator result);
~~~

使い方は`uninitialized_copy`と同じ。ただしこちらはコピーではなくムーブする。

### uninitialized_fill

~~~c++
template <class ForwardIterator, class T>
void uninitialized_fill(
    ForwardIterator first, ForwardIterator last,
    const T& x);

template <class ForwardIterator, class Size, class T>
ForwardIterator uninitialized_fill_n(
    ForwardIterator first, Size n,
    const T& x);
~~~

`[first, last)`の範囲、もしくは`first`から`n`個の範囲の未初期化のメモリーを、コンストラクターに実引数`x`を与えて構築する。


### destroy

~~~c++
template <class T>
void destroy_at(T* location);
~~~

`location->~T()`を呼び出す。

~~~c++
template <class ForwardIterator>
void destroy(ForwardIterator first, ForwardIterator last);

template <class ForwardIterator, class Size>
ForwardIterator destroy_n(ForwardIterator first, Size n);
~~~

`[first, last)`の範囲、もしくは`first`から`n`個の範囲に`destroy_at`を呼び出す。
