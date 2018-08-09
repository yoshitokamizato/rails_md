### 参考
https://qiita.com/fukumone/items/2dd4d2d1ce6ed05928de

### moduleとは
Rubyには、クラスの他に「モジュール」というインスタンス化する能力は無いけど、メソッドを格納できるものがあります。

- クラス
 - インスタンス化能力がある
 - インスタンス変数が定義できる
 - インスタンスメソッドを定義することができる
 - クラスメソッドを定義することができる
 - 単一継承が可能
- モジュール
 - インスタンス化能力がない
 - メソッドが定義できる
 - 定数が定義できる
 - 多重継承が可能

モジュールではクラスと同じように定数やメソッドをまとめたり、クラスに組み込んで多重継承を実現したり、名前空間を提供するなど、いろいろな使い方ができます。


### 定数やメソッドをまとめる

```ruby
module Panda

  def visit_to_Japan
    "Mr.TonTon"
  end

  def panda
    @panda = "panda"
  end
end

class Zoo
  def the_zoo
    "There are lots of animal"
  end
end

class UenoZoo < Zoo
  include Panda
  def monkey
    @monkey = "monkey"
  end

  def elephant
    @elephant = "elephant"
  end

  def lion
    @lion = "lion"
  end

  def self.name
    "Ueno Zoo"
  end

end
```

### 多重継承する
Rubyでは、複数のクラスを継承する多重継承ができません。そのため、`module`を利用して多重継承を行います。

```Ruby
module A
  def a; end
end

module B
  def b; end
end

class C
  include A
  include B
end

obj = C.new
obj.a # モジュールAのメソッドが呼べる
obj.b # モジュールBのメソッドも呼べる
```

### 名前空間を作る
