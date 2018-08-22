# Active Admin
`Active Admin`とは、管理者画面を簡単に作成するためのGemです。これを利用することにより、データの作成、更新、削除を管理者画面から簡単に実行できるようになります。そのため、ユーザーに見せる画面と、管理者用の画面を使い分けることができ、プログラミングができない人でもデータの更新が可能なWebサイトを構築することができます。

まずはじめに、Active Adminを実装するアプリを作成します。

```
rails new active_admin_sample
```

僕はデータベースに`PostgreSQL`を使用しているので、以下のコマンドを実行してアプリを立ち上げました。

```
rails new active_admin_sample -d postgresql
```

アプリが作成できたら、アプリのディレクトリに移動しましょう。

```
cd active_admin_sample
```

移動ができたら、アプリに対応するデータベースを作成するため、以下のコマンドを実行しましょう。また、データベースを作成する際はデータベースソフト（MySQLやPostgreSQL）が起動していないとエラーになるので注意が必要です。必ず起動してからコマンドを実行するようにしましょう。

```
bundle exec rake db:create
```

データを登録するテーブルを作成するため、テーブルに対応する`user`モデルを作成します。

```
rails g model user
```

model作成と同時にマイグレーションファイルも作成されるので、そのファイルを以下のように編集しましょう。今回は、`name,age,address`の３つカラムを作成します。そのため、`name`のデータ型を`string`、`age`のデータ型を`integer`、`address`のデータ型を`string`に設定します。

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

Active Adminは、ログイン用のgemである`devise`と組み合わせて使用する必要があります。`activeadmin`と`devise`の2つのgemをGemfileに追記しましょう。

```ruby
gem 'activeadmin'
gem 'devise'
```

gemをインストールします。

```
bundle install
```

gemのインストールが完了したら、Active Adminに必要なファイルをインストールします。

```
rails generate active_admin:install
```

マイグレートを実行します。

```
rake db:migrate
```

初期ユーザデータを作成するためシードファイルを実行します。

```
rake db:seed
```

※simple form を使用しているとエラーが出る：その場合は次のコマンドで解決

```
rails generate simple_form:install
```

サーバを起動します。

```
rails s
```

以下のURLにアクセスします。

[http://localhost:3000/admin](http://localhost:3000/admin)

以下のユーザでアクセスします。

```
User: admin@example.com
Password: password
```

Active Adminでは、`rails generate active_admin:resource model_name`というコマンドを実行することにより、`model_name`に対応した管理画面を作成することができます。今回は、`user`モデルに対する管理画面を作成したいので、以下のコマンドを実行しましょう。

```
rails generate active_admin:resource user
```

コマンド実行後、Userが管理画面に追加されていることを確認します。


## 管理画面の日本語化
`locals`の中にある`application.rb`に`config.i18n.default_locale = :ja`を記述すると、管理画面を日本語にすることができます。ただし、各モデルのラベルは日本語化されません。その方法については、後述します。

```ruby
require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module ActiveAdminSample
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    # 以下の表記で管理画面を日本語化することができる
    config.i18n.default_locale = :ja
  end
end
```

## ラベルの日本語化
管理画面のラベルは、デフォルトでは英語になっています。それを日本語化するため、`config/locals`に`ja.yml`を追加し、必要に応じて設定したいラベルの日本語を追記しましょう。

```yml
ja:
 activerecord:
    models:
      user: ユーザー
    attributes:
      user:
        name: 名前
        age: 年齢
```

また、`rails-i18n`というgemを追加すると日付の部分も日本語にしてくれます。ちなみに、`rails-i18n`に書かれてある`i18n`とは`internationalization`の略で、国際化・多言語化を意味します。

```
gem 'rails-i18n'
```

```
bundle install
```

## 日本語化（必要な場合のみ）
locales直下にja.ymlを置く場合この記述は必要ありません。

```ruby
config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
```


## ログイン機能を追加（Devise）
作成した`user`モデルをログイン機能に利用したい場合、以下のコマンドを実行します。

```
rails g devise User
```

そうすると`migration`ファイルが作成されるので、以下のコマンドを実行します。

```
be rake db:migrate
```

Active Adminの管理画面で`Users`にログイン機能に関連するラベルが追加されていることを確認しましょう。
