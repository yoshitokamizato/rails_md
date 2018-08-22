# CSVデータ登録
開発の現場では大量のデータを取り扱うため、ExcelでCSVデータを作成し、それをデータベースに一気に投入するという方法がよく使用されています。汎用性の高い技術なので、ぜひ自分で実装できるようにしましょう。

まず最初に、CSVデータ登録機能を実装するアプリを作成します。

```
rails new csv_data
```

僕はデータベースに`PostgreSQL`を使用しているので、以下のコマンドを実行してアプリを立ち上げました。

```
rails new csv_data -d postgresql
```

アプリが作成できたら、アプリのディレクトリに移動しましょう。

```
cd csv_data
```

移動ができたら、アプリに対応するデータベースを作成するため、以下のコマンドを実行しましょう。

```
bundel exec rake db:create
```

データを登録するテーブルを作成するため、テーブルに対応する`user`モデルを作成します。

```
rails g model user
```

modelと同時に作成されたマイグレーションファイルを、以下のように編集しましょう。今回は、name,age,addressの３つカラムを作成し、データ投入を行います。そのため、nameをstring、ageをinteger、addressをstringで作成します。

```ruby
class CreateDataTests < ActiveRecord::Migration[5.2]
  def change
    create_table :data_tests do |t|
      t.string :name
      t.integer :age
      t.string :address
      t.timestamps
    end
  end
end
```

マイグレーションファイルを実行し、データベースにテーブルを作成します。

```
bundle exec rake db:migrate
```

`models`の中にある`application_record.rb`に、CSVデータをインポートするためのコードを追記します。

```ruby
# この記述がないとNameError: uninitialized constant DataTest::CSVになる
require 'csv'
```

次に、データ投入のコードを記述するためのmodelを作成します。こちらは、`rails g model `コマンドを実行せず、直接ファイルを作成しましょう。ファイル名は`import_csv.rb`です。

ファイルが作成できたら、以下のコードを記述します。

```ruby
# CSVデータのパスを引数として受け取り、インポート処理を実行
def self.import(path)
   CSV.foreach(path, headers: true) do |row|
     User.create(
       name: row["name"],
       age: row["age"],
       address: row["address"]
     )
   end
end
```

次に、データを投入するためのCSVファイルを保管するための`csv_data`ディレクトリを作成しましょう。そして、その中に`csv_data.csv`という名前のCSVファイルを作成します。作成したCSVファイルには、以下の内容を記述しましょう。

```
name,age,address
hogehoge1,hogehoge1,hogehoge1
hogehoge2,hogehoge2,hogehoge2
hogehoge3,hogehoge3,hogehoge3
hogehoge4,hogehoge4,hogehoge4
hogehoge5,hogehoge5,hogehoge5
```

CSVデータの用意が終わったら、`rails c`コマンドでRails環境のコンソールを立ち上げます。

```
rails c
```

コンソールが立ち上がったら、以下のコマンドを実行しましょう。

```ruby
DataTest.import('db/csv_data/csv_data.csv')
```

エラーが出なければ、処理は完了です。きちんとデータが登録されているか確認しましょう。`rails c`で立ち上げた画面から、以下のコードを実行します。

```
User.all
```

ユーザーのデータが表示されれば、インポートは成功です。

```
User Load (0.4ms)  SELECT  "users".* FROM "users" LIMIT $1  [["LIMIT", 11]]
=> #<ActiveRecord::Relation [#<User id: 1, name: "hogehoge1", age: 11, address: "hogehoge1", created_at: "2018-08-12 02:45:05", updated_at: "2018-08-12 02:45:05">, #<User id: 2, name: "hogehoge2", age: 22, address: "hogehoge2", created_at: "2018-08-12 02:45:05", updated_at: "2018-08-12 02:45:05">, #<User id: 3, name: "hogehoge3", age: 33, address: "hogehoge3", created_at: "2018-08-12 02:45:05", updated_at: "2018-08-12 02:45:05">, #<User id: 4, name: "hogehoge4", age: 44, address: "hogehoge4", created_at: "2018-08-12 02:45:05", updated_at: "2018-08-12 02:45:05">, #<User id: 5, name: "hogehoge5", age: 55, address: "hogehoge5", created_at: "2018-08-12 02:45:05", updated_at: "2018-08-12 02:45:05">]>
```

## もうちょっと改善！
ここまでの内容でも、データベースへのインポート機能は実装できたのですが、もうちょっと改善したコードについても学んでいきましょう。これで実装する際のバリエーションがちょっと増えます。

```ruby
# インポートするファイルのパスを取得
path = File.join Rails.root, "db/csv/csv_data.csv"
# インポートするデータを格納するための配列
list = []
# CSVファイルからインポートするデータを取得し配列に格納
CSV.foreach(path, headers: true) do |row|
  list << {
      name: row["name"],
      age: row["age"],
      address: row["address"]
  }
end
puts "インポート処理を開始"
# インポートができなかった場合の例外処理
begin
  User.create!(list)
  puts "インポート完了!!"
rescue ActiveModel::UnknownAttributeError => invalid
  puts "インポートに失敗：UnknownAttributeError"
end
```
