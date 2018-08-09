## Rubyの変数、定数

[参考](https://docs.ruby-lang.org/ja/latest/doc/spec=2fvariables.html)
https://qiita.com/kansiho/items/f5ab9b6eeb990e6af327
https://qiita.com/hz1_d/items/148ee0c2491d08232ac5
https://qiita.com/mogulla3/items/cd4d6e188c34c6819709

Rubyには以下のような種類の変数、定数があります。また、Rubyの変数、定数は最初の一文字で区別ができます。

- ローカル変数
- インスタンス変数
- クラス変数
- グローバル変数


### ローカル変数
小文字または`_`で始まるのがローカル変数です。変数が宣言されたブロック、メソッド定義、クラス/モジュール定義の終わりまでがローカル変数の有効範囲となります。つまり、ローカル変数は定義された場所でしか使えない変数だということです。

```ruby
class User
 name = "鈴木"
 def user_name
   puts name
 end
end

user = User.new
user.user_name
```

### インスタンス変数
`@`で始まるのがインスタンス変数です。インスタンス変数は特定のオブジェクトに所属する変数で、アクセス（値の代入、取り出し）する場合は、定義したクラス、またはそのクラスを継承したサブクラスから実行可能です。また、初期化されていないインスタンス変数を参照した場合、その値は`nil`となります。


### クラス変数
`@@`で始まるのがクラス変数です。クラス変数は、その名の通りクラスの中で定義され、クラスの得意メソッド、インスタンスメソッドからアクセスが可能になります。

クラス変数は、そのクラスが持つインスタンス変数とは異なる特徴を持っています。

- サブクラスからアクセス可能
- インスタンスメソッドからアクセス可能

クラス変数はスーパークラス、サブクラスで値を共有することができます。

```ruby
class Foo
  @@foo = 1
end
class Bar < Foo
  p @@foo += 1
end
class Baz < Bar
  p @@foo += 1
end
```

モジュールで定義されたクラス変数は、そのモジュールをインクルードしたクラス間でも共有することができます。

```ruby
module Foo
  @@foo = 1
end
class Bar
  include Foo
  p @@foo += 1
end
class Baz
  include Foo
  p @@foo += 1
end
```

サブクラスで定義されているクラス変数を、スーパークラスで定義した場合には、サブクラスのクラス変数が上書きされます。

```ruby
class Foo
end

class Bar < Foo
  @@v = :bar
end

class Foo
  @@v = :foo
end

class Bar
  p @@v
end
```

### グローバル変数
`$`で始まるのがグローバル変数です。この変数は、プログラムのどこからでも参照できるため、予期せぬ値の代入や取り出しが起きる可能性があります。そのため、取り扱いには注意が必要です。また、初期化されていないグローバル変数の値は`nil`となります。
