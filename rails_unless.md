# unless
「もし〜じゃなかったら〜をする」という意味の条件分岐です。否定の時に実行したい処理がある場合にunlessを書くとコードが読みやすくなります。

```ruby
logged_in = false

unless logged_in
  puts "ログインしてません"
end

if logged_in
  puts "ログインしました"
end

# 1行で省略してかける
puts "ログインしてません" unless logged_in
```
