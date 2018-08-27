# Swift & Xcode
SwiftでHelloWorldを書くときの記述

```swift
print("Hello, world!")
```

### swiftをターミナルから実行する方法
ファイル名を main.swift とし、任意のコードを入力

```
print("hello")
```

以下のコマンドを実行し、出力されるpathをメモしておく

```
find /Applications/Xcode.app -name swift | grep /bin/swift
```

実行結果

```
~/bin/swift
```

swiftのpathを.bash_profileに追加する

```
vi ~/.bash_profile
```

以下のコードを記述

```
export PATH="$PATH:さっき調べたpath"
```

.bash_profileの読み込み

```
source vi ~/.bash_profile
```

swiftファイルを実行
```
swift main.swift
```

### 変数について
毎行、コードにセミコロンをつける必要はありません。変数、定数に関しては以下のように定義できます。

- 定数（constant）let
- 変数（variable）var

Swiftは与えられた値によってコンパイラが勝手に型を推測してくれるため、明示的に型を記述しなくてもエラーにはなりません。

```swift
var myVariable = 42
myVariable = 50
let myConstant = 42
```

文字列の中で式展開を行いたい場合は`\()`の中に記述してください。
※式展開とは、文字列の中で変数の値を出力したり、オブジェクトのプロパティーやメソッドへのアクセスを行ったりすることです。

```swift
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples + oranges) pieces of fruit."
```

ダブルクウォーテーションを3つ書くと複数行の文字列が記述できます。

```swift
let quotation = """
I said "I have \(apples) apples."
And then I said "I have \(apples + oranges) pieces of fruit."
"""
```

配列やディクショナリは[]で囲み、間にカンマを入れることで要素を区切ります。配列に関しては各要素にアクセスする際[]にインデックス番号を指定し、ディクショナリは各要素のキーを指定する必要があります。また、最後の要素に対してカンマを使ってもエラーにはなりません。

```swift
var shoppingList = ["catfish", "water", "tulips", "blue paint"]
shoppingList[1] = "bottle of water"

var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
]
occupations["Jayne"] = "Public Relations"
```

要素が空の配列、ディクショナリを定義

```swift
let emptyArray = [String]()
let emptyDictionary = [String: Float]()
```

型の指定をしなかった場合、勝手に型が推測される

```swift
shoppingList = []
occupations = [:]
```

### 制御構文
ifやswitchは条件分岐、for-in, while, repeat-whileは繰り返し処理に使用されます。

#### 条件分岐
条件分岐には、以下の種類があります。

- if
- switch

```swift
let individualScores = [75, 43, 103, 87, 12]
var teamScore = 0
for score in individualScores {
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}

print(teamScore)
```

ifの条件式は必ずBoolean型になるように指定する必要があります。また、型の最後に?を入れることによってoptional型の変数になり、Booleanの判定ができるようになります。

```swift
var optionalString: String? = "Hello"
print(optionalString == nil)

var optionalName: String? = "John Appleseed"
var greeting = "Hello!"
if let name = optionalName {
    greeting = "Hello, \(name)"
}
```

optional型の変数をif文の条件式に使用することもできます。その場合、optional型の変数にnullが入っていれば`false`、指定したデータ型の値が入っていれば`true`という扱いになります。

```swift
// optional型の変数に文字列を代入した場合
var optionalString: String? = "Hello"
print(optionalString == nil)

var optionalName: String? = "John Appleseed"
var greeting = ""

if let name = optionalName {
    greeting = "Hello, \(name)"
} else {
    greeting = "no name"
}

print(greeting)


// optional型の変数にnilを代入した場合
var optionalName2: String? = nil
var greeting2 = ""

if let name2 = optionalName2 {
    greeting2 = "Hello, \(name2)"
} else {
    greeting2 = "no name"
}

print(greeting2)
```

出力結果

```
false
Hello, John Appleseed
no name
```

optional型の変数は`nil`の場合、条件式は`false`になります。そのため、演算子`??`を使用することによって、optional型の変数が`nil`の場合は代わりに他の変数の値を表示することもできます。

```swift
let nickName: String? = nil
let fullName: String = "John Appleseed"
let informalGreeting = "Hi \(nickName ?? fullName)"

print(informalGreeting)
```

出力結果

```
Hi John Appleseed
```

複数のデータを比較するにはcase文を利用します。

```swift
let vegetable = "red pepper"
switch vegetable {
case "celery":
    print("Add some raisins and make ants on a log.")
case "cucumber", "watercress":
    print("That would make a good tea sandwich.")
case let x where x.hasSuffix("pepper"):
    print("Is it a spicy \(x)?")
default:
    print("Everything tastes good in soup.")
}
```

実行結果

```
Is it a spicy red pepper?
vegetable: String = "red pepper"
```

#### 繰り返し処理
繰り返し処理には以下の種類があります。

- for-in
- while
- repeat-while

繰り返し処理に書く条件式が上にあるか下にあるかで実行結果が変わります。その理由は、条件判定するタイミングが異なるためです。

- 条件式が上にある
 - 条件判定をしてから処理実行
- 条件式が下にある
 - 処理実行後に条件判定

```swift
var n = 2
while n < 100 {
    n *= 2
}
print(n)

var m = 2
repeat {
    m *= 2
} while m < 100
print(m)
```

for文の繰り返し範囲を設定する時に..<という書き方もできる
…<で最大値も含めた範囲を指定することができる

```swift
var total = 0
for i in 0..<4 {
    total += i
}
print(total)

```

繰り返し処理として`for-in`を使用した場合、`key`と`value`の組み合わせで処理を行う事ができます。ちなみに、keyとvalueの組み合わせで扱うデータ形式をDictionaryと言います。Dictionaryは複数のデータを格納する事ができますが、要素の並び順は決まっていません。

```swift
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
var food = ""
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
            food = kind
        }
    }
}

print(largest)
print(food)
```

実行結果

```
25
Square
```

### Function & Closure
`function`を宣言するには、先頭に`function`を記述します。`function`は、引数を渡して呼び出す事ができます。引数と戻り値の型を分けるには`->`を使用します。

functionの引数に渡す時にラベルに対して受け渡す値を明記する必要がある

```swift
func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet(person: "Bob", day: "Tuesday")
```
`_(custom argument label)`を書いたり、onをつけたりする方法もある

```swift
func greet(_ person: String, on day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet("John", on: "Wednesday")
```

戻り値として複数の値を返すこともできる
値の指定に関しては、returnの中に書いてある変数名を指定してもいいし、index番号を指定してもいい

```swift
func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0

    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }

    return (min, max, sum)
}
let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
print(statistics.sum)
print(statistics.2)
```

functionをネストすることが出来る
ネストされたfunctionは、親のfunction内で定義された変数を利用することが出来る

```swift
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()
```

functionはネストされたfunctionを戻り値として返すこともできる

```swift
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)
```

functionは他のfunctionを１つの引数として受け取ることが出来る

```swift
func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}
var numbers = [20, 19, 7, 12]
hasAnyMatches(list: numbers, condition: lessThanTen)
```

mapを使用すると戻り値が配列にすることが出来る

```swift
let numbers = [1, 2, 4, 5]
let indexAndNum = numbers.enumerated().map { (index,element) in
return "\(index):\(element)"
}
print(indexAndNum) // [“0:1”, “1:2”, “2:4”, “3:5”]
```

```swift
var numbers = [20, 19, 7, 12]
var num_map = numbers.map({ (number: Int) -> Int in
    let result = 3 * number
    return result
})

print(num_map)
```

実行結果

```
[60, 57, 21, 36]
```

配列の要素を大きい順に並べることもできます。$0, $1は固定された値です。

```swift
var numbers = [20, 19, 7, 12]
let sortedNumbers = numbers.sorted { $0 > $1 }
print(sortedNumbers)
```

実行結果

```
[20, 19, 12, 7]
```

Ruby,PHP,Javaと同様、Swiftもクラスを定義することが出来ます。

```swift
class Shape {
    var numberOfSides = 0
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}
```

インスタンス化するときはクラス名の後ろにカッコをつけます。変数やメソッドにアクセスするときはドットをつけます。

```swift
var shape = Shape()
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()
```

Swiftにはinitializerが用意されていて、その中に書かれている処理はインスタンス生成時に自動で実行される
initializerはinitで定義することが出来る

```swift
class NamedShape {
    var numberOfSides: Int = 0
    var name: String

    init(name: String) {
        self.name = name
    }

    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}
```

クラスを継承するとき、スーパークラスの名前の前に:をつける

```swift
class NamedShape {
    var numberOfSides: Int = 0
    var name: String

    init(name: String) {
        self.name = name
    }

    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

class Square: NamedShape {
    var sideLength: Double

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }

    func area() -> Double {
        return sideLength * sideLength
    }

    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}
let test = Square(sideLength: 5.2, name: "my test square")
print(test.area())
print(test.simpleDescription())
```

スーパークラスのメソッドをオーバーライドするときにはメソッドの前にoverrideを記述します。

```swift
class NamedShape {
    var numberOfSides: Int = 0
    var name: String

    init(name: String) {
        self.name = name
    }

    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

class Square: NamedShape {
    var sideLength: Double

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }

    func area() -> Double {
        return sideLength * sideLength
    }

    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}
let test = Square(sideLength: 5.2, name: "my test square")
print(test.area())
print(test.simpleDescription())
```

classのプロパティーはgetter、setterを持つことが出来ます。特定のプロパティーに値を代入すると、暗黙的にsetのnewValueに値が渡されます。

```swift
class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }

    var perimeter: Double {
        get {
            return 3.0 * sideLength
        }
        set {
            sideLength = newValue / 3.0
        }
    }

    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(triangle.perimeter)
triangle.perimeter = 9.9
print(triangle.sideLength)
```


### オプショナル型と非オプショナル型

オプショナル型：変数にnilの代入を許容するデータ型
非オプショナル型：nilを代入できない

オプショナル型の変数にはデータ型の最後に「?」か「!」をつける
そうすることで、ファイルが存在しなくても安全に処理できる

```swift
var imageView: UIImageView

// ?をつけることでOptional型に
let image:UIImage? = UIImage(named:"my_image")

// Optional Bindingでnilチェック
if let validImage = image {
    imageView = UIImageView(image: validImage)
} else {
    // 画像がなかった場合の処理
}
```



## Xcode
Swiftは変化が激しいので、最新バージョンを使用するためにはXcodeのバージョンも常に最新にする必要があります。

### Xcodeのダウンロード
Xcodeは`Apple Store`からダウンロードするのが最も一般的です。

Xcodeの画面
ツールバー：上部のバー
ナビゲーターエリア：左のツールバー
エディターエリア：中央（コーティング）
デバッグエリア：中央下部（コンソール）
ユーティリティエリア：右（部品の配置など）

ツールバーの右側にあるボタン（Viewボタン）で、下右左に表示を切り替えることができる
デバッグエリアやユーティリティエリアを非表示にしたい場合は、Viewボタンを押すことで隠すこともできる
これにより、コーディングをしやすくすることができる


ナビゲーターエリア

プロジェクトナビゲーター
左のツールバーのフォルダアイコンをクリックするとプロジェクトに関連するファイルが確認できる
プロジェクトに関連するファイルを確認することができる
ファイルをグループ化することができる（右クリック=>グループ化）

 AppDelegate.swift
主に２つの役割を持っている

AppDelegate classを定義。アプリの状態遷移

サーチナビゲーター
文章の検索ができる


Xcodeのクラス
Foundation
FileSystem
File Manager
NSHomeDirectory
