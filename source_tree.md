
SourceTreeをダウンロード

インストーラーに従ってインストール

1. インストール開始
2. ATLASSIANアカウント作成
3. メール認証
4. ATLASSIANアカウント初期設定
5. Github 既存のアカウントでログイン（ない場合は新規登録）
6. SSHキーの設定
7. GithubにSSHキーを登録
8. 接続アカウントをクリック

sshキーを生成

```
ssh-keygen -t rsa
```

sshエージェントに鍵を保存

```
ssh-add ~/.ssh/id_rsa
```

クリップボードにコピー

```
pbcopy < ~/.ssh/id_rsa.pub
```


Githubにsshキーを登録
setting
SSH and GPG keys
Add SSH Key

# インストール完了後
新規
ローカルリポジトリを作成
保存先のパスからRailsプロジェクトを選択
作成をクリック
ダブルクリック
最初のコミットを実行
"first commit"というメッセージを入力して`コミット`を実行
Githubでリモートリポジトリを作成
Start a project
`Repository name` にアプリの名前を入力

## SourceTreeでリモートリポジトリを関連づける
設定
リモート
追加
リモートの名前を入力
URLを入力
OK二回
ブランチを表示
masterを右クリック
プッシュ先を選択
OK:認証をミスったら`git remote set-url origin SSHでの接続URL`

## リポジトリを共有
Settings
Collaborators
招待する人を検索
