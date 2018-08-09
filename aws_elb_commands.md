# Elastic Beanstalkで使うコマンドまとめ
この記事では、僕が現場で実際に利用しているElastic Beanstalkでよく利用するコマンドについてまとめていきます。

# Elastic Beanstalkとは
EB（Elastic Beanstalk）とは、アプリケーションを実行するために必要なインフラストラクチャの構築や、アプリケーションのデプロイを簡単に行うことができるAWSのサービスです。EB を使用することによって、アプリケーションをアップロードするだけで自動的に必要な容量を予測、準備し、負荷分散、拡張、アプリケーションのモニタリングといった細かい処理を自動で行ってくれます。

EBで対応できる言語は以下の通りとなります。

- Go
- Java
- PHP
- .NET
- Node.js
- Python
- Ruby

# EBでよく使うコマンド一覧
僕が実際に現場でよく利用するコマンドは以下の通りです。まだそこまで難しい操作はしていません。

## eb list
現在運用しているアプリケーションの一覧を表示することができます。`--all`オプションを指定した場合は、全てのアプリケーションを一覧表示します。

基本コマンド

```
eb list
```

全てのアプリケーションを一覧表示

```
eb list -a
eb list --all
```

インスタンスを含む全ての環境に関するより詳細な情報を表示

```
eb list -v
eb list --verbose
```

## eb use
デフォルトの環境を選択することができます。`eb list`で環境を確認し、`eb use`で使用したい環境を選択するのが基本的な流れです。そのため、`eb use`コマンドの後には、環境名を指定する必要があります。EBにデプロイする際も、`eb use`で環境を選択してから実行します。

基本コマンド

```
eb use environment_name
```

環境を作成するリージョンを変更

```
eb use environment_name -r region_name

eb use environment_name --region region_name
```
- environment_name => 任意の環境名
- region_name => 任意のリージョン名

## eb deploy
`eb use`で選択した環境に、ローカルのアプリケーションをデプロイします。gitがインストールされている場合、`git commit`された最新のアプリケーションから`.zip`ファイルを作成します。

基本コマンド

```
eb deploy
```

環境を指定してデプロイ

```
eb deploy environment_name
```
- environment_name => 任意の環境名


EBで作成するバージョンに使用するラベルを指定

```
eb deploy -l version_label
```
- version_label => 任意のラベル

アプリケーションバージョンの説明を追加

```
eb deploy -m "version_description"

eb deploy --message "version_description"
```
- version_description => アプリケーションバージョンの説明

コマンドがタイムアウトするまでの時間（分）を指定

```
eb deploy --timeout minutes
```
- minutes => 指定したい時間

## eb ssh
Secure Shell (SSH) を利用して、環境内のEC2インスタンスに接続します。環境内で複数のインスタンスが実行されている場合、接続するインスタンスを指定するように求められます。また、`exit`を入力すると接続を解除することができます。

基本コマンド

```
eb ssh

eb environment_name
```
- environment_name => 接続したい環境

コマンド実行後のインスタンス選択画面

```
Select an instance to ssh into
1) i-hogehogehogehoge1
2) i-hogehogehogehoge2
(default is 1): 1

...

Are you sure you want to continue connecting (yes/no)? yes

```

接続の解除

```
exit
```

接続するインスタンスをIDで指定

```
eb ssh -i

eb ssh --instance
```

接続するインスタンスを数値で指定

```
eb ssh -n

eb ssh --number
```



# その他のコマンド一覧

## eb abort
インスタンスの環境を更新している場合、その更新をキャンセルします。更新が進行中の環境が3つ以上ある場合は、変更をロールバックする環境名を選択する必要があります。

```
eb abort

eb abort environment_name
```

## eb appversion
Elastic Beanstalk アプリケーションのバージョンを管理します。アプリケーションバージョンの削除やアプリケーションバージョンライフサイクルポリシーの作成ができます。`--delete`オプションを使用してアプリケーションのバージョンを削除します。`lifecycle`オプションを利用してアプリケーションバージョンライフサイクルポリシーを表示または作成します。

コマンド

```
eb appversion
```
