## mapとunordered_mapの変更

`map`と`unordered_map`に、`try_emplace`と`insert_or_assign`という2つのメンバー関数が入った。このメンバー関数は`multi_map`と`unordered_multi_map`には追加されていない。

### try_emplace

~~~c++
template <class... Args>
pair<iterator, bool>
try_emplace(const key_type& k, Args&&... args);

template <class... Args>
iterator
try_emplace(
    const_iterator hint,
    const key_type& k, Args&&... args);
~~~

従来の`emplace`は、キーに対応する要素が存在しない場合、要素が`args`から`emplace`構築されて追加される。もし、キーに対応する要素が存在する場合、要素は追加されない。要素が追加されないとき、`args`がムーブされるかどうかは実装定義である。

~~~cpp
int main()
{
    std::map< int, std::unique_ptr<int> > m ;

    // すでに要素が存在する
    m[0] = nullptr ;

    auto ptr = std::make_unique<int>(0) ;
    // emplaceは失敗する
    auto [iter, is_emplaced] = m.emplace( 0, std::move(ptr) ) ;

    // 結果は実装により異なる
    // ptrはムーブされているかもしれない
    bool b = ( ptr != nullptr ) ;
}
~~~

この場合、実際に`map`に要素は追加されていないのに、`ptr`はムーブされてしまうかもしれない。

このため、C++17では、要素が追加されなかった場合`args`はムーブされないことが保証される`try_emplace`が追加された。

~~~cpp
int main()
{
    std::map< int, std::unique_ptr<int> > m ;

    // すでに要素が存在する
    m[0] = nullptr ;

    auto ptr = std::make_unique<int>(0) ;
    // emplaceは失敗する
    auto [iter, is_emplaced] = m.emplace( 0, std::move(ptr) ) ;

    // trueであることが保証される
    // ptrはムーブされていない
    bool b = ( ptr != nullptr ) ;
}
~~~

### insert_or_assign

~~~c++
template <class M>
pair<iterator, bool>
insert_or_assign(const key_type& k, M&& obj);

template <class M>
iterator
insert_or_assign(
    const_iterator hint,
    const key_type& k, M&& obj);
~~~

`insert_or_assign`は`key`に連想された要素が存在する場合は要素を代入し、存在しない場合は要素を追加する。`operator []`との違いは、要素が代入されたか追加されたかが、戻り値の`pair`の`bool`でわかるということだ。

~~~cpp
int main()
{
    std::map< int, int > m ;
    m[0] = 0 ;

    {
        // 代入
        // is_insertedはfalse
        auto [iter, is_inserted] = m.insert_or_assign( 0, 1 ) ;
    }

    {
        // 追加
        // is_insertedはtrue
        auto [iter, is_inserted] = m.insert_or_assign( 1, 1 ) ;
    }
}
~~~
