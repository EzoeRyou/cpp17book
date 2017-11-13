## サイズ付き解放関数

C++14では`operator delete`のオーバーロードに、解放すべきストレージのサイズを取得できるオーバーロードが追加された。

~~~c++
void operator delete    ( void *, std::size_t ) noexcept ;
void operator delete[]  ( void *, std::size_t ) noexcept ;
~~~

第二引数は`std::size_t`型で、第一引数で指定されたポインターが指す解放すべきストレージのサイズが与えられる。


例えば以下のように使える。

~~~cpp
void * operator new ( std::size_t size )
{
    void * ptr =  std::malloc( size ) ;

    if ( ptr == nullptr )
        throw std::bad_alloc() ;

    std::cout << "allocated storage of size: " << size << '\n' ;
    return ptr ;
}

void operator delete ( void * ptr, std::size_t size ) noexcept
{
    std::cout << "deallocated storage of size: " << size << '\n' ;
    std::free( ptr ) ;
}

int main()
{
    auto u1 = std::make_unique<int>(0) ;
    auto u2 = std::make_unique<double>(0.0) ;
}
~~~

機能テストマクロは`__cpp_sized_deallocation`, 値は201309。
