#JSON

## 導入
JSONとは、 `JavaScript Object Notation.` の略です。JSONは、サーバーとJavaScript間でのデータのやり取りをする際に使用されます。

JavaScriptのオブジェクトをJSONに変換する方法は以下の通りです。

```js
var myObj = {"name":"John", "age":31, "city":"New York"};
var myJSON = JSON.stringify(myObj);
window.location = "demo_json.php?x=" + myJSON;
```

JSONをJavaScriptオブジェクトに変換する方法は以下の通りです。

```js
var myJSON = '{"name":"John", "age":31, "city":"New York"}';
var myObj = JSON.parse(myJSON);
document.getElementById("demo").innerHTML = myObj.name;
```

## JSONの文法
JSONのデータ形式は`name`と`value`の組合せでできています。

```js
"name":"Yoshi"
```

JSONでは`key`の部分を`String`にする必要があります。そのため、コードを書く際は必ずダブルクウォーテーションで`key`を囲みます。

```js
// JSON
{ "name":"John" }
```

```js
{ name:"John" }
```

以下のようにしてデータを上書きすることができます。

```js
var myObj, x;
myObj = {"name":"John", "age":30, "city":"New York"};
myObj.name = "Gilbert";
document.getElementById("demo").innerHTML = myObj.name + myObj.age + myObj.city;
```
