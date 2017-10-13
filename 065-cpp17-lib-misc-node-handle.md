## 連想コンテナーへのsplice操作

C++17では、連想コンテナーと非順序連想コンテナーでsplice操作がサポートされた。

対象のコンテナーはmap, set, multimap, multiset, unordered_map, unordered_set, unordered_multimap, unordered_multisetだ。

splice操作とはlistで提供されている操作で、アロケーター互換のlistのオブジェクトの要素をストレージと所有権ごと別のオブジェクトに移動する機能だ。

~~~cpp
int main()
{
    std::list<int> a = {1,2,3} ;
    std::list<int> b = {4,5,6} ;

    a.splice( std::end(a), b, std::begin(b) ) ;

    // aは{1,2,3,4}
    // bは{5,6}

    b.splice( std::end(b), a ) ;

    // aは{}
    // bは{5,6,1,2,3,4}

}
~~~

連想コンテナーでは、ノードハンドルという仕組みを用いて、コンテナーのオブジェクトから要素の所有権をコンテナーの外に出す仕組みで、splice操作を行う。

### merge

すべての連想コンテナーと非順序連想コンテナーは、メンバー関数mergeを持っている。コンテナーa, bがアロケーター互換のとき、a.merge(b)は、コンテナーbの要素の所有権をすべてコンテナーaに移す。

~~~cpp
int main()
{
    std::set<int> a = {1,2,3} ;
    std::set<int> b = {4,5,6} ;

    // bの要素をすべてaに移す
    a.merge(b) ;

    // aは{1,2,3,4,5,6}
    // bは{}
}
~~~

もし、キーの重複を許さないコンテナーの場合で、値が重複した場合、重複した要素は移動しない。

~~~cpp
int main()
{
    std::set<int> a = {1,2,3} ;
    std::set<int> b = {1,2,3,4,5,6} ;

    a.merge(b) ;

    // aは{1,2,3,4,5,6}
    // bは{1,2,3}

}
~~~

mergeによって移動された要素を指すポインターとイテレーターは、要素の移動後も妥当である。ただし、所属するコンテナーのオブジェクトが変わる。

~~~cpp
int main()
{
    std::set<int> a = {1,2,3} ;
    std::set<int> b = {4,5,6} ;


    auto iterator = std::begin(b) ;
    auto pointer = &*iterator ;

    a.merge(b) ;

    // iteratorとpointerはまだ妥当
    // ただし要素はaに所属する
}
~~~


### ノードハンドル

ノードハンドルとは、コンテナーオブジェクトから要素を構築したストレージの所有権を切り離す機能だ。

ノードハンドルの型は、各コンテナーのネストされた型名node_typeとなる。例えばstd::set\<int\>のノードハンドル型は、std::set\<int\>::node_typeとなる。


ノードハンドルは以下のようなメンバーを持っている。

~~~c++
class node_handle
{
public :
    // ネストされた型名
    using value_type = ... ;        // set限定、要素型
    using key_type = ... ;          // map限定、キー型
    using mapped_type = ... ;       // map限定、マップ型
    using allocator_type = ... ;    // アロケーターの型

    // デフォルトコンストラクター
    // ムーブコンストラクター
    // ムーブ代入演算子


    // 値へのアクセス
    value_type & value() const ;   // set限定
    key_type & key() const ;        // map限定
    mapped_type & mapped() const ;  // map限定

    // アロケーターへのアクセス
    allocator_type get_allocator() const ;

    // 空かどうかの判定
    explicit operator bool() const noexcept ;
    bool empty() const noexcept ;

    void swap( node_handle & ) ;
} ;
~~~

setのノードハンドルはメンバー関数valueで値を得る。

~~~cpp
int main()
{
    std::set<int> c = {1,2,3} ;

    auto n = c.extract(2) ;

    // n.value() == 2
    // cは{1,3}
}
~~~

mapのノードハンドルはメンバー関数keyとmappedでそれぞれの値を得る。

~~~cpp
int main()
{
    std::map< int, int > m =
    {
        {1,1}, {2,2}, {3,3}
    } ;

    auto n = m.extract(2) ;

    // n.key() == 2 
    // n.mapped() == 2
    // mは{{1,1},{3,3}}

}
~~~


ノードハンドルはノードをコンテナーから切り離し、所有権を得る。そのため、ノードハンドルによって得たノードは、元のコンテナーから独立し、元のコンテナーオブジェクトの破棄の際にも破棄されない。ノードハンドルのオブジェクトの破棄時に破棄される。このため、ノードハンドルはアロケーターのコピーも持つ。


~~~cpp
int main()
{
    std::set<int>::node_type n ;

    {
        std::set<int> c = { 1,2,3 } ;
        // 所有権の移動
        n = c.extract( std::begin(c) ) ;
        // cが破棄される
    }

    // OK
    // ノードハンドルによって所有権が移動している。
    int x = n.value() ;

    // nが破棄される
}
~~~

### extract : ノードハンドルの取得

~~~c++
node_type extract( const_iterator position ) ;
node_type extract( const key_type & x ) ;
~~~

連想コンテナーと非順序連想コンテナーのメンバー関数extractは、ノードハンドルを取得するためのメンバー関数だ。

メンバー関数extract(position)は、イテレーターのpositionが指す要素を、コンテナーから除去して、その要素を所有するノードハンドルを返す。

~~~cpp
int main()
{
    std::set<int> c = {1,2,3} ;

    auto n1 = c.extract( std::begin(c) ) ;

    // cは{2,3}

    auto n2 = c.extract( std::begin(c) ) ;

    // cは{3}

}
~~~

メンバー関数extract(x)は、キーxがコンテナーに存在する場合、その要素をコンテナーから除去して、その要素を所有するノードハンドルを返す。存在しない場合、空のノードハンドルを返す。

~~~cpp
int main()
{
    std::set<int> c = {1,2,3} ;

    auto n1 = c.extract( 1 ) ;
    // cは{2,3}

    auto n2 = c.extract( 2 ) ;
    // cは{3}

    // キー4は存在しない
    auto n3 = c.extract( 4 ) ;
    // cは{3}
    // n3.empty() == true
}
~~~

キーの重複を許すコンテナーの場合、複数あるうちのひとつの所有権が開放される。

~~~cpp
int main()
{
    std::multiset<int> c = {1,1,1} ;
    auto n = c.extract(1) ;
    // cは{1,1}
}
~~~

### insert : ノードハンドルから要素の追加

~~~c++
// キーの重複を許さないコンテナーの場合
insert_return_type  insert(node_type&& nh);
// キーの重複を許すmultiコンテナーの場合
iterator  insert(node_type&& nh);

// ヒントつきのinsert
iterator            insert(const_iterator hint, node_type&& nh);
~~~

ノードハンドルをコンテナーのメンバー関数insertの実引数に渡すと、ノードハンドルから所有権をコンテナーに移動する。

~~~cpp
int main()
{
    std::set<int> a = {1,2,3} ;
    std::set<int> b = {4,5,6} ;

    auto n = a.extract(1) ;

    b.insert( std::move(n) ) ;

    // n.empty() == true
}
~~~

ノードハンドルが空の場合、何も起こらない。

~~~cpp
int main()
{
    std::set<int> c ;
    std::set<int>::node_type n ;

    // 何も起こらない
    c.insert( std::move(n) ) ;
}
~~~

キーの重複を許さないコンテナーに、すでにコンテナーに存在するキーと等しい値を所有するノードハンドルをinsertしようとすると、insertは失敗する。

~~~cpp
int main()
{
    std::set<int> c = {1,2,3} ;

    auto n = c.extract(1) ;
    c.insert( 1 ) ;

    // 失敗する
    c.insert( std::move(n) ) ; 
}
~~~

第一引数にイテレーターhintを受け取るinsertの挙動は、従来のinsertと同じだ。要素がhintの直前に追加されるのであれば償却定数時間で処理が終わる。

ノードハンドルを実引数に受け取るinsertの戻り値の型は、キーの重複を許すmultiコンテナーの場合iterator。キーの重複を許さないコンテナーの場合、insert_return_typeとなる。


multiコンテナーの場合、戻り値は追加した要素を指すイテレーターとなる。

~~~cpp
int main()
{
    std::multiset<int> c { 1,2,3 } ;

    auto n = c.extract( 1 ) ;

    auto iter = c.insert( n ) ;

    // cは{1,2,3}
    // iterは1を指す
}
~~~


キーの重複を許さないコンテナーの場合、コンテナーにネストされた型名insert_return_typeが戻り値の型となる。例えばset\<int\>の場合、set\<int\>::insert_return_typeとなる。

insert_return_typeの具体的な名前は規格上規定されていない。insert_return_typeは以下のようなデータメンバーを持つ型となっている。

~~~c++
struct insert_return_type
{
    iterator position ;
    bool inserted ;
    node_type node ;
} ;
~~~

positionはinsertによってコンテナーに所有権を移動して追加された要素を指すイテレーター、insertedは要素の追加が行われた場合にtrueとなるbool、nodeは要素の追加が失敗したときにノードハンドルの所有権が移動されるノードハンドルとなる。

insertに渡したノードハンドルが空のとき、insertedはfalse、positionはend()、nodeは空になる。

~~~cpp
int main()
{
    std::set<int> c = {1,2,3} ;
    std::set<int>::node_type n ; // 空

    auto [position, inserted, node] = c.insert( std::move(n) ) ;

    // inserted == false
    // position == c.end()
    // node.empty() == true
}
~~~

insertが成功したとき、insertedはtrue、positionは追加された要素を指す、nodeは空になる。

~~~cpp
int main()
{
    std::set<int> c = {1,2,3} ;
    auto n = c.extract(1) ;

    auto [position, inserted, node] = c.insert( std::move(n) ) ;

    // inserted == true
    // position == c.find(1)
    // node.empty() == true
}
~~~


insertが失敗した時、つまりすでに同一のキーがコンテナーに存在した時、insertedはfalse、nodeはinsertを呼び出す前のノードハンドルの値、positionはコンテナーの中の追加しようとしたキーに等しい要素を指す。insertに渡したノードハンドルは未規定の値になる。

~~~cpp
int main()
{
    std::set<int> c = {1,2,3} ;
    auto n = c.extract(1) ;
    c.insert(1) ;

    auto [position, inserted, node] = c.insert( std::move(n) ) ;

    // nは未規定の値。
    // inserted == false
    // nodeはinsert( std::move(n) )を呼び出す前のnの値
    // position == c.find(1)
}
~~~

規格はこの場合のnの値について規定していないが、最もあり得る実装としては、nはnodeにムーブされるので、nは空になり、ムーブ後の状態になる。

### ノードハンドルの利用例

ノードハンドルの典型的な使い方は以下の通り。


#### ストレージの再確保なしに、コンテナーの一部の要素だけ別のコンテナーに移す

~~~cpp
int main()
{
    std::set<int> a = {1,2,3} ;
    std::set<int> b = {4,5,6} ;

    auto n = a.extract(1) ;
    b.insert( std::move(n) ) ;
}
~~~

#### コンテナーの寿命を超えて要素を存続させる

~~~cpp
int main()
{
    std::set<int>::node_type n ;

    {
        std::set<int> c = {1,2,3} ;
        n = c.extract(1) ;
        // cが破棄される
    }

    // コンテナーの破棄後も存続する
    int value = n.value() ;
}
~~~

#### mapのキーを変更する

mapではキーは変更できない。キーを変更したければ、元の要素は削除して、新しい要素を追加する必要がある。これには動的なストレージの解放と確保が必要になる。

ノードハンドルを使えば、既存の要素のストレージに対して、所有権をmapから引き剥がした上で、キーを変更して、もう一度mapに差し戻すことができる。

~~~cpp
int main()
{
    std::map< std::string, std::string > m =
    {
        {"cat", "meow"},
        {"DOG", "bow"}, // キーを間違えたので変更したい
        {"cow", "moo"}
    } ;

    // 所有権を引き剥がす
    auto n = m.extract("DOG") ;
    // キーを変更
    n.key() = "dog" ;
    // 差し戻す
    m.insert( std::move(n) ) ;
}
~~~
