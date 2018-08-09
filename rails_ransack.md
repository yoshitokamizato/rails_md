### ransack
Ransackはシンプルで高機能な検索フォームを実装するためのgemです。ModelやControllerなどで検索に関して複雑な処理を書く必要がなくなります。

Ransackを実装するには以下のgemを追加してください。

```ruby
gem 'ransack'
```

最新バージョンを取得したい場合は、以下のコードを書いてください。

```ruby
gem 'ransack', github: 'activerecord-hackery/ransack'
```

追加したGemをインストールしましょう。
```
bundle install
```


`user`と`comment`のモデルにリレーションを追加します。`user`と`comment`は1対多の関係となります。

```ruby
# user　model
has_many :comments
```
```ruby
# comment model
belongs_to :user
```

userモデルからcommentを検索する場合

```ruby
attr_accessor :comment
def execute
	User.ransack(comments_eq: @comment)
end
```

検索したいデータをmodelオブジェクトを生成する際に渡してあげる

```ruby
# データ検索ができる。commentにデータがない場合はall検索となる
@user = User.new(comment: params[:comment])
@user.execute
```

|

|Predicate|Description|Notes|
|---------|-----------|-----|
|*_eq|equal|-|
|*_not_eq|not equal|-|
|*_matches|	matches with LIKE|	e.g. q[email_matches]=%@gmail.com|
|*_does_not_match|	does not match with LIKE|-|
|*_matches_any|	Matches any|-|
*_matches_all	Matches all
*_does_not_match_any	Does not match any
*_does_not_match_all	Does not match all
*_lt	less than
*_lteq	less than or equal
*_gt	greater than
*_gteq	greater than or equal
*_present	not null and not empty	Only compatible with string columns. Example: q[name_present]=1 (SQL: col is not null AND col != '')
*_blank	is null or empty.	(SQL: col is null OR col = '')
*_null	is null
*_not_null	is not null
*_in	match any values in array	e.g. q[name_in][]=Alice&q[name_in][]=Bob
*_not_in	match none of values in array
*_lt_any	Less than any	SQL: col < value1 OR col < value2
*_lteq_any	Less than or equal to any
*_gt_any	Greater than any
*_gteq_any	Greater than or equal to any
*_matches_any	*_does_not_match_any	same as above but with LIKE
*_lt_all	Less than all	SQL: col < value1 AND col < value2
*_lteq_all	Less than or equal to all
*_gt_all	Greater than all
*_gteq_all	Greater than or equal to all
*_matches_all	Matches all	same as above but with LIKE
*_does_not_match_all	Does not match all
*_not_eq_all	none of values in a set
*_start	Starts with	SQL: col LIKE 'value%'
*_not_start	Does not start with
*_start_any	Starts with any of
*_start_all	Starts with all of
*_not_start_any	Does not start with any of
*_not_start_all	Does not start with all of
*_end	Ends with	SQL: col LIKE '%value'
*_not_end	Does not end with
*_end_any	Ends with any of
*_end_all	Ends with all of
*_not_end_any		
*_not_end_all		
*_cont	Contains value	uses LIKE
*_cont_any	Contains any of
*_cont_all	Contains all of
*_not_cont	Does not contain
*_not_cont_any	Does not contain any of
*_not_cont_all	Does not contain all of
*_true	is true
*_false	is false
