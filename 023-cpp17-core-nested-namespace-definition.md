## ネストされた名前空間定義

C++17ではネストされた名前空間の定義を楽に書ける。

ネストされた名前空間とは、A::B::Cのように名前空間の中に名前空間が入っている名前空間のことだ。

~~~cpp
namespace A {
    namespace B {
        namespace C {
        // ...
        }
    }
} 
~~~

C++17では、上記のコードと同じことを以下のように書ける。

~~~cpp
namespace A::B::C {
// ...
}
~~~



機能テストマクロは__cpp_nested_namespace­_definitions, 値は201411。
