### helper method


#### collection_select
```
<!-- key: dbに渡される値、name: プルダウンに表示される値 -->
<%= f.collection_select :name, @users, :key, :name %>
```

第二引数にはモデルオブジェクトの配列を渡せばいいのでこう書くこともできる
```
<%= f.collection_select :name, User.all, :key, :name %>
```
