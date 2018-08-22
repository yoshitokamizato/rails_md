## ransackとは
ransackはrails用の検索機能を実装するためのgemです。このgemを利用することにより、高機能なキーワード検索を実装できるようになります。例えば、検索キーワードが入力された場合には、そのキーワードに紐づいたデータを取得し、検索キーワードが入力されていない場合には全件検索を行う、といった柔軟な検索機能が実装できるようになります。

以下のgemを追加

```ruby
gem 'ransack'
```

```
bundle install
```

データを登録するためのデータベースを作成します。まずは、modelを作成しましょう。modelの名前はuserにしてください。

```
rails g model user
```

作成されたマイグレーションファイルを以下のように編集しましょう。

```ruby
class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :user do |t|
      t.string :name
      t.integer :age
      t.timestamps
    end
  end
end
```

マイグレーションファイルを編集したらマイグレートを実行し、テーブルを作成しましょう。

```
bundle exec rake db:migrate
```

次に、検索用のデータを投入します。今回は、`seed`の機能を利用してサンプルデータを作成します。以下のコードを`db/seeds.rb`に記入しましょう。

```
User.create(name: '斉藤', age: 35)
User.create(name: '田中', age: 21)
User.create(name: '佐藤', age: 32)
User.create(name: '山岸', age: 33)
User.create(name: '平', age: 26)
User.create(name: '加藤', age: 25)
```

`seeds.rb`に用意したデータをUsersテーブルへ投入します。以下のコマンドを実行しましょう。

```
bundle exec rake db:seed
```

データを投入したら、検索メソッドを実装するためのモデルを作成しましょう。今回作成するモデルのファイル名は`user_search.rb`です。`user_search.rb`ファイルの作成が終わったら、そのファイルに`UserSearch`クラスを定義し、`UserSearch`クラスに検索用の`execute`メソッドを定義しましょう。その際、`search_name`と`search_age`のインスタンス変数を定義します。その`execute`メソッドの中で、`ransack`の機能を利用します。

※`user`モデルに検索用のメソッドを実装する場合、インスタンス変数の名前がテーブルのカラム名と同じ値になると、データが登録できない状態になるので注意が必要です

```ruby
class UserSearch
  include ActiveModel::Model

  attr_accessor :search_name, :search_age

  def execute
    User.ransack(name_eq: @search_name, age_eq: @search_age).result
  end
end
```

モデルの編集が終わったら、次にルートを設定しましょう。`routes.rb`に以下のコードを追記してください。

```ruby
get '/users/search', to: 'users#search'
```

ルートの設定が終わったら、`users`コントローラに対応するアクションを記述します。そのため、まずは`users`コントローラを作成しましょう。以下のコマンドを実行してください。

```
rails g controller users
```

`users`コントローラが作成できたら、`search`アクションを追加しましょう。検索フォームから送信された`params`は`params_user_search`メソッドから受け取るようにします。

```ruby
def search
    user_search = UserSearch.new(params_user_search)
    @users = user_search.execute
end

private

def params_user_search
  params.permit(:search_name, :search_age)
end

```

`users`コントローラのアクションが定義できたら、次は画面の作成に移ります。検索機能を実装するには、検索ワードを入力するための画面が必要なので、次に、検索用の入力画面を作成しましょう。`users`ディレクトリに`search.html.erb`を作成し、以下のコードを記述しましょう。

```
<%= form_tag('/users/search', method: :get) do %>
  <%= label_tag :名前 %>
  <%= text_field_tag :search_name %>
  <%= label_tag :年齢 %>
  <%= text_field_tag :search_age %>
  <%= submit_tag '検索' %>
<% end %>
<table>
  <tbody>
    <thead>
      <tr>
        <th>名前</th>
        <th>年齢</th>
      </tr>
    </thead>
    <% @users.each do |user| %>
      <tr>
        <td><%= user.name %></td>
        <td><%= user.age %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

それでは、検索画面にアクセスし、動作確認をしましょう。サーバーを立ち上げた後、[http://localhost:3000/users/search](http://localhost:3000/users/search)にアクセスし、検索ワードを入力し、検索ボタンを押してみて下さい。

以上で検索機能の実装は終わりです。きちんとユーザーが検索できるか確かめて見ましょう。
