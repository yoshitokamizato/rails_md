
## Ruby on Railsとは
Rubyを利用して効率よくWebサイトを開発できるようにしてくれるものです。

## インストールの流れ

1. Command Line Tools
2. Homebrew
3. rbenv(アールベンブ), ruby-build(ルビー・ビルド)
4. readline
5. MySQL
6. bundler
7. Ruby on Rails


### MySQLとは
データベース管理ソフトでフリーで扱えます。データベース管理ソフトの中でも圧倒的なシェアを誇るのはOracleですが、それは有料なのでMySQLやPostgreSQLなどのフリーソフトを利用することが多いです。どのデータベース管理ソフトでもSQL文でデータを取り扱うのは一緒なので、覚えておくと様々なデータベース管理ソフトに応用が利きます。


## Xcodeのインストール
まずはAppStoreにてXcodeのインストールを行いましょう。

## Commandlinetoolのインストール
次に、[AppleのDevelopperサイト](https://developer.apple.com/download/more/)から`Command LineTool`をインストールします。

1. チェックボックスにチェックしてsubmit
2. download tools
3. see more downloads

左上の検索窓で`command`と入力して検索し、自分のOSのバージョンにあった`Command LineTool`をインストールしましょう。

## Homebrewのインストール
Homebrewのインストールをします。ここからはターミナルでコマンドを入力していきましょう。

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

途中で`enter`を求められるので`enterキー`を押し、その後、Macのパスワードを入力しましょう。


homebrewがきちんとインストールできたかバージョンを確認します。

```
brew -v
```

homebrewのアップデート

```
brew update
```

## 権限の変更
`/usr/local/bin`フォルダの権限を変更します。

```
sudo chown -R `whoami`:admin /usr/local/bin
```

## rbenv(アールベンブ), ruby-build(ルビー・ビルド)のインストール
次に、rbenv(アールベンブ), ruby-build(ルビー・ビルド)をインストールしましょう。ruby-buildはRubyの様々なバージョン(2.4.1など)をインストールすることができるツールで、rbenvは、rubyのバージョンを切り替えるためのツールです。

インストールはHomebrewを使用して行います。以下のコマンドを実行しましょう。

```
brew install rbenv ruby-build
```

rbenvのパスを通す

```
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
```

bash_profileの変更内容を読み込む

```
source ~/.bash_profile
```

## readlineのinstall
readlineはCUIでの操作を簡単にするためのツールです。

```
brew install readline
```

readlineのパスを通す

```
brew link readline --force
```

## Ruby【ver.2.5.1：最新安定板】のインストール
readlineとrbenvを利用して`Ruby ver.2.5.1`のインストールを行います。

```
RUBY_CONFIGURE_OPTS="--with-readline-dir=$(brew --prefix readline)”
```
```
rbenv install 2.5.1
```

インストールが完了したらリハッシュします。

```
rbenv rehash
```

rbenvを用いて利用するRubyのバージョンを決めます。

```
rbenv global 2.5.1
```

Rubyのバージョンを確認し、インストールが成功しているか確かめましょう。

```
ruby -v
```

## MySQLのインストール
Homebrewを利用してMySQLのインストールを行います。

```
brew install mysql56 mysql
```

MySQLはデフォルトの状態では自動で起動しないようになっています。毎回、起動コマンドを打つのは大変なので、自動で起動するように設定しましょう。以下のコマンドを順に入力してください。

```
mkdir ~/Library/LaunchAgents
```
```
ln -sfv /usr/local/opt/mysql\@5.6/*.plist ~/Library/LaunchAgents
```
```
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql\@5.6.plist
```


## bundlerのインストール
次に、Rubyのgemであるbundlerをインストールします。

```
gem install bundler
```

## Ruby on Railsのインストール
次にRubyのgemでありフレームワークでもある`Ruby on Rails`をインストールします。

```
gem install rails
```

gemをインストールしたのでrehashを行います。

```
rbenv rehash
```

インストールがうまくいったかどうか確かめるため、以下のコマンドを入力してRailsのバージョンを確認しましょう。きちんとバージョンが表示されればインストールは成功です。

```
rails -v
```

## 注意!!
Xcodeのインストールが完了していないのに `gem install rails` を実行するとインストールがうまくいきません。エラーが出た場合は、Xcodeがきちんとインストールされていること、最新版にアップデートされていることを確認しましょう。
