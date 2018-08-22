### Rakeタスク
アプリケーションを起動せず、行いたい処理をCUI（コマンドプロンプトやターミナル）から実行できます。CSVデータのインポートなど、サーバーを起動せず任意の処理を実行する際にこの機能がよく利用されます。

## タスクを定義しよう！
今回は、CSVデータをデータベースへ登録するアプリを元に、Rakeタスクの実装について学んでいきましょう。まずは、実装対象となるアプリを立ち上げます。以下のコマンドを入力してください。

```
rails new rake_task_sample
```

僕はデータベースに`PostgreSQL`を使用しているので、以下のコマンドを実行してアプリを立ち上げました。

```
rails new rake_task_sample -d postgresql
```

アプリが作成できたら、アプリのディレクトリに移動しましょう。

```
cd rake_task_sample
```

移動ができたら、アプリに対応するデータベースを作成します。ちなみに、対象となるデータベースが起動してなければデータベースの作成はできないので、以下のコマンドを入力する前に、データベースを起動する事を忘れないようにしてください。自動起動の設定をしている場合は、何もしなくて大丈夫です。

```
bundle exec rake db:create
```

データベースがうまく作成されると、以下のような表示が出ます。（多少違っていてもエラーが出なければ問題ないです）

```
Created database 'rake_task_sample_development'
Created database 'rake_task_sample_test'
```

きちんとアプリができているか心配な方は、`rails s`コマンドを実行し、初期画面が表示されるか確認しておくといいです。

```
rails s
```

さっそく、これからRakeタスクの実装に移ります。Railsでは、デフォルトで設定されているRakeタスクがあります。これらのタスクは、アプリを作成する際自動で作成されます。まずは既存のタスクを確認してみましょう。以下のコマンドをターミナルに入力してください。

```
rake -T
```

そうすると現在のアプリに定義されているタスク一覧が表示されます。自分が定義したタスクを確認したい場合は、`rake -T`コマンドを利用して確認するようにしましょう。

```
rake about                              # List versions of all Rails frameworks and the environment
rake active_storage:install             # Copy over the migration needed to the application
rake app:template                       # Applies the template supplied by LOCATION=(/path/to/template) or URL
rake app:update                         # Update configs and some other initially generated files (or use just update:configs or u...
rake assets:clean[keep]                 # Remove old compiled assets
rake assets:clobber                     # Remove compiled assets
rake assets:environment                 # Load asset compile environment
rake assets:precompile                  # Compile all the assets named in config.assets.precompile
rake cache_digests:dependencies         # Lookup first-level dependencies for TEMPLATE (like messages/show or comments/_comment.html)
rake cache_digests:nested_dependencies  # Lookup nested dependencies for TEMPLATE (like messages/show or comments/_comment.html)
rake db:create                          # Creates the database from DATABASE_URL or config/database.yml for the current RAILS_ENV ...
rake db:drop                            # Drops the database from DATABASE_URL or config/database.yml for the current RAILS_ENV (u...
rake db:environment:set                 # Set the environment value for the database
rake db:fixtures:load                   # Loads fixtures into the current environment's database
rake db:migrate                         # Migrate the database (options: VERSION=x, VERBOSE=false, SCOPE=blog)
rake db:migrate:status                  # Display status of migrations
rake db:rollback                        # Rolls the schema back to the previous version (specify steps w/ STEP=n)
rake db:schema:cache:clear              # Clears a db/schema_cache.yml file
rake db:schema:cache:dump               # Creates a db/schema_cache.yml file
rake db:schema:dump                     # Creates a db/schema.rb file that is portable against any DB supported by Active Record
rake db:schema:load                     # Loads a schema.rb file into the database
rake db:seed                            # Loads the seed data from db/seeds.rb
rake db:setup                           # Creates the database, loads the schema, and initializes with the seed data (use db:reset...
rake db:structure:dump                  # Dumps the database structure to db/structure.sql
rake db:structure:load                  # Recreates the databases from the structure.sql file
rake db:version                         # Retrieves the current schema version number
rake dev:cache                          # Toggle development mode caching on/off
rake initializers                       # Print out all defined initializers in the order they are invoked by Rails
rake log:clear                          # Truncates all/specified *.log files in log/ to zero bytes (specify which logs with LOGS=...
rake middleware                         # Prints out your Rack middleware stack
rake notes                              # Enumerate all annotations (use notes:optimize, :fixme, :todo for focus)
rake notes:custom                       # Enumerate a custom annotation, specify with ANNOTATION=CUSTOM
rake restart                            # Restart app by touching tmp/restart.txt
rake routes                             # Print out all defined routes in match order, with names
rake secret                             # Generate a cryptographically secure secret key (this is typically used to generate a sec...
rake stats                              # Report code statistics (KLOCs, etc) from the application or engine
rake test                               # Runs all tests in test folder except system ones
rake test:db                            # Run tests quickly, but also reset db
rake test:system                        # Run system tests only
rake time:zones[country_or_offset]      # List all time zones, list by two-letter country code (`rails time:zones[US]`), or list b...
rake tmp:clear                          # Clear cache, socket and screenshot files from tmp/ (narrow w/ tmp:cache:clear, tmp:socke...
rake tmp:create                         # Creates tmp directories for cache, sockets, and pids
rake yarn:install                       # Install all JavaScript dependencies as specified via Yarn
```

それではまず、Rakeタスクの処理を記述するファイルを作成します。Rakeタスクのファイルを作成するためには、ターミナルから以下のコマンドを実行します。今回は例なので、実際には入力しなくて大丈夫です。

```
rails g task task_name
```

`task_name`は、自分の好きな名前を指定することができます。どういう処理を実行するタスクなのか一目でわかるような名前をつけてあげると、後々タスク管理が楽になります。

### タスク定義の練習
まずは肩慣らしに、`Hello!!`などの簡単な挨拶を表示するタスクを作成しましょう。タスク名は`greet`にします。

```
rails g task greet
```

成功すると、以下の文が表示されます。

```
create  lib/tasks/greet.rake
```

`rails g task greet`コマンドを実行すると、`lib/tasks`に`greet.rake`という名前のファイルが作成されます。また、作成されたファイルには、自動で以下のようなコードが作成されています。

```ruby
namespace :greet do
end
```

では、作成したタスクファイルに、タスクとして行いたい処理を書いていきましょう。タスクは、基本的に以下のような構成要素になっています。`4. 名前空間`に関しては、後でご説明するので今は気にしなくて大丈夫です。

1. タスクの説明
2. タスクの名前
3. 実行したい処理
4. 名前空間

```ruby
# 名前空間
namespace :greet do
  # タスクの説明 desc => description（説明）
  desc ""
  # task_name => タスクの名前
  task task_name: :environment do
    # 実行したい処理を記述する場所
  end
end
```

descは`description`のことで、日本語でいうと「説明」という意味です。つまり、「どういうタスクを行うのか?」という説明をそこに書くというわけですね。そして、`task_name`がタスクの名前になります。どういう処理を行うタスクなのか分かりやすい名前をつけてあげると、後々タスクが増えた時にも混乱しなくて済みます。

では、`Hello World!!`を表示するだけの簡単なタスクを作成してみましょう。ファイル内の、好きな場所に以下のコードを記述しましょう。

```ruby
namespace :greet do
  desc "Helloを表示するタスク"
  task say_hello: :environment do
    puts "Hello!!"
  end
end
```

定義したタスクがきちんと表示されるか確認してみましょう。

```
rake -T
```

以下のような名前のタスクが存在すれば定義は成功です。

```
rake greet:say_hello                    # Helloを表示するタスク
```

確認ができたら、そのタスクを実行してみましょう。

```
rake greet:say_hello
```

以下のような表示になれば成功です。

```
Hello!!
```

## 名前空間について
簡単なタスクだけなら、ここまでで行ったやり方でも充分管理が可能なのですが、現場では目的が一緒でも名前を区別したいタスクが複数存在するときがあります。例えば、「データベースにCSVデータを登録する」という目的は同じでも、「ユーザーデータを登録するタスク」と「商品データを登録するタスク」を定義する場合です。この場合、いろんな目的を持ったタスクが大量に存在していたらどうなるでしょう？きっと混乱するのではないでしょうか？

そのような場合、それぞれのタスクをグループ分けできると、簡単に管理することができて便利です。そして、そのような実装を実現する時に便利なのが`名前空間（namespace）`なのです。

タスクは、名前空間を利用することで大まかなグループ分けを行い、管理することができます。ではさっそく、`名前空間（namespace）`の使い方をみていきましょう。

```ruby
namespace :namespace_name do

	task task_name1: :environment do
    # 実行したい処理
	end

  task task_name2: :environment do
    # 実行したい処理
  end
end
```
- namespace_name => 任意の名前空間
- task_name1, 2 => 任意のタスク名

この名前空間を利用して、挨拶を行うタスクと、簡単な計算を行うタスクをグループ化します。

```ruby
# greetという名前空間 => 挨拶をするタスクを定義
namespace :greet do

  desc "Goodbyeを表示するタスク"
  task say_goodbye: :environment do
    puts "Goodbye"
  end

  desc "Helloを表示するタスク"
  task say_hello: :environment do
    puts "Hello!!"
  end

end

# cgreet_when_datingという名前空間 => デート時の挨拶をするタスクを定義
namespace :greet_when_dating do

  desc "容姿を褒める"
  task praise_appearance: :environment do
    puts "You are beautiful!!"
  end

  desc "ファッションを褒める"
  task praise_fashion: :environment do
    puts "That's fashionable!!"
  end

end
```

定義したタスクがきちんと表示されるか確認してみましょう。

```
rake -T
```

以下のような表示がされていれば定義成功です。タスク名が`namespace`に紐づいた名前でグループ分けされていることが確認できます。

```
rake greet:say_goodbye                    # Goodbyeを表示するタスク
rake greet:say_hello                      # Helloを表示するタスク
rake greet_when_dating:praise_appearance  # 容姿を褒める
rake greet_when_dating:praise_fashion    # ファッションを褒める
```

確認ができたら、定義したタスクをどれか実行してみましょう。

```
rake greet_when_dating:praise_fashion
```

出力結果

```
That's fashionable!!
```

では、これからCSVデータを登録するタスクを実装していきましょう。まずは、データを格納するためのテーブルを作成する必要があるので、モデルを作成し、マイグレーションファイルを実行します。まずは、以下のコマンドを実行しましょう。

```
rails g model user
```

以下のような表示がされていれば成功です。

```
invoke  active_record
create    db/migrate/20180812021247_create_users.rb
create    app/models/user.rb
invoke    test_unit
create      test/models/user_test.rb
create      test/fixtures/users.yml
```

モデルの作成が完了したら、次にマイグレーションファイルの編集をします。今回は、ユーザーの名前、年齢、住所を格納するテーブルを作成したいので、以下のようにファイルを編集します。

```ruby
class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :user do |t|
      t.string :name
      t.integer :age
      t.string :address
      t.timestamps
    end
  end
end
```

マイグレーションファイルの編集が終わったら、以下のコマンドを実行しましょう

```
bundle exec rake db:migrate
```

無事にテーブルが作成できたら、次にrakeファイルを作成します。名前は`import_csv`にしてください。

```
rails g task import_csv
```

以下のような表示がされれば成功です。

```
      create  lib/tasks/import_csv.rake
```

`rails g task import_csv`を実行すると、`lib/tasks`に`import_csv.rake`が作成されます。デフォルトでは、以下のようなコードが記述されています。

```ruby
namespace :import_csv do
end
```

それでは、いよいよCSVインポートの機能をRakeタスクに記述していきます。`import_csv.rake`に、以下のコードを記述してください。

```ruby
# CSVファイルを扱うために必要
require 'csv'

# 名前空間 => import
namespace :import_csv do
  # タスクの説明
  desc "CSVデータをインポートするタスク"

  # タスク名 => users
  task users: :environment do
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
  end
end
```

記述が終わったら、きちんと定義されているか確認しましょう。

```
rake -T
```

以下のような表示がされれば、タスクはきちんと定義されています

```
rake import_csv:users                     # CSVデータをインポートするタスク
```

次に、データを投入するためのCSVファイルを保管するディレクトリを作成しましょう。`db`ディレクトリの中に`csv`ディレクトリを作成し、その中にCSVファイル`csv_data.csv`を作成します。作成が完了したら、CSVファイルに以下の記述をしてください。ちなみに、CSVとは`Comma Separated Value`の略で、Comma（カンマ）で値を区切ったデータ形式のことを指します。

```
name,age,address
hogehoge1,11,hogehoge1
hogehoge2,22,hogehoge2
hogehoge3,33,hogehoge3
hogehoge4,44,hogehoge4
hogehoge5,55,hogehoge5
```

それでは、Rakeタスクを実行するため、ターミナルに以下のコマンドを入力しましょう。

```
rake import_csv:users
```

これでデータベースへの登録ができれば、実装は完了です。`rails c`でRails環境のコンソールを立ち上げ、以下のコードを入力してデータがきちんと投入されているか確かめてください。

```
rails c
```

ユーザーのデータが存在するかどうかを確かめるため、以下のコマンドを入力しましょう。

```
User.all
```

ユーザーのデータが表示されれば、データはきちんとインポートされています。

```
User Load (0.4ms)  SELECT  "users".* FROM "users" LIMIT $1  [["LIMIT", 11]]
=> #<ActiveRecord::Relation [#<User id: 1, name: "hogehoge1", age: 11, address: "hogehoge1", created_at: "2018-08-12 02:45:05", updated_at: "2018-08-12 02:45:05">, #<User id: 2, name: "hogehoge2", age: 22, address: "hogehoge2", created_at: "2018-08-12 02:45:05", updated_at: "2018-08-12 02:45:05">, #<User id: 3, name: "hogehoge3", age: 33, address: "hogehoge3", created_at: "2018-08-12 02:45:05", updated_at: "2018-08-12 02:45:05">, #<User id: 4, name: "hogehoge4", age: 44, address: "hogehoge4", created_at: "2018-08-12 02:45:05", updated_at: "2018-08-12 02:45:05">, #<User id: 5, name: "hogehoge5", age: 55, address: "hogehoge5", created_at: "2018-08-12 02:45:05", updated_at: "2018-08-12 02:45:05">]>
```

## おまけ

以上で目的は達成できたのですが、インポート処理を行う際のターミナルの出力をわかりやすくために`colorize`というgemを導入しましょう。そうすると、処理結果を色で分けることができてより見やすくなります。以下のコードをGemファイルに追加しましょう。

```
gem 'colorize'
```

gemをインストールします。

```
bundle install
```

その後、出力する文字列に色を変えるためのメソッドを記述していきます。出力する文字を赤に変えたい場合は`"hoge".red`、緑に変えたい場合は`"fuga".green`と記述すればOKです。

```ruby
# CSVファイルを扱うために必要
require 'csv'

# 名前空間 => import
namespace :import_csv do
  # タスクの説明
  desc "CSVデータをインポートするタスク"

  # タスク名 => users
  task users: :environment do
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
    # 文字を赤色で出力
    puts "インポート処理を開始".red
    # インポートができなかった場合の例外処理
    begin
      User.create!(list)
      # 文字を緑色で出力
      puts "インポート完了!!".green
    rescue ActiveModel::UnknownAttributeError => invalid
      # 文字を赤色で出力
      puts "インポートに失敗：UnknownAttributeError".red
    end
  end
end

```

これで`start to create users data`と`raised error`のメッセージが赤に、`completed!!`のメッセージが緑に表示されれば完了です。処理的には何も変わらないのですが、メッセージがちょっとおしゃれに表示されるようになりました。
