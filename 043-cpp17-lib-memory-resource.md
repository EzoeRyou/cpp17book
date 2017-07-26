# メモリーリソース : 動的ストレージ確保ライブラリ

ヘッダーファイル\<memory_resource\>で定義されているメモリーリソースは、動的ストレージを確保するためのC++17で追加されたライブラリだ。その特徴は以下の通り。


+ アロケーターに変わる新しいインターフェースとしてのメモリーリソース
+ ポリモーフィックな振る舞いを可能にするアロケーター
+ 標準で提供される様々な特性を持ったメモリーリソースの実装

## メモリーリソース

メモリーリソースはアロケーターに変わる新しいメモリ確保と解放のためのインターフェースとしての抽象クラスだ。コンパイル時に挙動を変える静的ポリモーフィズム設計のアロケーターと違い、メモリーリソースは実行時に挙動を変える動的ポリモーフィズム設計となっている。

~~~cpp
void f( memory_resource * mem )
{
    // 10バイトのストレージを確保
    auto ptr = mem->allocate( 10 ) ;
    // 確保したストレージを解放
    mem->deallocate( ptr ) ;
}
~~~

クラスstd::pmr::memory_resourceの宣言は以下の通り。

~~~c++
namespace std::pmr {

class memory_resource {
public:
    virtual ~ memory_resource();
    void* allocate(size_t bytes, size_t alignment = max_align);
    void deallocate(void* p, size_t bytes, size_t alignment = max_align);
    bool is_equal(const memory_resource& other) const noexcept;

private:
    virtual void* do_allocate(size_t bytes, size_t alignment) = 0;
    virtual void do_deallocate(void* p, size_t bytes, size_t alignment) = 0;
    virtual bool do_is_equal(const memory_resource& other) const noexcept = 0;
};

}
~~~

クラスmemory_resourceはstd::pmr名前空間スコープのなかにある。

### メモリーリソースの使い方

memory_resourceを使うのは簡単だ。memory_resourceのオブジェクトを確保したら、メンバー関数allocate( bytes, alignment )でストレージを確保する。メンバー関数deallocate( p, bytes, alignment )でストレージを解放する。

~~~cpp
void f( std::pmr::memory_resource * mem )
{
    // 100バイトのストレージを確保
    void * ptr = mem->allocate( 100 ) ;
    // ストレージを解放
    mem->deallocate( ptr, 100 ) ;
}
~~~

二つのmemory_resourceのオブジェクトa, bがあるとき、一方のオブジェクトで確保したストレージをもう一方のオブジェクトで解放できるとき、a.is_equal( b )はtrueを返す。

~~~cpp
void f( std::pmr::memory_resource * a, std::pmr::memory_resouce * b )
{
    void * ptr = a->allocate( 1 ) ;

    // aで確保したストレージはbで解放できるか？
    if ( a->is_equal( *b ) )
    {// できる
        b->deallocate( ptr, 1 ) ;
    }
    else
    {// できない
        a->deallocate( ptr, 1 ) ;
    }
}
~~~

is_equalを呼び出すoperator ==とoperator !=も提供されている。

~~~cpp
void f( std::pmr::memory_resource * a, std::pmr::memory_resource * b )
{
    bool b1 = ( *a == *b ) ;
    bool b2 = ( *a != *b ) ;
}
~~~

### メモリーリソースの作り方

独自のメモリーアロケーターをmemory_resouceのインターフェースに合わせて作るには、memory_resourceから派生した上で、do_allocate, do_deallocate, do_is_equalの3つのprivate純粋virtualメンバー関数をオーバーライドする。必要に応じてデストラクターもオーバーライドする。

~~~c++
class memory_resource {
// 非公開
static constexpr size_t max_align = alignof(max_align_t);

public:
    virtual ~ memory_resource();

private:
    virtual void* do_allocate(size_t bytes, size_t alignment) = 0;
    virtual void do_deallocate(void* p, size_t bytes, size_t alignment) = 0;
    virtual bool do_is_equal(const memory_resource& other) const noexcept = 0;
};
~~~

do_allocate(bytes, alignment)は少なくともalignmentバイトでアライメントされたbytesバイトのストレージへのポインターを返す。ストレージが確保できなかった場合は、適切な例外をthrowする。

do_deallocate(p, bytes, alignment)は事前に同じ*thisから呼び出されたallocate( bytes, alignment )で返されたポインターpを解放する。すでに解放されたポインターpを渡してはならない。例外は投げない。

do_is_equal(other)は、*thisとotherが互いに一方で確保したストレージをもう一方で解放できる場合にtrueを返す。

たとえば、malloc/freeを使ったmemory_resouceの実装は以下の通り。

~~~cpp

// malloc/freeを使ったメモリーリソース
class malloc_resource : public std::pmr::memory_resource
{
public :
    //
    ~malloc_resource() { }
private :
    // ストレージの確保
    // 失敗した場合std::bad_allocをthrowする
    virtual void * do_allocate( std::size_t bytes, std::size_t alignment ) override
    {
        void * ptr = std::malloc( bytes ) ;
        if ( ptr == nullptr )
        { throw std::bad_alloc{} ; }

        return ptr ;
    }

    // ストレージの解放
    virtual void do_deallocate( void * p, std::size_t bytes, std::size_t alignment ) override
    {
        std::free( p ) ;
    }

    virtual bool do_is_equal( const memory_resource & other ) const noexcept override
    {
        return dynamic_cast< const malloc_resource * >( &other ) != nullptr ;
    }

} ;
~~~

do_allocateはmallocでストレージを確保し、do_deallocateはfreeでストレージを解放する。メモリーリソースで0バイトのストレージを確保しようとしたときの規定はないので、mallocの挙動に任せる。mallocは0バイトのメモリを確保しようとしたとき、C11では規定がない。posixではnullポインターを返すか、freeで解放可能な何らかのアドレスを返すものとしている。

do_is_equalは、malloc_resourceでさえあればどのオブジェクトから確保されたストレージであっても解放できるので、*thisがmalloc_resourceであるかどうかをdynamic_castで確認している。

## polymorphic_allocator : 動的ポリモーフィズムを実現するアロケーター

std::pmr::polymorphic_allocatorはメモリーリソースを動的ポリモーフィズムとして振る舞うアロケーターにするためのライブラリだ。

従来のアロケーターは、静的ポリモーフィズムを実現するために設計されていた。例えば独自のcustom_int_allocator型を使いたい場合は以下のように書く。

~~~c++
std::vector< int, custom_int_allocator > v ;
~~~


コンパイル時に使うべきアロケーターが決定できる場合はこれでいいのだが、実行時にアロケーターを選択したい場合、アロケーターをテンプレート引数に取る設計は問題になる。

そのため、C++17ではメモリーリソースをコンストラクター引数にとり、メモリーリソースからストレージを確保する実行時ポリモーフィックの振る舞いをするstd::pmr::polymorphic_allocatorが追加された。

例えば、標準入力からtrueかfalseが入力されたかによって、システムのデフォルトのメモリーリソースと、monotonic_buffer_resourceを実行時に切り替えるには、以下のようにかける。


~~~cpp
int main()
{
    bool b;

    std::cin >> b ;

    std::pmr::mempry_resource * mem ;
    std::unique_ptr< memory_resource > mono ;

    if ( b )
    { // デフォルトのメモリーリソースを使う
        mem = std::pmr::get_default_resource() ;
    }
    else
    { // モノトニックバッファーを使う
        mono = std::make_unique< std::pmr::monotonic_buffer_resource >( std::pmr::get_default_resource() ) ;
        mem = mono.get() ;
    }

    std::vector< int, std::pmr::polymorphic_allocator<int> > v( std::pmr::polymorphic_allocator<int>( mem ) ) ;
}
~~~


std::pmr::polymorphic_allocatorは以下のように宣言されている

~~~c++
namespace std::pmr {

template <class T>
class polymorphic_allocator ;

}
~~~

テンプレート実引数にはstd::allocator\<T\>と同じく、確保する型を与える。

### コンストラクター

~~~c++
polymorphic_allocator() noexcept;
polymorphic_allocator(memory_resource* r);
~~~

std::pmr::polymorphic_allocatorのデフォルトコンストラクターは、メモリーリソースをstd::pmr::get_default_resource()で取得する。

memory_resource *を引数に取るコンストラクターは、渡されたメモリーリソースをストレージ確保に使う。polymorphic_allocatorの生存期間中、メモリーリソースへのポインターは妥当なものでなければならない。

~~~cpp
int main()
{
    // p1( std::pmr::get_default_resource () ) と同じ
    std::pmr::polymorphic_allocator<int> p1 ;

    std::pmr::polymorphic_allocator<int> p2( std::pmr::get_default_resource() ) ;
}
~~~

後は通常のあロケーターと同じように振る舞う。


## プログラム全体で使われるメモリーリソースの取得

C++17では、プログラム全体で使われるメモリーリソースへのポインターを取得することができる。

### new_delete_resource()

~~~c++
memory_resource* new_delete_resource() noexcept ;
~~~

関数new_delete_resourceはメモリーリソースへのポインターを返す。参照されるメモリーリソースは、ストレージの確保に::operator newを使い、ストレージの解放に::operator deleteを使う。

~~~cpp
int main()
{
    auto mem = std::pmr::new_delete_resource() ;
}
~~~

### null_memory_resource()

~~~c++
memory_resource* null_memory_resource() noexcept ;
~~~


関数null_memory_resourceはメモリーリソースへのポインターを返す。参照されるメモリーリソースのallocateは必ず失敗し、std::bad_allocをthrowする。deallocateは何もしない。

このメモリーリソースは、ストレージの確保に失敗した場合のコードをテストする目的で使える。

### デフォルトリソース

~~~c++
memory_resource* set_default_resource(memory_resource* r) noexcept ;
memory_resource* get_default_resource() noexcept ;
~~~

デフォルト・メモリーリソース・ポインターとは、メモリーリソースを明示的に指定することができない場合に、システムがデフォルトで利用するメモリーリソースへのポインターのことだ。初期値はnew_delete_resource()の戻り値となっている。

現在のデフォルト・メモリーリソース・ポインターと取得するためには、関数get_default_resourceを使う。デフォルト・メモリーリソース・ポインターを独自のメモリーリソースに差し替えるには、関数set_default_resourceを使う。

~~~cpp
int main()
{
    // 現在のデフォルトのメモリーリソースへのポインター
    auto init_mem = std::pmr::get_default_resource() ;

    std::pmr::synchronized_pool_resource pool_mem ;

    // デフォルトのメモリーリソースを変更する
    std::pmr::set_default_resource( &pool_mem ) ;

    auto current_mem = std::pmr::get_default_resource() ;

    // true
    bool b = current_mem == pool_mem ;
}
~~~

## 標準ライブラリのメモリーリソース

標準ライブラリはメモリーリソースの実装として、プールリソースとモノトニックリソースを提供している。このメモリーリソースの詳細は後に解説するが、ここではそのための事前知識として、汎用的なメモリーアロケーター一般の解説をする。

プログラマーはメモリーを気軽に確保している。例えば47バイトとか151バイトのような中途半端なサイズのメモリーを以下のように気軽に確保している。

~~~cpp
int main()
{
    auto mem = std::get_default_resource() ;

    auto p1 = mem->allocate( 47 ) ;
    auto p2 = mem->allocate( 151 ) ;

    mem->deallocate( p1 ) ;
    mem->deallocate( p2 ) ;
}
~~~

しかし、残念ながら現実のハードウェアやOSのメモリ管理は、このように柔軟にはできていない。例えば、あるアーキテクチャーとOSでは、メモリはページサイズと呼ばれる単位でしか確保できない。そして最小のページサイズですら4KBであったりする。もしシステムの低級なメモリ管理を使って上のコードを実装しようとすると、47バイト程度のメモリを使うのに3KB超の無駄が生じることになる。

他にもアライメントの問題がある。アーキテクチャによってはメモリアドレスが適切なアライメントに配置されていないとメモリアクセスができないか、著しくパフォーマンスが落ちることがある。


mallocやoperator newなどのメモリーアロケーターは、低級なメモリ管理を隠匿し、小さなサイズのメモリ確保を効率的に行うための実装をしている。

一般的には、大きな連続したアドレス空間のメモリを確保し、その中に管理用のデータ構造を作り、メモリを必要なサイズに切り出す。


    

~~~c++
// 実装イメージ

// ストレージを分割して管理するためのリンクリストデータ構造
struct alignas(std::max_align_t) chunk
{
    chunk * next ;
    chunk * prev ;
    std::size_t size ;
} ;

class memory_allocator : public std::pmr::memory_resource
{
    chunk * ptr ; // ストレージの先頭へのポインター
    std::size_t size ; // ストレージのサイズ
    std::mutex m ; // 同期用

    
public :

    memory_allocator()
    {
        // 大きな連続したストレージを確保
    }

    virtual void * do_allocate( std::size_t bytes, std::size_t alignment ) override
    {
        std::scoped_lock lock( m ) ; 
        // リンクリストをたどり、十分な大きさの未使用領域を探し、リンクリスト構造体を構築して返す
        // アライメント要求に注意
    }

    virtual void * do_allocate( std::size_t bytes, std::size_t alignment ) override
    {
        std::scoped_lock lock( m ) ;
        // リンクリストから該当する部分を削除
    }

    virtual bool do_is_equal( const memory_resource & other ) const noexcept override
    { 
    // *thisとotherで相互にストレージを解放できるかどうか返す
    }
} ;
~~~

## プールリソース

プールリソースはC++17の標準ライブラリが提供しているメモリーリソースの実装だ。synchronized_pool_resourcceとunsynchronized_pool_resourceの二つがある。

### アルゴリズム

プールリソースは以下のような特徴を持つ。


+ プールリソースのオブジェクトが破棄されるとき、そのオブジェクトからallocateで確保したストレージは、明示的にdeallocateを呼ばずとも解放される。


~~~c++
void f()
{
    std::pmr::synchronized_pool_resource mem ;
    mem.allocate( 10 ) ;

    // 確保したストレージは破棄される
}
~~~

+ プールリソースの構築時に、上流メモリーリソースを与えることができる。プールリソースは上流メモリーリソースからチャンクのためのストレージを確保する。

~~~c++
int main()
{
    // get_default_resource()が使われる
    std::pmr::synchronized_pool_resource m1 ;

    // 独自の上流メモリーリソースを指定
    custom_memory_resource mem ;
    std::pmr::synchronized_pool_resource m2( &mem ) ;
    
}
~~~

+   プールリソースはストレージを確保する上流メモリーリソースから、プールと呼ばれる複数のストレージを確保する。ブールは複数のチャンクを保持している。チャンクは複数の同一サイズのブロックを保持している。プールリソースに対するdo_allocate(size, alignment)は、少なくともsizeバイトのブロックサイズのプールのいずれかのチャンクのブロックが割り当てられる。

    もし、最大のブロックサイズを超えるサイズのストレージを確保しようとした場合、上流メモリーリソースから確保される。

~~~c++
// 実装イメージ

namespace std::pmr {

// チャンクの実装
template < size_t block_size >
class chunk
{
    blocks<block_size> b ;
}

// プールの実装
template < size_t block_size >
class pool : public memory_resource
{
    chunks<block_size> c ;
} ;

class pool_resource : public memory_resource
{
    // それぞれのブロックサイズのプール
    pool<8> pool_8bytes ;
    pool<16> pool_16bytes ;
    pool<32> pool_32bytes ;

    // 上流メモリーリソース
    memory_resource * mem ;


    virtual void * do_allocate( size_t bytes, size_t alignment ) override
    {
        // 対応するブロックサイズのプールにディスパッチ
        if ( bytes <= 8 )
            return pool_8bytes.allocate( bytes, alignment ) ;
        else if ( bytes <= 16 )
            return pool_16bytes.allocate( bytes, alignment ) ;
        else if ( bytes < 32 )
            return pool_32bytes.allocate( bytes, alignment ) ;
        else
        // 最大ブロックサイズを超えたので上流メモリーリソースにディスパッチ
            return mem->allocate( bytes, alignment ) ;
    }
} ;

}
~~~


+ プールリソースは構築時にpool_optionsを渡すことにより、最大ブロックサイズと最大チャンクサイズを設定できる。

+ マルチスレッドから呼び出しても安全な同期を取るsynchronized_pool_resourceと、同期をとらないunsynchronized_pool_resourceがある。



### synchronized/unsynchronized_pool_resource

プールリソースには、synchronized_pool_resourceとunsynchronized_pool_resourceがある。どちらもクラス名以外は同じように使える。ただし、synchronized_pool_resourceは複数のスレッドから同時に実行しても使えるように内部で同期が取られているのに対し、unsynchronized_pool_resourceは同期を行わない。unsyncrhonized_pool_resourceは複数のスレッドから同時に呼び出すことはできない。

~~~c++
// 実装イメージ

namespace std::pmr {

class synchronized_pool_resource : public memory_resource
{
    std::mutex m ;

    virtual void * do_allocate( size_t size, size_t alignment ) override
    {
        // 同期する
        std::scoped_lock l(m) ;
        return do_allocate_impl( size, alignment ) ;
    }
} ;

class unsynchronized_pool_resource : public memory_resource
{
    virtual void * do_allocate( size_t size, size_t alignment ) override
    {
        // 同期しない
        return do_allocate_impl( size, alignment ) ;
    }
} ;

}
~~~

### pool_options

pool_optionsはプールリソースの挙動を指定するためのクラスで、以下のように定義されてる。

~~~c++
namespace std::pmr {

struct pool_options {
    size_t max_blocks_per_chunk = 0;
    size_t largest_required_pool_block = 0;
};

}
~~~

このクラスのオブジェクトをプールリソースのコンストラクターに与えることで、プールリソースの挙動を指定できる。ただし、pool_optionsによる指定はあくまでも目安で、実装には従う義務はない。


max_blocks_per_chunkは、上流メモリーリソースからプールのチャンクを補充する際に一度に確保する最大のブロック数だ。この値がゼロか、実装の上限より大きい場合、実装の上限が使われる。実装は指定よりも小さい値を使うことができるし、またプールごとに別の値を使うこともできる。

largest_required_pool_blockはプール機構によって確保される最大のストレージのサイズだ。この値より大きなサイズのストレージを確保しようとすると、上流メモリーストレージから直接確保される。この値がゼロか、実装の上限よりも大きい場合、実装の上限が使われる。実装は指定よりも大きい値を使うこともできる。

### プールリソースのコンストラクター

プールリソースの根本的なコンストラクターは以下の通り。synchronizedとunsynchronizedどちらも同じだ。

~~~c++
pool_resource(const pool_options& opts, memory_resource* upstream);

pool_resource()
: pool_resource(pool_options(), get_default_resource()) {}
explicit pool_resource(memory_resource* upstream)
: pool_resource(pool_options(), upstream) {}
explicit pool_resource(const pool_options& opts)
: pool_resource(opts, get_default_resource()) {}
~~~


pool_optionsとmemory_resource *を指定する。指定しない場合はデフォルト値が使われる。


### プールリソースのメンバー関数

#### release()

~~~c++
void release();
~~~

確保したストレージ全てを解放する。たとえ明示的にdeallocateを呼び出されていないストレージも解放する。

~~~cpp
int main()
{
    synchronized_pool_resource mem ;
    void * ptr = mem.allocate( 10 ) ;

    // ptrは解放される
    mem.release() ;

}
~~~

#### upstream_resource()

~~~c++
memory_resource* upstream_resource() const;
~~~

構築時に渡した上流メモリーリソースへのポインターを返す。

#### options()

~~~c++
pool_options options() const;
~~~

構築時に渡したpool_optionsオブジェクトと同じ値を返す。

## モノトニックバッファーリソース

モノトニックバッファーリソースはC++17で標準ライブラリに追加されたメモリーリソースの実装だ。クラス名はmonotonic_buffer_resource。

モノトニックバッファーリソースは高速にメモリーを確保し、一気に解放するという用途に特化した特殊な設計をしている。モノトニックバッファーリソースはメモリー解放をせず、メモリー使用量がモノトニックに増え続けるので、この名前がついている。

例えばゲームで1フレームを描画する際に大量に小さなオブジェクトのためのストレージを確保し、その後確保したストレージをすべて解放したい場合を考える。通常のメモリーアロケーターでは、メモリー片を解放するためにメモリー全体に構築されたデータ構造を辿り、データ構造を書き換えなければならない。この処理は高くつく。すべてのメモリー片を一斉に解放してよいのであれば、データ構造をいちいち辿ったり書き換えたりする必要はない。メモリーの管理は、単にポインターだけでよい。

~~~c++
// 実装イメージ

namespace std::pmr {

class monotonic_buffer_resource : public memory_resource
{
    // 連続した長大なストレージの先頭へのポインター
    void * ptr ;
    // 現在の未使用ストレージの先頭へのポインター
    std::byte * current ;

    virtual void * do_allocate( size_t bytes, size_t alignment ) override
    {
        void * result = static_cast<void *>(current) ;
        current += bytes ; // 必要であればアライメント調整
        return result ;
    }

    virtual void do_deallocate( void * ptr, size_t bytes, size_t alignment ) override 
    {
        // 何もしない
    }

public :
    ~monotonic_buffer_resource()
    {
        // ptrの解放
    }
} ;

}
~~~

このように、基本的な実装としては、do_allocateはポインターを加算して管理するだけだ。なぜならば解放処理がいらないため、個々のストレージ片を管理するためのデータ構造を構築する必要がない。do_deallocateはなにもしない。デストラクターはストレージ全体を解放する。

### アルゴリズム

モノトニックバッファーリソースは以下のような特徴を持つ。

+   deallocate呼び出しは何もしない。メモリー使用量はリソースが破棄されるまでモノトニックに増え続ける。

~~~cpp
int main()
{
    std::pmr::monotonic_buffer_resource mem ;

    void * ptr = mem.allocate( 10 ) ;
    // 何もしない
    // ストレージは解放されない。
    mem.deallocate( ptr ) ;

    // memが破棄される際に確保したストレージはすべて破棄される
}
~~~

+   メモリー確保に使う初期バッファーを与えることができる。ストレージ確保の際に、初期バッファーに空きがある場合はそこから確保する。空きがない場合は上流メモリーリソースからバッファーを確保して、バッファーから確保する。

~~~c++
int main()
{
    std::byte initial_buffer[10] ;
    std::pmr::monotonic_buffer_resource mem( initial_buffer, 10, std::pmr::get_default_resource() ) ;

    // 初期バッファーから確保
    mem.allocate( 1 ) ;
    // 上流メモリーリソースからストレージを確保して切り出して確保
    mem.allocate( 100 ) ;
    // 前回のストレージ確保で空きがあればそこから
    // なければ新たに上流から確保して切り出す。
    mem.allocate( 100 ) ;
}
~~~

+   一つのスレッドから使うことを前提に設計されている。allocateとdeallocateは同期しない。

+   メモリーリソースが破棄されると確保されたすべてのストレージも解放される。明示的にdeallocateを呼ばなくてもよい。

### コンストラクター

モノトニックバッファーリソースには以下のコンストラクターがある。

~~~c++

explicit monotonic_buffer_resource(memory_resource *upstream);
monotonic_buffer_resource(size_t initial_size, memory_resource *upstream);
monotonic_buffer_resource(void *buffer, size_t buffer_size, memory_resource *upstream);


monotonic_buffer_resource()
    : monotonic_buffer_resource(get_default_resource()) {}
explicit monotonic_buffer_resource(size_t initial_size)
    : monotonic_buffer_resource(initial_size, get_default_resource()) {}
monotonic_buffer_resource(void *buffer, size_t buffer_size)
    : monotonic_buffer_resource(buffer, buffer_size, get_default_resource()) {}
~~~

初期バッファーを取らないコンストラクターは以下の通り。

~~~c++
explicit monotonic_buffer_resource(memory_resource *upstream);
monotonic_buffer_resource(size_t initial_size, memory_resource *upstream);

monotonic_buffer_resource()
    : monotonic_buffer_resource(get_default_resource()) {}
explicit monotonic_buffer_resource(size_t initial_size)
    : monotonic_buffer_resource(initial_size, get_default_resource()) {}
~~~

initial_sizeは、上流メモリーリソースから最初に確保するバッファーのサイズ(初期サイズ)のヒントとなる。実装はこのサイズか、あるいは実装依存のサイズをバッファーとして確保する。

デフォルトコンストラクターは上流メモリーリソースにstd::pmr_get_default_resource()を与えたのと同じ挙動になる。

size_tひとつだけを取るコンストラクターは、初期サイズだけを与えて後はデフォルトの扱いになる。

初期バッファーをとるコンストラクターは以下の通り。

~~~c++
monotonic_buffer_resource(void *buffer, size_t buffer_size, memory_resource *upstream);

monotonic_buffer_resource(void *buffer, size_t buffer_size)
    : monotonic_buffer_resource(buffer, buffer_size, get_default_resource()) {}
~~~

初期バッファーは先頭アドレスをvoid *型で渡し、そのサイズをsize_t型で渡す。

### その他の操作

#### release()

~~~c++
void release() ;
~~~

メンバー関数releaseは、上流リソースから確保されたストレージをすべて解放する。明示的にdeallocateを呼び出していないストレージも解放される。


~~~cpp
int main()
{
    std::pmr::monotonic_buffer_resource mem ;

    mem.allocate( 10 ) ;

    // ストレージはすべて解放される
    mem.release() ;

}
~~~

#### upstream_resource()

~~~c++
memory_resource* upstream_resource() const;
~~~

メンバー関数uptream_resourceは、構築時に与えられた上流メモリーリソースへのポインターを返す。
