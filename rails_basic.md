# Webアプリケーションとは

Webアプリケーションの構成

- Rails => アプリの本体
- Database => アプリに関連するデータの管理 => MySQL
- Database soft => Oracle, MySQL, Postgre, SQLite

# リクエストとレスポンス

- ユーザの要求 => リクエスト
- アプリの応答 => レスポンス

処理の順番
リクエスト
ルート：コントローラのアクションを指定
コントローラ
ビュー

```
Railsアプリの構成
ルート
コントローラ
モデル
ビュー
```

アプリ立ち上げの流れ
```
1. rails newコマンド
2. rake db:create（データベースの作成）
3. rails s（サーバを立ち上げ）
```

5系：アプリ立ち上げの流れ
```
1. rails newコマンド
2. rails s（サーバを立ち上げ）
```

アプリの立ち上げ：「profile」を「mysql」オプションで作成。バージョンを4.2.6で作成。
```
rails _4.2.6_ new profile -d mysql
```

アプリの立ち上げ：「profile」を「mysql」オプションで作成。
```
rails new アプリ名 -d mysql
```
```
rails new user-list -d mysql
```

立ち上げたアプリのフォルダの中に移動
``` cd profile
```

初期画面へアクセス
```http://localhost:3000/```

データベースの作成
```bundle exec rake db:create```
 アプリのファイル内にcdコマンドを使用して移動し、データベースを作成する
=> 一回だけやれば良い
```
rake db:create
```
2つ以上アプリが存在する場合はこちらでデータベースを作成する
```
bundle exec rake db:create
```
サーバを立ち上げる
```rails s```

データベースを視覚的に確認できるソフト
```https://sequelpro.com/download#auto-start```

sequelproのユーザ名
```root```

Railsの処理の流れ
```
1. URL（ユーザからリクエスト）

2. ルート
=> 処理を行う場所を指定（コントローラのアクションを指定）

3. コントローラ
=> ルートで指定されたアクションの処理を行い、それに対応するビューを表示させる
=> Rubyのコードを書いて複雑な処理を行う

4. ビュー（目で見て確認できる部分）
=> Webサイトの見た目を構成する部分
=> HTML/CSS/JavaScript/Ruby
```
```
クライアントからURLを通してWebアプリケーションにアクセス=> リクエスト
```
```
Webアプリケーションからユーザへ処理が返されること => レスポンス
```
MVCモデルの理解
```
http://snsn19910803.hatenablog.com/entry/2015/08/17/195322
```

開発の流れ
```
1. ルートを作成
2. コントローラを作成
3. ビューを作成
```

データベースの作成
```
bundle exec rake db:create
```

ルートファイルの場所
```
config/routes.rb
```


ルートの設定
=> topページへ飛んだ時に処理を行うコントローラのアクションをしてい
```
root to: 'user#index' ```

ルートの設定
=> URLを指定された時のルートを設定
```
  #左側がURL　右側がコントローラの名前とアクション
  #index => 情報の一覧表示
  get '/users', to: 'users#index'
  get '/users/new', to: 'users#new'
  get '/users/create', to: 'users#create'
  get '/users/edit', to: 'users#edit'
  get '/users/show', to: 'users#show'
  get '/users/update', to: 'users#update'
  get '/users/delete', to: 'users#destroy' ```
```
 get '/URL' => 'コントローラ名#コントローラのアクション' ```

ルートにはこういう書き方もある
```
  get '/user' => 'user#index' ```


ルートの処理
```
get '/main(url)' => 'main(controller)#main(action)'
```


コントローラとアクション
```
root to: ‘main#main'

#の左側：コントローラの名前
#の右側：アクションの名前
※コントローラ、アクション名は任意
```

コントローラ
```
データベースからデータを取り出す
指定されたアクションに書いている処理が動く
```
```
自動で作成されるわけではなく、必ずターミナルから作成する必要がある
コマンドを打ったときに関連ファイルとともに作成される
```

コントローラの作成（ターミナル）
```rails g controller users```

コントローラの作成にはこういう書き方もある
```rails generate controller users```

コントローラファイルの場所
```
app/controller
```

コントローラにアクションの追加
```
  def index

  end
  def new

  end
  def create

  end
  def show

  end
  def edit

  end
  def update

  end
  def destroy

  end
```
```
  def アクション名

  end
```


コントローラのアクションに対応するビューフォルダ
```
sub（コントローラ名） => views/usersフォルダ
``` ```
index（アクション名）=> index.html.erbファイル ```


ビューファイルの場所
```
app/views
```

ビューファイルの作成（コントローラのアクションに対応する名前）
コマンドで作らなくて良い
```
subフォルダで「New File」
command + s
``` ```
index.html.erb
```
```
ビューファイルの拡張子は必ず「.html.erb」をつける ```
```
erb => embedded ruby
```



HTMLタグでHello Worldを入力
``` <h1>Hello World!!</h1>
```

サーバーを立ち上げる（ターミナル）
```
rails s
```

練習問題
```
usersコントローラのnew, edit, show, create, update, destroy アクションのそれぞれに処理が遷移するルートを追加してください。全部で7つのルートを追加する必要があります。
```
```
usersコントローラにnew, edit, show, create, update, destroy アクションを追加してください
```
```
new, edit, show, create, update, destroy アクションに対応したviewファイルを作成し、それぞれのページで「HelloWorld」が表示されるようにしてください
```

リンクを作成しましょう
```
<%= link_to 'ユーザ一覧', '/users' %>
```

ナビゲーションを作成しましょう
```
一覧表示 index
新規登録 new
登録完了 create
詳細 show
編集 edit
更新完了 update
削除 destroy
```
