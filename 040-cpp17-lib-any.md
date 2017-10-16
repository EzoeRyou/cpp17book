## any : どんな型の値でも保持できるクラス

### 使い方

ヘッダーファイル\<any\>で定義されているstd::anyは、ほとんどどんな型の値でも保持できるクラスだ。

~~~cpp
#include <any>

int main()
{
    std::any a ;

    a = 0 ; // int
    a = 1.0 ; // double
    a = "hello" ; // char const *

    std::vector<int> v ;
    a = v ; // std::vector<int>

    // 保持しているstd::vector<int>のコピー
    auto value = std::any_cast< std::vector<int> >( a ) ;
}
~~~

anyが保持できない型は、コピー構築できない型だ。

### anyの構築と破棄

クラスanyはテンプレートではない。そのため宣言は単純だ。

~~~cpp
int main()
{
    // 値を保持しない
    std::any a ;
    // int型の値を保持する
    std::any b( 0 ) ;
    // double型の値を保持する
    std::any c( 0.0 ) ;
}
~~~

anyが保持する型を事前に指定する必要はない。

クラスanyを破棄すると、その時保持していた値が適切に破棄される。

### in_place_typeコンストラクター

anyのコンストラクターでemplaceをするためにin_place_typeが使える。


~~~cpp
struct X
{
    X( int, int ) { }
} ;

int main()
{
    // 型XをX(1, 2)で構築した結果の値を保持する
    std::any a( std::in_place_type<X>, 1, 2 ) ;
}
~~~

### anyへの代入

anyへの代入も普通のプログラマーの期待通りの動きをする。


~~~cpp
int main()
{
    std::any a ;
    std::any b ;

    // aはint型の値42を保持する。
    a = 42 ;
    // bはint型の値42を保持する
    b = a ;
    
}
~~~

### anyのメンバー関数

#### emplace

~~~c++
template <class T, class... Args>
decay_t<T>& emplace(Args&&... args);
~~~


anyはemplaceメンバー関数をサポートしている。



~~~cpp
struct X
{
    X( int, int ) { }
} ;

int main()
{
    std::any a ;

    // 型XをX(1, 2)で構築した結果の値を保持する
    a.emplace<X>( 1, 2 ) ;
}
~~~


#### reset : 値の破棄

~~~c++
void reset() noexcept ; 
~~~

anyのresetメンバー関数は、anyの保持してある値を破棄する。resetを呼び出した後のanyは値を保持しない。


~~~cpp
int main()
{
    // aは値を保持しない
    std::any a ;
    // aはint型の値を保持する
    a = 0 ;

    // aは値を保持しない
    a.reset() ;
}
~~~

#### swap : スワップ

anyはswapメンバー関数をサポートしている。

~~~cpp
int main()
{
    std::any a(0) ;
    std::any b(0.0) ;

    // aはint型の値を保持
    // bはdouble型の値を保持

    a.swap(b) ;

    // aはdouble型の値を保持
    // bはint型の値を保持。
}
~~~

#### has_value : 値を保持しているかどうか調べる

~~~c++
bool has_value() const noexcept;
~~~

anyのhas_valueメンバー関数はanyが値を保持しているかどうかを調べる。値を保持しているならばtrueを、保持していないならばfalseを返す。

~~~cpp
int main()
{
    std::any a ;

    // false
    bool b1 = a.has_value() ;

    a = 0 ;
    // true
    bool b2 = a.has_value() ;

    a.reset() ;
    // false
    bool b3 = a.has_value() ;
}
~~~

#### type : 保持している型のtype_infoを得る

~~~c++
const type_info& type() const noexcept;
~~~

typeメンバー関数は、保持している型Tのtypeid(T)を返す。値を保持していない場合、typeid(void)を返す。

~~~cpp
int main()
{
    std::any a ;

    // typeid(void)
    auto & t1 = a.type() ;

    a = 0 ;
    // typeid(int)
    auto & t2 = a.type() ;

    a = 0.0 ;
    // typeid(double)
    auto & t3 = a.type() ;
}
~~~

### anyのフリー関数

#### make_any\<T\> : T型のanyを作る

~~~c++
emplate <class T, class... Args>
any make_any(Args&& ...args);

template <class T, class U, class... Args>
any make_any(initializer_list<U> il, Args&& ...args);
~~~


make_any\<T\>( args... )はT型をコンストラクター実引数args...で構築した値を保持するanyを返す。

~~~cpp
struct X
{
    X( int, int ) { }
} ;

int main()
{
    // int型の値を保持するany
    auto a = std::make_any<int>( 0 ) ;
    // double型の値を保持するany
    auto b = std::make_any<double>( 0.0 ) ;

    // X型の値を保持するany
    auto c = std::make_any<X>( 1, 2 ) ;
}
~~~

#### any_cast : 保持している値の取り出し

~~~c++
template<class T> T any_cast(const any& operand);
template<class T> T any_cast(any& operand);
template<class T> T any_cast(any&& operand);
~~~

any_cast\<T\>(operand)はoperandが保持している値を返す。

~~~cpp
int main()
{
    std::any a(0) ;

    int value = std::any_cast<int>(a) ;
}
~~~

any_cast\<T\>で指定したT型が、anyが保持している型ではない場合、std::bad_any_castがthrowされる。

~~~cpp
int main()
{
    try {
        std::any a ;
        std::any_cast<int>(a) ;
    } catch( std::bad_any_cast e )
    {
        // 型を保持していなかった。
    }

}
~~~

~~~c++
template<class T>
const T* any_cast(const any* operand) noexcept;
template<class T>
T* any_cast(any* operand) noexcept;
~~~

any_cast\<T\>にanyへのポインターを渡すと、Tへのポインター型が返される。anyがT型を保持している場合はT型を参照するポインターが返る。保持していない場合は、nullptrが返る。

~~~cpp
int main()
{
    std::any a(42) ;

    // int型の値を参照するポインター
    int * p1 = std::any_cast<int>( &a ) ;

    // nullptr
    double * p2 = std::any_cast<double>( &a ) ;
}
~~~


