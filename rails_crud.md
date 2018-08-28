【投稿機能を実装】

データベースの作成

```
be rake db:create
```

ルートを編集

```
get '/new'  =>  'main#new' 
```

コントローラを作成

```
rails g controller main
```

new.html.erb（投稿フォーム）の編集

```
<%= form_for @user, url: user_path , html: { method: :post } do |f| %>
  <p>投稿する</p>
  <% f.text_field :name %>
  <% f.text_field :age %>
  <input type="submit" value="送信">
<% end %>
```

データの受け渡しをする「モデル」を作成する（ターミナル）

``` 
rails g model user
```

マイグレーションファイルの4〜5行目を編集（ファイルの場所：db/migrate）

```
t.string        :name
t.integer       :age
t.timestamps
```

マイグレーションファイルは中身を変更するだけではダメです。以下のコマンドを実行し、マイグレーションファイルの内容をデータベースに反映させましょう。

``` 
rake db:migrate
```

[マイグレーションファイルの型指定](http://railsdoc.com/migration)

そうすると、アプリに紐づいたデータベースの中に、`users`テーブルが作成されているのが確認できるようになります。データベースの中身を確認する際は、以下のツールを活用しましょう。

# データベースの確認
MySQlで作成したデータベースを視覚的に確認できるソフトは`SequelPro`です。以下のURLからダウンロードしましょう。

[sequelpro](https://sequelpro.com/download#auto-start)

sequelproのユーザ名

```
root
```

該当するデータベースを選択肢、そのデータベースに存在するテーブルを選択すると内容が確認できます。`crud_sample_development`という名前のデータベースに`users`テーブルが作成されていることを確認しましょう。また、`users`テーブルの中に`name`、`age`のカラムがあることを確認しましょう。

データベースが作成できたら、次にデータベースにデータを登録するための処理を実装していきます。

``` 
post  '/create'  =>  'users#create'
```

コントローラにcreateアクションを追加→入力したデータをモデルに保存する処理を書く

``` 
def create
  User.create(name: params[:name], age: params[:age])
end
```

# 一覧表示機能の実装
投稿一覧へのルートを作成

```ruby
get '/index' => 'users#index' 
```

投稿したデータをデータベースから取り出す

```ruby
def index
  @users = User.all
end
```

投稿一覧を表示（show.html.erb）

```   
<% @users.each do |user| %>
  <%= user.name %><%= user.age %>
<% end %>
```

投稿ページに移動できるリンクを作る（show.html.erb）

```       
<div class="comment-menu">
  <div class="new-btn">
    <%= link_to '投稿する', '/new'%>
  </div>
</div> 
```

```
.new-btn {
  color: black;
  width: 200px;
  height: 50px;
  line-height: 50px;
  border-radius: 10px;
  margin: 30px auto;
  border: solid 2px #00CED1;
  text-align: center;
  transition: 0.5s;
}

.new-btn a{
  color: #00CED1;
}

.new-btn:hover{
    background: #00CED1;
}

.new-btn:hover a{
    display: block;
    color: white;
} 
```

削除ボタンを押した時のルートを決める
```
  delete '/delete/:id' => 'main#delete'
```

メソッドの使い分け
```
get => ページ遷移
post => 投稿
delete => 削除
```


該当する投稿をデータベースから取り出し削除する処理をコントローラに書く
ついでに、一覧ページにリダイレクトようにする
```
  def delete
    talk = Talk.find(params[:id])
    talk.destroy
    redirect_to :action => "show"
  end 
```


削除機能の一連の流れ
```

1.Talkテーブルのデータ

@talk = Talk.all.order("creted_at DESC")


2.削除ボタン（show.html.erb）


見たまんまのコード

  <% @talk.each do |data| %>
    <div class="comment">
      <%= simple_format(data.text) %>
      <div class="comment-btn">
        <%= link_to 'コメントを削除', "/delete/#{data.id}", method: :delete %>
      </div>
    </div>
  <% end %>

dataの中身
data = {:id => 1, :text => "こんにちは"}


裏側

  <% @talk.each do |data| %>
    <div class="comment">
      <%= simple_format(data.text) %>
      <div class="comment-btn">
        <%= link_to 'コメントを削除', "/delete/1", method: :delete %>
      </div>
    </div>
  <% end %>



3.route.rb

見たまんま

delete '/delete/:id' => 'main#delete'

裏側

delete '/delete/1' => 'main#delete'


paramsの中身
params = {:id => 1, :text => "こんにちは"}


3.コントローラ

見たまんま

  def delete
    talk = Talk.find(params[:id])
    talk.destroy
    redirect_to :action => "show"
  end

裏側

  def delete
    talk = Talk.find(1)
    talk.destroy
    redirect_to :action => "show"
  end
 ```

RailsでPryを使う
```
group :development, :test do
gem 'pry-rails'
gem 'pry-byebug'
gem 'pry-doc'
end
```
Gemfileを編集したら必ず「bundle install」を実行
```
bundle install ```

bundle install をすると binding.pry を利用できるようになる
```
binding.pry ```


ページネーションを作成するためのGemをGemfileに追加
=> kaminari
```
gem 'kaminari' ```

追加したGemをインストール
```
bundle install ```

1ページごとに表示する投稿数を決定
```
  def show
    @talk = Talk.all.order("created_at DESC").page(params[:page]).per(5)
  end
```

ページネーションを表示させる場所を決める
```
<div class="paginate">
  <%= paginate(@talk) %>
</div> ```
```
.paginate {
  text-align: center;
} ```

【ログイン機能の実装】

ログイン機能を追加するためのGemをGemfileに追加
=> devise
```
gem 'devise' ```

追加したGemをインストール
```
bundle install ```
aliasを設定している場合
```
bi
```

deviseの設定ファイルを作成
```
rails g devise:install ```

ログイン機能で使用するモデルを作成する場合は「rails g model ~」ではなく「rails g devise ~」を使用する
今回は「devise」コマンドを使用してログイン機能の実装に必要な「user」モデルを作成する
```
rails g devise user
```

user モデルを作成するとマイグレーションファイルが作成されるので、マイグレーとしてその内容をデータベースに反映させる必要がある
```
rake db:migrate
```
```
sequel pro で確認 ```

ログイン・ログアウトボタンを編集
```

      <% if user_signed_in? %>
          <div class="comment-menu">
            <div class="logout-btn">
              <%= link_to "ログアウト", destroy_user_session_path, method: :delete %>
            </div>
          </div>
          <div class="comment-menu">
            <div class="new-btn">
              <%= link_to '投稿する', '/new'%>
            </div>
          </div>
      <% else %>
          <div class="comment-menu">
            <div class="new-btn">
              <%= link_to "ログイン", new_user_session_path, class: 'post' %>
            </div>
            <div class="new-btn">
              <%= link_to "新規登録", new_user_registration_path, class: 'post' %>
            </div>
          </div>
      <% end %> ```

ログインしていなかったら「show.html.erb」にリダイレクトするようにする
```
  before_action :move_to_show, except: :show ```
```
  def move_to_show
    redirect_to action: :show unless user_signed_in?
  end ```





devise用のビューファイルを作成
=> デフォルトだとログイン・新規登録時のビューがない
```
rails g devise:views
 ```
```
views フォルダに devise が追加されていることを確認 ```

ニックネームを追加できるように users テーブルに nickname カラムを作成する
```
rails g migration AddNicknameToUsers nickname:string ```
```
rake db:migrate
```

ニックネームを追加するためのフォームを作成する(app/views/devise/registrations/new.html.erb) 5行目に挿入
```
      <div class="field">
        <%= f.label :nickname %> <em>(6 characters maximum)</em><br />
        <%= f.text_field :nickname, autofocus: true, maxlength: "6" %>
      </div> ```

sign_upアクションに対してnicknameというキーのパラメーターを追加で許可する(app/controllers/application_controller)
```
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end
```

Talksテーブルにuser_idのカラムを追加する
```
rails g migration AddUserIdToTalks user_id:integer ```
```
rake db:migrate ```


投稿時のデータにuser_idも一緒に登録するようにする
```
  def create
    Talk.create(text: params[:text], user_id: current_user.id)
    redirect_to :action => "show"
  end ```
```
投稿後、 sequel pro でデータを確認 ```

セキュリティーを強化する
```
  def create
    Talk.create(text: talk_params[:text], user_id: current_user.id)
    redirect_to :action => "show"
  end ```
```
  private
  def talk_params
    params.permit(:text)
  end

  def move_to_show
    redirect_to action: :show unless user_signed_in?
  end ```{

【新規ログインでニックネームを追加できるようにする】

deviseのインストール（bundle install）
rails g devise:install
rails g devise user
rake db:migrate
rails g devise:views
rails g migration AddNicknameToUser nickname:string
rake db:migrate

新規登録時にニックネームを追加できるようにする
app/views/devise/registrations/new.html.erbを編集
```
      <div class="field">
        <%= f.label :nickname %> <em>(6 characters maximum)</em><br />
        <%= f.text_field :nickname, autofocus: true, maxlength: "6" %>
      </div> ```

以下のコードを追加し、ニックネームをuserテーブルに追加されるようにする
app/controllers/application_controller
```
    before_action :configure_permitted_parameters, if: :devise_controller?

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
    end ```

tweetテーブルにuser_idカラムを追加する
```
rails g migration AddUserIdToTweets user_id:integer ```
```
rake db:migrate ```

createアクションを書き換えてuser_idを登録できるようにする
=>投稿機能を実装したコントローラへ
```
  def create
    Tweet.create(name: tweet_params[:name], image: tweet_params[:image], text: tweet_params[:text], user_id: current_user.id)
  end ```


マイページへのルーティング
```
get   'users/:id'   =>  'users#show' ```
```
:idとすることでparamsというハッシュにユーザのidを登録できる ```

usersコントローラを作成する
```
rails g controller users ```

usersコントローラに「マイページで表示するデータ」を取得するためのアクションを書く
```
  def show
    @nickname = current_user.nickname
    @tweets = Tweet.where(user_id: current_user.id).page(params[:page]).per(5).order("created_at DESC")
  end ```

show.html.erbにログインユーザが投稿した内容だけを表示する
```
<p><%= @nickname %></p>
<% @tweets.each do |tweet| %>
  <p><%= tweet.text %></p>
<% end %>
<p><%= paginate(@tweets) %></p> ```

application.html.erbにマイページへのリンクを作る
```
  <% if user_signed_in? %>
    <%= current_user.nickname %>
    <a href="/users/<%= current_user.id %>">マイページへ</a>
    <%= link_to "ログアウト", destroy_user_session_path, method: :delete %>
    <%= link_to "投稿する", '/tweets/new' %>
  <% else %>
    <%= link_to "ログイン", new_user_session_path, class: 'post' %>
    <%= link_to "新規登録", new_user_registration_path, class: 'post' %>
  <% end %> ```


アソシエーションを設定する
app/models/user.rbを編集
```
has_many :tweets ```
app/models/tweet.rbを編集
```
belongs_to :user ```

アソシエーションを利用してログインユーザの投稿データを取得
app/controllers/users_controller
```
  def show
    @nickname = current_user.nickname
    @tweets = current_user.tweets.page(params[:page]).per(5).order("created_at DESC")
  end ```

投稿者名を表示する
app/views/tweets/index.html.erb
```
<% @tweet.each do |data| %>
  <div class="comment">
    <p><%= simple_format(data.text) %></p>
    <p>投稿者</p>
    <%= data.user.nickname %>
  </div>
<% end %>
<%= paginate(@tweet) %> ```

スタイルはこうやると見やすい
```
.comment {
  border: solid 1px;
  width: 300px;
  margin: 10px;
  padding: 10px;
} ```

indexアクションにincludeメソッドを使用し、n+1問題を解決
app/controllers/tweets_controller.rb
```
    def index
      @tweets = Tweet.includes(:user).page(params[:page]).per(5).order("created_at DESC")
    end ```

nicknameのinputを消す
app/views/tweets/new.html.erb
```
<%= form_tag('/tweets', method: :post) do %>
  <h3>
    投稿する
  </h3>
  <textarea cols="30" name="text" placeholder="text" rows="10"></textarea>
  <input type="submit" value="SENT">
<% end %> ```

nameカラムにデータを保存する処理を消す
```
  def create
    Tweet.create(image: tweet_params[:image], text: tweet_params[:text], user_id: current_user.id)
  end

  private
  def tweet_params
    params.permit(:image, :text)
  end ```

Tweetsモデルからnameのカラムを消す
ターミナル
```
rails g migration RemoveNameFromTweets name:string ```
```
rake db:migrate ```

削除ボタンを作る
index.html.erb
```
    <%= link_to '削除', "/tweets/#{data.id}", method: :delete %> ```

tweetを削除するためルーティングを決める
```
  delete '/tweets/:id' => 'tweets#destroy'
```

コントローラに削除のアクションを作成する
tweets_controller.rb
```
  def destroy
    tweet = Tweet.find(params[:id])
    if tweet.user_id == current_user.id
      tweet.destroy
    end
  end ```

tweetsにdestroy.html.erbのビューファイルを作る
```
<p>削除しました</p>
<%= link_to "投稿一覧へ", '/' %> ```

destroyアクションにツイート一覧へのリダイレクトを追加する
```
redirect_to acotion: :index ```

編集機能を実装

編集ボタンを作る
```
    <%= link_to '編集', "/tweets/#{data.id}/edit", method: :get %> ```


ルーティングを設定
```
  get '/tweets/:id/edit' => 'tweets#edit' ```

編集処理を書く
```
 def edit
    @tweet = Tweet.find(params[:id])
 end ```

ビューファイルを作る
edit.html.erb
```
<div class="comment">
  <%= form_tag("/tweets/#{@tweet.id}", method: :patch) do %>
    <h3>
      更新
    </h3>
    <textarea cols="30" name="text" placeholder="" rows="10"><%= @tweet.text %></textarea>
    <input type="submit" value="SENT">
  <% end %>
</div> ```

編集完了画面へのルーティング
```
patch '/tweets/:id' => 'tweets#update' ```

データを更新するアクションを追加
```
  def update
    tweet = Tweet.find(params[:id])
    if tweet.user_id == current_user.id
      tweet.update(tweet_params)
    end
  end ```


ツイートの詳細画面を作成する

詳細画面へのリンクを作成
```
    <%= link_to "詳細", "/tweets/#{data.id}", method: :get %> ```

詳細画面へのルートを作成
```
get 'tweets/:id' => 'tweets#show' ```

tweetsコントローラにshowアクションを定義する
```
  def show
    @tweet = Tweet.find(params[:id])
  end ```

詳細画面のビューファイルを作成する
```
<% if user_signed_in? && current_user.id %>
<%= link_to "編集", "/tweets/#{@tweet.id}/edit", method: :get %>
<%= link_to "削除", "/tweet/#{@tweet.id}", method: :delete %>
<% end %>
<%= simple_format(@tweet.text) %>
<a href="/users/<%= @tweet.user.id %>">投稿者　<%= @tweet.user.nickname %></a> ```

commentテーブルを作る
```
rails g model comment ```

マイグレーションファイルを編集し、マイグレーション実行時に必要なカラムが作成されるようにする
```
      t.integer :user_id
      t.integer :tweet_id
      t.text :text
      t.timestamps ```

マイグレーションファイルを実行
```
be rake db:migrate ```
```
bundle exec rake db:migrate ```


アソシエーションを定義する
app/model/comment.rb
```
belongs_to :tweet
belongs_to :user ```

app/model/tweet.rb
```
has_many :comments ```

app/model/user.rb
```
has_many :comments ```

rootを書き換える
=>resourcesを使用するとかなりシンプルになる

```
  devise_for :users
  root 'tweets#index'
  resources :tweets do
    resources :comments, only: [:create]
  end
  resources :users, only: [:show] 
```

書き換える前
```
  devise_for :users
  root 'tweets#index'
  get '/tweets' => 'tweets#index'
  get '/tweets/new' => 'tweets#new'
  get '/tweets/:id/edit' => 'tweets#edit'
  post '/tweets' => 'tweets#create'
  delete '/tweets/:id' => 'tweets#destroy'
  patch '/tweets/:id' => 'tweets#update'
  get '/tweets/:id' => 'tweets#show'
  get '/users/:id' => 'users#show' 
```

ルーティングを確認
```
rake routes 
```
```
                    root GET    /                                    tweets#index
          tweet_comments POST   /tweets/:tweet_id/comments(.:format) comments#create
                  tweets GET    /tweets(.:format)                    tweets#index
                         POST   /tweets(.:format)                    tweets#create
               new_tweet GET    /tweets/new(.:format)                tweets#new
              edit_tweet GET    /tweets/:id/edit(.:format)           tweets#edit
                   tweet GET    /tweets/:id(.:format)                tweets#show
                         PATCH  /tweets/:id(.:format)                tweets#update
                         PUT    /tweets/:id(.:format)                tweets#update
                         DELETE /tweets/:id(.:format)                tweets#destroy
                    user GET    /users/:id(.:format)                 users#show ```

投稿フォームを作る
tweets/show.html.erb
```
    <% if current_user %>
      <%= form_tag("/tweets/#{@tweet.id}/comments", method: :post) do %>
        <textarea cols="30" name="text" placeholder="コメントする" rows="2"></textarea>
        <input type="submit" value="SENT">
      <% end %>
    <% end %> 
```

commentsコントローラを作る
```
rails g controller comments
```
```
rails g controller comments create ```

commentsコントローラのcreateアクションを定義
```
  def create
    Comment.create(text: params[:text], tweet_id: params[:tweet_id], user_id: current_user.id)
  end ```
