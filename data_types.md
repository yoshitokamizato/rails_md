# データ型とは
Rubyには、以下のようなデータ型が存在ます。

|データ型|オブジェクト名|
|整数|Fixnum|
|少数|Float|
|文字列|String|
|配列|Array|
|連想配列|Hash|
|true|TrueClass|
|false|FalseClass|
|nil(存在なし)|NilClass|


それぞれのデータ型に対応するオブジェクトは、以下のコードで確認することができます。

```ruby
puts <<~TEXT

整数 #{1.class}
少数 #{1.0.class}
文字列 #{"文字列".class}
配列 #{[1, 2, 3].class}
連想配列 #{{"key" => "value"}.class}
true #{true.class}
false #{false.class}
nil（存在なし）#{nil.class}

TEXT
```

出力結果

```
整数 Fixnum
少数 Float
文字列 String
配列 Array
連想配列 Hash
true TrueClass
false FalseClass
nil（存在なし）NilClass
```
