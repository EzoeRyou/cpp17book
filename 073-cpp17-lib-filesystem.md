# ファイルシステム

ヘッダーファイル \<filesystem\> で定義されている標準ライブラリのファイルシステムは、ファイルやディレクトリーとその属性を扱うためのライブラリだ。

一般に「ファイルシステム」といった場合、例えばLinuxのext4、Microsoft WindowsのFATやNTFS、Apple MacのHFS+やAPFSといったファイルとその属性を表現するためのストレージ上のデータ構造を意味する。C++の標準ライブラリのファイルシステムとは、そのようなファイルシステムを実現するデータ構造を操作するライブラリではない。ファイルシステムというデータ構造で抽象化された、ファイルやディレクトリーとその属性、それに付随する要素、例えばパスやファイルやディレクトリーを操作するためのライブラリのことだ。

また、ファイルシステムライブラリでは、「ファイル」という用語は単に通常のファイルのみならず、ディレクトリー、シンボリックリンク、FIFO(名前付きパイプ)、ソケットなどの特殊なファイルも含む。

本書ではファイルシステムライブラリのすべてを詳細に解説していない。ファイルシステムライブラリは量が膨大なので、特定の関数の意味については、C++コンパイラーに付属のリファレンスマニュアルなどを参照するとよい。

## 名前空間

ファイルシステムライブラリはstd::filesystem名前空間スコープの下に宣言されている。

~~~cpp
int main()
{
    std::filesystem::path p("/bin") ;
}
~~~

この名前空間は長いので、ファイルシステムライブラリを使うときは、関数のブロックスコープ単位でusingディレクティブを使うか、名前空間エイリアスを使って短い別名をつけるとよい。

~~~cpp
void using_directive()
{
    // usingディレクティブ
    using namespace std::filesystem ;

    path p("/etc") ;
}

void namespace_alias()
{
    // 名前空間エイリアス
    namespace fs = std::filesystem ;

    fs::path p("/usr") ;
}
~~~

## POSIX準拠

C++のファイルシステムのファイル操作の挙動は、POSIX規格に従う。実装によってはPOSIXに規定された挙動を提供できない場合もある。その場合は制限の範囲内で、できるだけPOSIXに近い挙動を行う。実装がどのような意味のある挙動も提供できない場合、エラーが通知される。

## ファイルシステムの全体像

ファイルシステムライブラリの全体像を簡単に箇条書きすると以下の通り。

+ クラスpathでファイルパス文字列を扱う
+ 例外クラスfilesystem_errorとクラスerror_codeでエラー通知
+ クラスfile_statusでファイルの情報とパーミッションの取得、設定
+ クラスdirectory_entryでディレクトリーの情報の取得、設定
+ クラスdirectory_iteratorでディレクトリー構造をイテレーターとしてたどる
+ 多数のフリー関数でファイルとディレクトリーの操作

## エラー処理

ファイルシステムライブラリでエラーが発生した場合、エラーの通知方法には2種類の方法がある。例外を使う方法と、ヘッダーファイル\<system_error\>で定義されているエラー通知用のクラスstd::error_codeへのリファレンスを実引数として渡してエラー内容を受け取る方法だ。

エラー処理の方法は、エラーの起こる期待度によって選択できる。一般に、エラーがめったに起こらない場合、エラーが起こるのは予期していない場合、エラー処理には例外を使ったほうがよい。エラーが頻繁に起こる場合、エラーが起こることが予期できる場合、エラー処理には例外を使わないほうがよい。

### 例外

ファイルシステムライブラリの関数のうち、std::error_code &型を実引数に取らない関数は、以下のようにエラー通知を行う。

+ OSによるファイルシステム操作においてエラーが発生した場合、std::filesystem::filesystem_error型の例外がthrowされる。一つのpathを実引数に取る関数の場合、filesystem_errorのメンバー関数path1で実引数のpathが得られる。2つのpathを実引数に取る関数の場合、filesystem_errorのメンバー関数path1, path2で第一、第二引数がそれぞれ得られる。filesystem_errorはエラー内容に応じたerror_codeを持つ

+ ストレージの確保に失敗した場合、既存の例外による通知が行われる

+ デストラクターは例外を投げない

例外を使ったエラー処理は以下の通り。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    try {
        // ファイル名から同じファイル名へのコピーによるエラー
        path file("foobar.txt") ;
        std::ofstream{ file } ;
        copy_file( file, file ) ;
       
    } catch( filesystem_error & e )
    { // エラーの場合
        auto path1 = e.path1() ; // 第一引数
        auto path2 = e.path2() ; // 第二引数
        auto error_code = e.code() ; // error_code
        
        std::cout
            << "error number: " << error_code.value ()
            << "\nerror message: " << error_code.message() 
            << "\npath1: " << path1
            << "\npath2: " << path2 << '\n' ;
    }
}
~~~


filesystem_errorは以下のようなクラスになっている。

~~~c++
namespace std::filesystem {
    class filesystem_error : public system_error {
    public:
        // 第一引数
        const path& path1() const noexcept;
        // 第二引数
        const path& path2() const noexcept;
        // エラー内容を人間が読めるnull終端文字列で返す
        const char* what() const noexcept override;
    };
}
~~~

### 非例外

ファイルシステムライブラリの関数のうち、std::error_code &型を実引数に取る関数は、以下のようにエラー通知を行う。

+ OSによるファイルシステム操作においてエラーが発生した場合、error_code &型の実引数がエラー内容に応じて設定される。エラーがない場合、error_code &型の実引数に対してメンバー関数clear()が呼ばれる。


~~~cpp
int main()
{
    using namespace std::filesystem ;

    // ファイル名から同じファイル名へのコピーによるエラー
    path file("foobar.txt") ;
    std::ofstream{ file } ;
    std::error_code error_code;
    copy_file( file, file, error_code ) ;

    if ( error_code )
    { // エラーの場合
        auto path1 = file ; // 第一引数
        auto path2 = file ; // 第二引数
        
        std::cout
            << "error number: " << error_code.value ()
            << "\nerror message: " << error_code.message() 
            << "\npath1: " << path1
            << "\npath2: " << path2 << '\n' ;
    }
}
~~~

## path : ファイルパス文字列クラス

std::filesystem::pathはファイルパスを文字列で表現するためのクラスだ。文字列を表現するクラスとしてC++にはすでにstd::stringがあるが、ファイルパスという文字列を表現するために、別の専用クラスが作られた。

クラスpathは以下の機能を提供する。

+ ファイルパス文字列の表現
+ ファイルパス文字列の操作

pathはファイルパス文字列の表現と操作だけを提供するクラスで、物理ファイルシステムへの変更のコミットはしない。


ファイルパス文字列がどのように表現されているかは実装により異なる。POSIX環境では文字型をchar型としてUTF-8エンコードで表現するOSが多いが、Microsoft Windowsで本書執筆現在、文字型をwchar_tとしてUTF-16エンコードで表現する慣習になっている。

また、OSによってはラテンアルファベットの大文字小文字を区別しなかったり、区別はするが無視されたりする実装もある。

クラスpathはそのようなファイルパス文字列の差異を吸収してくれる。

クラスpathには以下のようなネストされた型名がある。

~~~c++
namespace std::filesystem {
class path {
public:
    using value_type = see below ;
    using string_type = basic_string<value_type>;
    static constexpr value_type preferred_separator = see below ;
} ;
~~~

value_typeとstring_typeはpathが内部でファイルパス文字列を表現するのに使う文字と文字列の型だ。preferred_separatorは、推奨されるディレクトリー区切り文字だ。例えばPOSIX互換環境では`/`が用いられるが、Microsoft Windowsでは`\`が使われている。

### ファイルパスの文字列

ファイルパスは文字列で表現する。C++の文字列のエンコードには以下のものがある。

+ char:     ネイティブナローエンコード
+ wchar_t:  ネイティブワイドエンコード
+ char:     UTF-8エンコード
+ char16_t: UTF-16エンコード
+ char32_t: UTF-32エンコード

path::value_typeがどの文字型を使い、どの文字列エンコードを使っているかは実装依存だ。pathはどの文字列エンコードが渡されても、path::value_typeの文字型と文字エンコードになるように自動的に変換が行われる。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    // ネイティブナローエンコード
    path p1( "/dev/null" ) ;
    // ネイティブワイドエンコード
    path p2( L"/dev/null" ) ;
    // UTF-16エンコード
    path p3( u"/dev/null" ) ;
    // UTF-32エンコード
    path p4( U"/dev/null" ) ;
}
~~~

なので、どの文字列エンコードで渡しても動く。

C++ではUTF-8エンコードの文字型はcharで、これはネイティブナローエンコードの文字型と同じなので、型システムによって区別できない。そのため、UTF-8文字列リテラルを渡すと、ネイティブナローエンコードとして認識される。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    // ネイティブナローエンコードとして解釈される
    path p( u8"ファイル名" ) ;
}
~~~

このコードは、ネイティブナローエンコードがUTF-8ではない場合、動く保証のない移植性の低いコードだ。UTF-8エンコードを移植性の高い方法でファイルパスとして使いたい場合、u8pathを使うとよい。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    // UTF-8エンコードとして解釈される
    // 実装の使う文字エンコードに変換される
    path = u8path( u8"ファイル名" ) ;
}
~~~

u8path(Source)はSourceをUTF-8エンコードされた文字列として扱うので、通常の文字列リテラルを渡すと、ネイティブナローエンコードがUTF-8ではない環境では問題になる。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    // UTF-8エンコードとして解釈される
    // ネイティブナローエンコードがUTF-8ではない場合、問題になる
    path = u8path( "ファイル名" ) ;
}
~~~

u8pathを使う場合は、文字列は必ずUTF-8エンコードしなければならない。

環境によっては、ファイルパスに使える文字に制限があり、また特定の文字列は特別な意味を持つ予約語になっていることもあるので、移植性の高いプログラムの作成に当たってはこの点でも注意が必要だ。例えば、環境によっては大文字小文字の区別をしないかもしれない。また、CONやAUXのような文字列が特別な意味を持つかもしれない。

pathに格納されているファイルパス文字列を取得する方法は、環境依存の文字列エンコードとファイルパスの表現方法の差異により、様々な方法が用意されている。

ファイルパス文字列のフォーマットには以下の2つがある。

+ ネイティブ:   実装依存のフォーマット
+ ジェネリック: 汎用的な標準のフォーマット

POSIX準拠の環境においては、ネイティブとジェネリックは全く同じだ。POSIX準拠ではない環境では、ネイティブとジェネリックは異なるフォーマットを持つ可能性がある。

例えば、Microsoft Windowsでは、ネイティブのファイルパス文字列はディレクトリーの区切り文字にPOSIX準拠の`/`ではなく`\`を使っている。

まずメンバー関数nativeとc_strがある。

~~~c++
class path {
{
public :
    const string_type& native() const noexcept;
    const value_type* c_str() const noexcept;
} ;
~~~


これはクラスpathが内部で使っている実装依存のネイティブな文字列型をそのまま返すものだ。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    path p = current_path() ;

    // 実装依存のbasic_stringの特殊化
    path::string_type str = p.native() ;

    // 実装依存の文字型
    path::value_type const * ptr = p.c_str() ;
    
}
~~~

このメンバー関数を使うコードは移植性に注意が必要だ。

strの型はpath::string_typeで、ptrの型は実装依存のpath::value_type const *だ。path::value_typeとpath::string_typeは、charやwchar_t、std::stringやstd::wstringのようなC++が標準で定義する型ではない可能性がある。

そして、path::string_typeへの変換関数operator string_type()がある。

~~~cpp
int main()
{
    using namespace std::experimental::filesystem ;

    auto p = current_path() ;

    // 暗黙の型変換
    path::string_type str = p ;
}
~~~

pathのoperator string_type()は、ネイティブの文字列型を既存のファイルストリームライブラリでオープンできる形式に変換して返す。例えば空白文字を含むファイルパスのために、二重引用符で囲まれている文字列に変換されるかもしれない。


~~~cpp
int main()
{
    using namespace std::filesystem ;

    path name("foo bar.txt") ;
    std::basic_ofstream<path::value_type> file( name ) ;
    file << "hello" ;
}
~~~

ネイティブのファイルパス文字列をstring, wstring, u16string, u32stringに変換して取得するメンバー関数に以下のものがある。

~~~c++
class path {
public :
    std::string string() const;
    std::wstring wstring() const;
    std::string u8string() const;
    std::u16string u16string() const;
    std::u32string u32string() const;
} ;
~~~

このうち、メンバー関数stringはネイティブナローエンコードされたstd::string、メンバー関数u8stringはUTF-8エンコードされたstd::stringを返す。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    path name("hello.txt") ;
    std::ofstream file( name.string() ) ;
    file << "hello" ;
}
~~~

ファイルパス文字列をジェネリックに変換して返すgeneric_string()系のメンバー関数がある。

~~~c++
class path {
public :
    std::string generic_string() const;
    std::wstring generic_wstring() const;
    std::string generic_u8string() const;
    std::u16string generic_u16string() const;
    std::u32string generic_u32string() const
} ;
~~~

使い方はネイティブな文字列を返すstring()系のメンバー関数と同じだ。

ファイルパスの文字列の文字型と文字列エンコードは環境ごとに異なるので、移植性の高いコードを書くときには注意が必要だ。

現実的には、モダンなPOSIX準拠の環境では、文字型はchar、文字列型はstd::string、エンコードはUTF-8になる。

Microsoft WindowsのWin32サブシステムとMSVCはPOSIX準拠ではなく、本書執筆時点では、歴史的経緯により、文字型はwchar_t、文字列型はstd::wstring、エンコードはUTF-16となっている。


### ファイルパスの操作

クラスpathはファイルパス文字列の操作を提供している。std::stringとは違い、findやsubstrのような操作は提供していないが、ファイルパス文字列に特化した操作を提供している。

operator /, operator /=はセパレーターで区切ったファイルパス文字列の追加を行う。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    path p("/") ;

    // "/usr"
    p /= "usr" ;
    // "usr/local/include"
    p = p / "local" / "include" ;
}
~~~

operator +=は単なる文字列の結合を行う。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    path p("/") ;

    // "/usr"
    p += "usr" ;
    // "/usrlocal"
    p += "local" ;
    // "/usrlocalinclude"
    p += "include" ;
}
~~~

operator /と違い、operator +は存在しない。

その他にも、pathは様々なファイルパス文字列に対する操作を提供している。以下はその一例だ。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    path p( "/home/cpp/src/main.cpp" ) ;

    // "main.cpp"
    path filename = p.filename() ;
    // "main"
    path stem = p.stem() ;
    // ".cpp"
    path extension = p.extension() ;
    // "/home/cpp/src/main.o"
    p.replace_extension("o") ;
    // "/home/cpp/src/"
    p.remove_filename() ;
}
~~~

pathはファイルパス文字列に対してよく行う文字列処理を提供している。例えばファイル名だけ抜き出す処理、拡張子だけ抜き出す処理、拡張子を変える処理などだ。

## file_status

クラスfile_statusはファイルのタイプとパーミッションを保持するクラスだ。

ファイルのタイプとパーミッションはファイルパス文字列を指定して取得する方法が別途あるが、その方法では毎回物理ファイルシステムへのアクセスが発生する。file_statusはファイルのタイプとパーミッション情報を保持するクラスとして、いわばキャッシュの役割を果たす。

file_statusは物理ファイルシステムへの変更のコミットはしない。

file_statusクラスはstatus(path)もしくはstatus(path, error_code)で取得できる。あるいは、directory_entryのメンバー関数status()から取得できる。

タイプというのは、ファイルが種類を表すenum型file_typeで、通常のファイルやディレクトリーやシンボリックリンクといったファイルの種類を表す。

パーミッションというのは、ファイルの権限を表すビットマスクのenum型permsで、ファイルの所有者とグループと他人に対す読み込み、書き込み、実行のそれぞれの権限を表している。この値はPOSIXの値を同じになっている。

ファイルのタイプとパーミッションを取得するメンバー関数は以下の通り。

~~~c++
class file_type {
public :
    file_type type() const noexcept;
    perms permissions() const noexcept;
} ;
~~~

以下のように使う。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    directory_iterator iter("."), end ;

    int regular_files = 0 ;
    int execs = 0 ;

    std::for_each( iter, end, [&]( auto entry )
    {
        auto file_status = entry.status() ;
        // is_regular_file( file_status )でも可
        if ( file_status.type() == file_type::regular )
            ++regular_files ;

        constexpr auto exec_bits = perms::owner_exec | perms::group_exec | perms::others_exec ;

        auto permissions = file_status.permissions() ;
        if ( (  permissions != perms::unknown) &&
                (permissions & exec_bits) != perms::none ) 
            ++execs ;
    } ) ;

    std::cout << "Curernt directory has " << regular_files << " regular files.\n" ;
    std::cout << execs << " files are executable.\n" ;
}
~~~

このプログラムは、カレントディレクトリーにある通常のファイルの数と、実行可能なファイルの数を表示する。

ファイルパーミッションを表現するenum型permsは、パーミッションが不明な場合perms::unknownになる。この値は0xFFFFなのでビット演算をする場合には注意が必要だ。

それ以外のpermsの値はPOSIXに準拠しているが、permsはscoped enum型なので、明示的なキャストが必要だ。

~~~c++
// エラー
std::filesystem::perms a = 0755 ;

// OK
std::filesystem::perms b = std::filesystem::perms(0755) ;
~~~

ファイルのタイプとパーミッションを書き換えるメンバー関数は以下の通り。

~~~c++
void type(file_type ft) noexcept;
void permissions(perms prms) noexcept;
~~~

ただし、file_statusというのは単なるキャッシュ用のクラスなので、file_statusのタイプとパーミッションを「書き換える」というのは、単にfile_statusのオブジェクトに保持されている値を書き換えるだけで、物理ファイルシステムに反映されるものではない。物理ファイルシステムを書き換えるには、フリー関数のpermissionsを使う。


## directory_entry

クラスdirectory_entryはファイルパス文字列を保持し、ファイルパスの指し示すファイルの情報を取得できるクラスだ。

物理ファイルシステムからファイルの情報を毎回読むのは非効率的だ。directory_entryはいわばファイル情報のキャッシュとしての用途を持つ。

directory_entryは物理ファイルシステムから情報を読み込むだけで、変更のコミットはしない。

directory_entryの構築は、コンストラクターに引数としてpathを与える他、directory_iteratorとrecursive_directory_iteratorからも得ることができる。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    path p(".") ;

    // ファイルパス文字列から得る
    directory_entry e1(p) ;

    // イテレーターから得る
    directory_iterator i1(p) ;
    directory_entry e2 = *i1 ;

    recursive_directory_iterator i2(p) ;
    directory_entry e3 = *i2 ;
}
~~~

directory_entoryには様々なファイル情報を取得するメンバー関数があるが、これは同じ機能のものがフリー関数でも用意されている。directory_entryを使うと、ファイル情報をキャッシュできるため、同じファイルパスに対して、物理ファイルシステムの変更がないときに複数回のファイル情報取得を行うのが効率的になる。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    directory_entry entry("/home/cpp/foo") ;

    // 存在確認
    bool b = entry.exists() ;

    // "/home/cpp/foo"
    path p = entry.path() ;
    file_status s = entry.status() ;

    // ファイルサイズを取得
    std::uintmax_t size = entry.file_size() ;

    {
        std::ofstream foo( entry.path() ) ;
        foo << "hello" ;
    }

    // 物理ファイルシステムから情報を更新
    entry.refresh() ;
    // もう一度ファイルサイズを取得
    size = entry.file_size() ;

    // 情報を取得するファイルパスを
    // "/home/cpp/bar"
    // に置き換えてrefresh()を呼び出す
    entry.replace_filename("bar") ;
}
~~~

directory_entryはキャッシュ用のクラスで、自動的に物理ファイルシステムの変更に追随しないので、最新の情報を取得するには、明示的にメンバー関数refreshを呼び出す必要がある。

## directory_iterator

directory_iteratorは、あるディレクトリー下に存在するファイルパスをイテレーターの形式で列挙するためのクラスだ。

例えば、カレントディレクトリー下のファイルパスをすべて列挙するコードは以下のようになる。

~~~cpp
int main()
{
    using namespace std::filesystem ;
    directory_iterator iter("."), end ;
    std::copy( iter, end, std::ostream_iterator<path>(std::cout, "\n") ) ;
}
~~~

directory_iteratorはコンストラクターとしてpathを渡すと、そのディレクトリー下の最初のファイルに相当するdirectory_entryを返すイテレーターとなる。コンストラクターで指定されたディレクトリー下にファイルが存在しない場合、終端イテレーターになる。

directory_iterator_のデフォルトコンストラクターは終端イテレーターになる。終端イテレーターはデリファレンスできない。

directory_itertor::value_typeはdirectory_entryで、イテレーターのカテゴリーは入力イテレーターとなる。

directory_iteratorはカレントディレクトリー(.)と親ディレクトリー(..)は列挙しない。

directory_iteratorがディレクトリー下のファイルをどのような順番で列挙するかは未規定だ。

directory_iteratorによって返されるファイルパスは存在しない可能性があるので、ファイルが存在することを当てにしてはいけない。例えば、存在しないファイルへのシンボリックリンクかもしれない。

direcotry_iteratorのオブジェクトが作成されたあとに物理ファイルシステムになされた変更は、反映されるかどうか未規定である。

directory_iteratorのコンストラクターは列挙時の動作を指定できるdirectory_optionsを実引数に受け取ることができる。しかし、C++17の標準規格の範囲ではdirectory_iteratorの挙動を変更するdirectory_optionsは規定されていない。

### エラー処理

directory_iteratorは構築時にエラーが発生することがある。このエラーを例外ではなくerror_codeで受け取りたい場合、コンストラクターの実引数でerror_codeへのリファレンスを渡す。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    std::error_code err ;

    directory_iterator iter("this-directory-does-not-exist", err) ;

    if ( err )
    {
        // エラー処理
    }
}
~~~

directory_iteratorはインクリメント時にエラーが発生することがある。このエラーを例外ではなくerror_codeで受け取りたい場合、メンバー関数incrementを呼び出す。

~~~cpp
int main()
{
    using namespace std::experimental::filesystem ; 

    recursive_directory_iterator iter("."), end ;

    std::error_code err ;

    for ( ; iter != end && !err ; iter.increment( err ) )
    {
        std::cout << *iter << "\n" ;
    }

    if ( err )
    {
        // エラー処理
    }
}
~~~

## recursive_directory_iterator

recursive_directory_iteratorは指定されたディレクトリー下に存在するサブディレクトリーの下も含めて、すべてのファイルを列挙する。使い方はdirectory_iteratorとほぼ同じだ。

~~~cpp
int main()
{
    using namespace std::filesystem ; 
    recursive_directory_iterator iter("."), end ;

    std::copy( iter, end, std::ostream_iterator<path>(std::cout, "\n") ) ;
}
~~~

メンバー関数options, depth, recursion_pending, pop, disable_recursion_pendingをデリファレンスできないイテレーターに対して呼び出した際の挙動は未定義だ。

### オプション

recursive_directory_iteratorはコンストラクターの実引数にdirectory_options型のscoped enum値を取ることによって、挙動を変更できる。directory_options型のenum値はビットマスクになっていて、以下の3つのビットマスク値が規定されている。

名前                            意味
------                          ------
none                            デフォルト。ディレクトリーシンボリックリンクをスキップ。パーミッション違反はエラー
follow_directory_symlink        ディレクトリーシンボリックリンクの中も列挙
skip_permission_denied          パーミッション違反のディレクトリーはスキップ

このうち取りうる組み合わせは、none, follow_directory_symlink, skip_permission_denied, follow_directory_symlink | skip_permission_deniedの4種類になる。

~~~cpp
int main()
{
    using namespace std::filesystem ; 
    recursive_directory_iterator iter("/", directory_options::skip_permission_denied), end ;

    std::copy( iter, end, std::ostream_iterator<path>(std::cout, "\n") ) ;
}
~~~

follow_directory_symlinkは、親ディレクトリーへのシンボリックリンクが存在する場合、イテレーターが終端イテレーターに到達しない可能性があるので注意すること。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    // 自分自身を含むディレクトリーに対するシンボリックリンク
    create_symlink(".", "foo") ;

    recursive_directory_iterator iter(".", directory_options::follow_directory_symlink), end ;

    // エラー、もしくは終了しない
    std::copy( iter, end, std::ostream_iterator<path>(std::cout) ) ;
}
~~~

recursive_directory_iteratorの現在のdirectory_optionsを得るには、メンバー関数optionsを呼ぶ。

~~~c++
class recursive_directory_iterator {
public :
    directory_options options() const ;
} ;
~~~

### depth : 深さ取得
recursive_directory_iteratorが現在列挙しているディレクトリーの深さを知るには、メンバー関数depthを呼ぶ。

~~~c++
class recursive_directory_iterator {
public :
    int depth() const ;
} ;
~~~

最初のディレクトリーの深さは0で、次のサブディレクトリーの深さは1、それ以降のサブディレクトリーも同様に続く。


### pop : 現在のディレクトリーの列挙中止

メンバー関数popを呼ぶと、現在列挙中のディレクトリーの列挙を取りやめ、親ディレクトリーに戻る。現在のディレクトリーが初期ディレクトリーの場合、つまりdepth() == 0の場合は、終端イテレーターになる。

~~~c++
class recursive_directory_iterator {
public :
    void pop();
    void pop(error_code& ec);
} ;
~~~

例えば、カレントディレクトリーが以下のようなディレクトリーツリーで、イテレーターが以下に書かれた順番でファイルを列挙する環境の場合、

~~~
a
b
b/a
b/c
b/d
c
d
~~~

以下のようなプログラムを実行すると、

~~~cpp
int main()
{
    std::filesystem ;

    recursive_directory_iterator iter("."), end ;

    auto const p = canonical("b/a") ;

    for ( ; iter != end ; ++iter )
    {
        std::cout << *iter << '\n' ;

        if ( canonical(iter->path()) == p )
            iter.pop() ;
    }
}
~~~

標準出力が指すファイルとその順番は以下のようになる。

~~~
a
b
b/a
c
d
~~~

"b/a"に到達した時点でpop()が呼ばれるので、それ以上のディレクトリーb下の列挙が中止され、親ディレクトリーであるカレントディレクトリーに戻る。

### recursion_pending : 現在のディレクトリーの再帰をスキップ

disable_recursion_pendingは現在のディレクトリーの下を再帰的に列挙することをスキップする機能だ。

~~~c++
class recursive_directory_iterator {
public :
    bool recursion_pending() const ;
    void disable_recursion_pending() ;
} ;
~~~

recursion_pending()は、直前のイテレーターのインクリメント操作の後にdisable_recursion_pending()が呼ばれていない場合、trueを返す。そうでない場合はfalseを返す。

言い換えれば、disable_recursion_pending()を呼んだ直後で、まだイテレーターのインクリメント操作をしていない場合、recursion_pneding()はfalseを返す。

~~~cpp
int main()
{
    using namespace std ;
    recursive_directory_iterator iter("."), end ;

    // true
    bool b1 = iter.recursion_pending() ;

    iter.disable_recursion_pending() ;
    // false
    bool b2 = iter.recursion_pending() ;

    ++iter ;
    //  true
    bool b3 = iter.recursion_pending() ;


    iter.disable_recursion_pending() ;
    // false
    bool b4 = iter.recursion_pending() ;
}
~~~

現在recursive_directory_iteratorが指しているファイルパスがディレクトリーである場合、そのイテレーターをインクリメントすると、そのディレクトリー下を再帰的に列挙することになる。しかし、recursion_pending()がfalseを返す場合、ディレクトリーの最適的な列挙はスキップされる。インクリメント操作が行われた後はrecursion_pending()の結果はtrueに戻る。

つまり、disable_recursion_pendingは、現在指しているディレクトリー下を再帰的に列挙することをスキップする機能を提供する。

例えば、カレントディレクトリーが以下のようなディレクトリーツリーで、イテレーターが以下に書かれた順番でファイルを列挙する環境の場合、

~~~
a
b
b/a
b/c
b/d
c
d
~~~

以下のようなプログラムを実行すると、

~~~cpp
int main()
{
    std::filesystem ;

    recursive_directory_iterator iter("."), end ;

    auto const p = canonical("b/a") ;

    for ( ; iter != end ; ++iter )
    {
        std::cout << *iter << '\n' ;

        if ( iter->is_directory() )
            iter.disable_recursion_pending() ;
    }
}
~~~

標準出力が指すファイルとその順番は以下のようになる。

~~~
a
b
c
d
~~~

このプログラムはディレクトリーであれば必ずdisable_recursion_pending()が呼ばれるので、サブディレクトリーの再帰的な列挙は行われず、結果的に動作はdirectory_iteratorと同じになる。

disable_recursion_pendingを呼び出すことによって、選択的にディレクトリーの再帰的な列挙をスキップさせることができる。

## ファイルシステム操作関数

### ファイルパス取得

#### current_path

~~~c++
path current_path();
path current_path(error_code& ec);
~~~

カレント・ワーキング・ディレクトリー(current working directory)への絶対パスを返す。

#### temp_directory_path

~~~c++
path temp_directory_path();
path temp_directory_path(error_code& ec);
~~~

一時ファイルを作成するのに最適な一時ディレクトリー(tempolary directory)へのファイルパスを返す。

### ファイルパス操作

#### absolute

~~~c++
path absolute(const path& p);
path absolute(const path& p, error_code& ec);
~~~

pへの絶対パスを返す。pの指すファイルが存在しない場合の挙動は未規定。

#### canonical

~~~c++
path canonical(const path& p, const path& base = current_path());
path canonical(const path& p, error_code& ec);
path canonical(const path& p, const path& base, error_code& ec);
~~~

存在するファイルへのファイルパスpへの、シンボリックリンク、カレントディレクトリー(.)、親ディレクトリー(..)の存在しない絶対パスを返す。

#### wealky_canonical

~~~c++
path weakly_canonical(const path& p);
path weakly_canonical(const path& p, error_code& ec);
~~~

ファイルパスpのシンボリックリンクが解決され、正規化されたパスを返す。ファイルパスの正規化についての定義は長くなるので省略。

#### relative

~~~c++
path relative(const path& p, error_code& ec);
path relative(const path& p, const path& base = current_path());
path relative(const path& p, const path& base, error_code& ec);
~~~

ファイルパスbaseからファイルパスpに対する相対パスを返す。

#### proximate

~~~c++
path proximate(const path& p, error_code& ec);
path proximate(const path& p, const path& base = current_path());
path proximate(const path& p, const path& base, error_code& ec);
~~~

ファイルパスbaseからのファイルパスpに対する相対パスが空パスでなければ相対パスを返す。相対パスが空パスならばpが返る。

### 作成

#### create_directory

~~~c++
bool create_directory(const path& p);
bool create_directory(const path& p, error_code& ec) noexcept;
~~~

pの指すディレクトリーをひとつ作成する。新しいディレクトリーが作成できた場合はtrueを、作成できなかった場合はfalseを返す。pが既存のディレクトリーを指していて新しいディレクトリーが作成できなかった場合はエラーにはならない。単にfalseが返る。

~~~c++
bool create_directory(const path& p, const path& existing_p);
bool create_directory(const path& p, const path& existing_p, error_code& ec) noexcept;
~~~

新しく作成するディレクトリーpのアトリビュートを既存のディレクトリーexisting_pと同じものにする。

#### create_directories

~~~c++
bool create_directories(const path& p);
bool create_directories(const path& p, error_code& ec) noexcept;
~~~

ファイルパスpの中のディレクトリーで存在しないものをすべて作成する。

以下のプログラムは、カレントディレクトリーの下のディレクトリーaの下のディレクトリーbの下にディレクトリーcを作成する。もし、途中のディレクトリーであるa, bが存在しない場合、それも作成する。

~~~cpp
int main()
{
    using namespace std::filesystem ;
    create_directories("./a/b/c") ;
}
~~~

戻り値は、ディレクトリーを作成した場合true、そうでない場合false。

#### create_directory_symlink

~~~c++
void create_directory_symlink(const path& to, const path& new_symlink);
void create_directory_symlink(const path& to, const path& new_symlink, error_code& ec) noexcept;
~~~

ディレクトリーtoに解決されるシンボリックリンクnew_symlinkを作成する。

一部のOSでは、ディレクトリーへのシンボリックリンクとファイルへのシンボリックリンクを作成時に明示的に区別する必要がある。ポータブルなコードはディレクトリーへのシンボリックリンクを作成するときにはcreate_symlinkではなくcreate_directory_symlinkを使うべきである。

一部のOSはシンボリックリンクをサポートしていない。ポータブルなコードでは注意すべきである。

#### create_symlink

~~~c++
void create_symlink(const path& to, const path& new_symlink);
void create_symlink(const path& to, const path& new_symlink, error_code& ec) noexcept;
~~~

ファイルパスtoに解決されるシンボリックリンクnew_symlinkを作成する。

#### create_hard_link

~~~c++
void create_hard_link(const path& to, const path& new_hard_link);
void create_hard_link(const path& to, const path& new_hard_link, error_code& ec) noexcept;
~~~

ファイルパスtoに解決されるハードリンクnew_hard_linkを作成する。

### コピー

#### copy_file

~~~c++
bool copy_file(const path& from, const path& to);
bool copy_file(const path& from, const path& to, error_code& ec) noexcept;
bool copy_file(const path& from, const path& to, copy_options options);
bool copy_file(const path& from, const path& to, copy_options options, error_code& ec) noexcept;
~~~

ファイルパスfromのファイルをファイルパスtoにコピーする。

copy_optionsはコピーの挙動を変えるビットマスクのenum型で、以下のenum値がサポートされている。


名前                意味
------              ------
none                デフォルト、ファイルがすでに存在する場合はエラー
skip_existing       既存のファイルを上書きしない。スキップはエラーとして報告しない
overwrite_existing  既存のファイルを上書きする
update_existing     既存のファイルが上書きしようとするファイルより古ければ上書きする

#### copy

~~~c++
void copy(const path& from, const path& to);
void copy(const path& from, const path& to, error_code& ec) noexcept;
void copy(const path& from, const path& to, copy_options options);
void copy(const path& from, const path& to, copy_options options, error_code& ec) noexcept;
~~~

ファイルパスfromのファイルをファイルパスtoにコピーする。


copy_optionsはコピーの挙動を変えるビットマスク型のenum型で、以下のenum値がサポートされている。

+ サブディレクトリーに関する指定

名前                意味
------              ------
none                デフォルト、サブディレクトリーはコピーしない
recursive           サブディレクトリーとその中身もコピーする

+ シンボリックリンクに関する指定

名前                意味
------              ------
none                デフォルト、シンボリックリンクをフォローする
copy_symlinks       シンボリックリンクをシンボリックリンクとしてコピーする。シンボリックリンクが指すファイルを直接コピーしない
skip_symlinks       シンボリックリンクを無視する

+ コピー方法に関する指定

名前                意味
------              ------
none                デフォルト、ディレクトリー下の中身をコピーする
directories_only    ディレクトリー構造のみをコピーする。非ディレクトリーファイルはコピーしない
create_symlinks     ファイルをコピーするのではなく、シンボリックリンクを作成する。コピー先がカレントディレクトリーではない場合、コピー元のファイルパスは絶対パスでなければならない
create_hard_links   ファイルをコピーするのではなく、ハードリンクを作成する


#### copy_symlink

~~~c++
void copy_symlink(const path& existing_symlink, const path& new_symlink);
void copy_symlink(const path& existing_symlink, const path& new_symlink, error_code& ec) noexcept;
~~~

existing_symlinkをnew_symlinkにコピーする。

### 削除

#### remove

~~~c++
bool remove(const path& p);
bool remove(const path& p, error_code& ec) noexcept;
~~~

ファイルパスpの指すファイルが存在するのであれば削除する。ファイルがシンボリックリンクの場合、シンボリックリンクファイルが削除される。フォロー先は削除されない。

戻り値として、ファイルが存在しない場合falseを返す。それ以外の場合trueを返す。error_codeでエラー通知を受け取る関数オーバーロードでは、エラーならばfalseが変える。


#### remove_all

~~~c++
uintmax_t remove_all(const path& p);
uintmax_t remove_all(const path& p, error_code& ec) noexcept;
~~~

ファイルパスpの下の存在するファイルをすべて削除したあと、pの指すファイルも削除する。

つまり、pがディレクトリーファイルを指していて、そのディレクトリー下にサブディレクトリーやファイルが存在する場合、それらがすべて削除され、ディレクトリーpも削除される。

pがディレクトリーではないファイルを指す場合、pが削除される。

戻り値として、削除したファイルの個数が返る。error_codeでエラー通知を受け取る関数オーバーロードの場合、エラーならばstatic_cast\<uintmax_t\>(-1)が返る。



### 変更

#### permissions

~~~c++
void permissions(const path& p, perms prms, perm_options opts=perm_options::replace);
void permissions(const path& p, perms prms, error_code& ec) noexcept;
void permissions(const path& p, perms prms, perm_options opts, error_code& ec);
~~~

ファイルパスpのパーミッションを変更する。

optsはperm_options型のenum値、replace, add, removeのうちいずれかひとつと、別途nofollowを指定することができる。省略した場合はreplaceになる。

カレントディレクトリーに存在するファイルfooを、すべてのユーザーに対して実行権限を付加するには、以下のように書く。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    permissions( "./foo", perms(0111), perm_options::add ) ;
}
~~~


perm_optionsは以下のようなenum値を持つ。

名前            意味
------          ------
replace         ファイルのパーミッションをprmsで置き換える
add             ファイルのパーミッションにprmsで指定されたものを追加する
remove          ファイルのパーミッションからprmsで指定されたものを取り除く
nofollow        ファイルがシンボリックリンクの場合、シンボリックリンクのフォロー先のファイルではなく、シンボリックリンクそのもののパーミッションを変更する

例えば、パーミッションを置き換えつつ、シンボリックリンクそのもののパーミッションを書き換えたい場合は、

~~~cpp
perm_options opts = perm_options::replace | perm_options::nofollow ;
~~~

と書く。

#### rename

~~~c++
void rename(const path& old_p, const path& new_p);
void rename(const path& old_p, const path& new_p, error_code& ec) noexcept;
~~~

ファイルold_pをファイルnew_pにリネームする。


old_pとnew_pが同じ存在するファイルを指す場合、何もしない。

~~~cpp
int main()
{
    using namespace std:filesystem ;

    // 何もしない
    rename("foo", "foo") ;
}
~~~

それ以外の場合、リネームに伴って以下のような挙動も発生する。

もし、リネーム前にnew_pが既存のファイルを指していた場合、リネームに伴ってnew_pは削除される。

~~~cpp
int main()
{
    using namespace std::experimental::filesystem ;

    {
        std::ofstream old_p("old_p"), new_p("new_p") ;

        old_p << "old_p" ;
        new_p << "new_p" ;
    }

    // ファイルold_pの内容は"old_p"
    // ファイルnew_pの内容は"new_p"

    // ファイルold_pをnew_pにリネーム
    // もともとのnew_pは削除される
    rename("old_p", "new_p") ;

    std::ifstream new_p("new_p") ;

    std::string text ;
    new_p >> text ;

    // "old_p"
    std::cout << text ;
}
~~~


もし、new_pが既存の空ディレクトリーを指していた場合、POSIX準拠OSであれば、リネームに伴ってnew_pは削除される。他のOSではエラーになるかもしれない。

~~~cpp
int main()
{
    using namespace std::experimental::filesystem ;

    create_directory("old_p") ;
    create_directory("new_p") ;

    // POSIX準拠環境であればエラーにならないことが保証される
    rename("old_p", "new_p") ;
}
~~~

old_pがシンボリックリンクの場合、フォロー先ではなくシンボリックリンクファイルがリネームされる。

#### resize

~~~c++
void resize_file(const path& p, uintmax_t new_size);
void resize_file(const path& p, uintmax_t new_size, error_code& ec) noexcept;
~~~

ファイルパスpathの指すファイルのファイルサイズをnew_sizeにする。

リサイズはPOSIXのtruncate()で行われたかのように振る舞う。つまり、ファイルを小さくリサイズした場合、余計なデータは捨てられる。ファイルを大きくリサイズした場合、増えたデータはnullバイト(`\0`)でパディングされる。ファイルの最終アクセス日時も更新される。

### 情報取得

#### ファイルタイプの判定

ファイルタイプを表現するfile_type型のenumがあり、そのenum値は以下のようになっている。

名前                意味
------              ------
none                ファイルタイプが決定できないかエラー
not_found           ファイルが発見できなかったことを示す疑似ファイルタイプ
regular             通常のファイル
directory           ディレクトリーファイル
symlink             シンボリックリンクファイル
block               ブロックスペシャルファイル
fifo                FIFOもしくはパイプファイル
socket              ソケットファイル
unknown             ファイルは存在するがファイルタイプは決定できない

この他に、実装依存のファイルタイプが追加されている可能性がある。

ファイルタイプを調べるには、file_statusのメンバー関数typeの戻り値を調べればよい。

以下のプログラムは、カレントディレクトリーに存在するファイルfooがディレクトリーかどうかを調べるコードだ。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    auto s = status("./foo") ;
    bool b = s.type() == file_type::directory ;
}
~~~

また、statusもしくはpathからファイルタイプがディレクトリーであるかどうかを判定できるis_directoryも用意されている。

~~~cpp
int main()
{
    using namespace std::filesystem ;

    bool b1 = is_directory("./foo") ;

    auto s = status("./foo") ;
    bool b2 = is_directory(s) ;
}
~~~

file_statusはファイル情報をキャッシュするので、物理ファイルシステムに変更を加えない状態で、同じファイルに対して何度もファイル情報を取得する場合は、file_statusを使ったほうがよい。

このようなis_xという形式のフリー関数は、いずれも以下の形式を取る。

~~~c++
bool is_x(file_status s) noexcept;
bool is_x(const path& p);
bool is_x(const path& p, error_code& ec) noexcept;
~~~

以下はフリー関数の名前と、どのファイルタイプであるかを判定する表だ。


名前                意味
------              ------
is_regular_file     通常のファイル
is_directory        ディレクトリーファイル
is_symlink          シンボリックリンクファイル
is_block            ブロックスペシャルファイル
is_fifo             FIFOもしくはパイプファイル
is_socket           ソケットファイル


また、単一のファイルタイプを調べるのではない以下のような名前のフリー関数が存在する。


名前                意味
------              ------
is_other            ファイルが存在し、通常のファイルでもディレクトリーでもシンボリックリンクでもないタイプ
is_empty            ファイルがディレクトリーの場合、ディレクトリー下が空であればtrueを返す。<br>ファイルが非ディレクトリーの場合、ファイルサイズが0であればtrueを返す。


#### status

~~~c++
file_status status(const path& p);
file_status status(const path& p, error_code& ec) noexcept;
~~~

ファイルパスpのファイルの情報を格納するfile_statusを返す。

pがシンボリックリンクの場合、フォロー先のファイルのfile_statusを返す。

#### status_known

~~~c++
bool status_known(file_status s) noexcept;
~~~

s.type() != file_type::noneを返す。

#### symlink_status

~~~c++
file_status symlink_status(const path& p);
file_status symlink_status(const path& p, error_code& ec) noexcept;
~~~

statusと同じだが、pがシンボリックリンクの場合、そのシンボリックリンクファイルのstatusを返す。

#### equivalent

~~~c++
bool equivalent(const path& p1, const path& p2);
bool equivalent(const path& p1, const path& p2, error_code& ec) noexcept;
~~~

p1とp2が物理ファイルシステム上、同一のファイルである場合、trueを返す。そうでない場合falseを返す。

#### exists

~~~c++
ool exists(file_status s) noexcept;
bool exists(const path& p);
bool exists(const path& p, error_code& ec) noexcept;
~~~

s, pが指すファイルが存在するのであればtrueを返す。そうでない場合falseを返す。

#### file_size

~~~c++
uintmax_t file_size(const path& p);
uintmax_t file_size(const path& p, error_code& ec) noexcept;
~~~

pの指すファイルのファイルサイズを返す。

ファイルが存在しない場合エラーとなる。ファイルが通常のファイルの場合、ファイルサイズを返す。それ以外の場合、挙動は実装依存となる。

エラー通知をerror_codeで受け取る関数オーバーロードでエラーの時、戻り値はstatic_cast\<uintmax_t\>(-1)となる。

#### hard_link_count

~~~c++
uintmax_t hard_link_count(const path& p);
uintmax_t hard_link_count(const path& p, error_code& ec) noexcept;
~~~

pの指すファイルのハードリンク数を返す。


エラー通知をerror_codeで受け取る関数オーバーロードでエラーの時、戻り値はstatic_cast\<uintmax_t\>(-1)となる。

#### last_write_time

~~~c++
file_time_type last_write_time(const path& p);
file_time_type last_write_time(const path& p, error_code& ec) noexcept;
~~~

pの指すファイルの最終更新日時を返す。

~~~c++
void last_write_time(const path& p, file_time_type new_time);
void last_write_time(const path& p, file_time_type new_time, error_code& ec) noexcept;
~~~

pの指すファイルの最終更新日時をnew_timeにする。

last_write_time(p, new_time)を呼び出した後に、last_write_time(p) == new_timeである保証はない。なぜならば、物理ファイルシステムの実装に起因する時刻の分解能や品質の問題があるからだ。

file_time_typeは、std::chrono_time_pointの特殊化で以下のように定義されている。

~~~c++
namespace std::filesystem {
    using file_time_time = std::chrono::time_point< trivial-clock > ;
}
~~~

trivial-clockとは、クロック(より正確にはTrivialClock)の要件を満たすクロックで、ファイルシステムのタイムスタンプの値を正確に表現できるものとされている。クロックの具体的な型は実装依存なので、完全にポータブルなコードではファイルシステムで時間を扱うのは極めて困難になる。せいぜい現在時刻を設定するとか、差分の時間を設定するぐらいしかできない。

~~~cpp
int main()
{
    using namespace std::experimental::filesystem ;
    using namespace std::chrono ;
    using namespace std::literals ;

    // 最終更新日時を取得
    auto timestamp = last_write_time( "foo" ) ;

    // 時刻を1時間すすめる
    timestamp += 1h ;
    // 更新
    last_write_time( "foo", timestamp ) ;


    // 現在時刻を取得
    auto now = file_time_type::clock::now() ;

    last_write_time( "foo", now ) ;
}
~~~

ただし、多くの実装ではfile_time_typeとして、time_point\<std::chrono::system_clock\>が使われている。file_time_type::clockがsystem_clockであれば、system_clock::to_time_tとsystem_clock::from_time_tによってtime_t型との相互変換ができるために、幾分マシになる。

~~~cpp
// file_time_type::clockがsystem_clockである場合

int main()
{
    using namespace std::experimental::filesystem ;
    using namespace std::chrono ;

    // 最終更新日時を文字列で得る
    auto time_point_value = last_write_time( "foo" ) ;
    time_t time_t_value = system_clock::to_time_t( time_point_value ) ;
    std::cout << ctime( &time_t_value ) << '\n' ;

   
    // 最終更新日時を2017-10-12 19:02:58に設定
    tm struct_tm{} ;
    struct_tm.tm_year = 2017 - 1900 ;
    struct_tm.tm_mon = 9 ;
    struct_tm.tm_mday = 12 ;
    struct_tm.tm_hour = 19 ;
    struct_tm.tm_min = 2 ;
    struct_tm.tm_sec = 58 ;

    time_t timestamp = std::mktime( &struct_tm ) ;
    auto tp = system_clock::from_time_t( timestamp ) ;

    last_write_time( "foo", tp ) ;
}
~~~

あまりマシになっていないように見えるのは、C++では現在\<chrono\>から利用できるC++風のモダンなカレンダーライブラリがないからだ。この問題は将来の規格改定で改善されるだろう。

#### read_symlink

~~~c++
path read_symlink(const path& p);
path read_symlink(const path& p, error_code& ec);
~~~

シンボリックリンクpの解決される先のファイルパスを返す。

pがシンボリックリンクではない場合はエラーになる。

#### space

~~~c++
space_info space(const path& p);
space_info space(const path& p, error_code& ec) noexcept;
~~~ 

ファイルパスpが指す先の容量を取得する。

クラスspace_infoは以下のように定義されている。

~~~c++
struct space_info {
    uintmax_t capacity;
    uintmax_t free;
    uintmax_t available;
};
~~~

この関数は、POSIXのstatvfs関数を呼び出した結果のstruct statvfsのf_blocks, f_bfree, f_bavailメンバーを、それぞれf_frsizeで乗じて、space_infoのメンバーcapacity, free, availableとして返す。値の決定できないメンバーにはstatic_cast\<uintmax_t\>(-1)が代入される。

エラー通知をerror_codeで返す関数オーバーロードがエラーの場合、space_infoのメンバーにはすべてstatic_cast\<uintmax_t\>(-1)が代入される。


space_infoのメンバーの意味をわかりやすく説明すると、以下の表のようになる。

名前            意味
------          ------
capacity        総容量
free            空き容量
available       権限のないユーザーが使える空き容量


