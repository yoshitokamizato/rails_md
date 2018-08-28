# Elastic Beanstalkとは
アプリケーションのインフラ周りの設定を自動でやってくれるAWSが提供するサービスです。Webアプリを公開するには、Webサーバ、アプリケーションサーバ、DBサーバを作成し、それらのサービスを連携させる必要があります。また、ロードバランサ(ELB)でリクエストを分散させたり、サーバーを監視(CloudWatch)したり、Auto Scalingによってアプリケーションの負荷を分散させるための仕組みも考えなければいけません。Elastic Beanstalkは、そうしたインフラ周りの設定を自動でやってくれる便利なサービスだというわけです。

# 手順
これから、`Elastic Beanstalk`を使用してRailsアプリをデプロイするための手順を書いて行きます。

## IAMユーザーの作成
Elastic Beanstalkを使うには、IAMユーザーを作成する必要があります。AWSマネジメントコンソールから、IAMをクリックし、ユーザーを追加してください。アクセスの種類は、プログラムによるアクセスと、AWS マネジメントコンソールへのアクセスにもチェックしておきます。

グループ名は`test-deploy`とつけます。こちらは、自分の設定したい名前で大丈夫です。なんのアプリ化がわかりやすいような名前をつけるといいでしょう。ポリシーフィルターはAWSElasticBeanstalkFullAccessにします。

ユーザーの作成を行うと`Access Key ID`や`Secret Access Key`が表示されます。この情報はとても大切なのできちんと保管しておいてください。外部に漏れた場合はすぐにユーザーを削除しましょう。

## aws cliのインストール
ebコマンドを使えるようにするため、`homebrew`を利用して`awsebcli`をインストールします。

```
brew install awsebcli
```

インストールが終了したら、以下のコマンドを実行し、インストールが成功しているか確かめてください。

```
eb --version
```

以下のような表示がされていれば、インストールは完了です。

```
EB CLI 3.2.2 (Python 3.4.3)
```

## `Access Key ID`や`Secret Access Key`の設定
作成したIAMユーザーで操作するためにAccess Key IDとSecret Access Keyの設定を行います。
`aws configure`と打つと、対話形式で聞いてくるのでIAMユーザー作成の際に表示されたAccess Key IDとSecret Access Keyを入力します。Default region nameはap-northeast-1、Default output formatはjsonあたりを指定しておけば良いかと思います。

```
$ aws configure
AWS Access Key ID [None]: *********
AWS Secret Access Key [None]: **********************
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

設定した値は以下のコマンドで確認できます。

```
$ cat ~/.aws/config
$ cat ~/.aws/credentials
```

## Elastic Beanstalkのセットアップ
eb initコマンドで初期化します。対象となるリポジトリで作業して下さい。こちらも対話形式で聞いてきますので、以下に私の場合の例を載せます。#以下はコメントになります。

```
$ eb init
```

```
Select a default region
1) us-east-1 : US East (N. Virginia)
.....

Enter Application Name
(default is "sample-app"): sample-app　# デフォルトはリポジトリ名になると思われる

It appears you are using Ruby. Is this correct?
(y/n): y

Select a platform version.
1) Ruby 2.3 (Puma)
・・・(中略)
8) Ruby 2.0 (Passenger Standalone)
9) Ruby 1.9.3
(default is 1): 1 # バージョンは各アプリで違うと思うのでお好みで。
Do you want to set up SSH for your instances?
(y/n): y
```

```
Select a keypair.
1) my_account
2) [ Create new KeyPair ]
(default is 2): 1
```

 # すでにあるkeypairを使う場合はそれを選択。keypairがない場合や新たなkeypairを使用する場合は、[ Create new KeyPair ]の番号を選ぶ。
設定はcat .elasticbeanstalk/config.ymlで確認できます。
$ cat .elasticbeanstalk/config.yml
このあたりで、.gitignoreにElastic Beanstalk用のファイルは無視する設定が追加されるかと思います。リポジトリの.gitignoreで管理したい場合は、commitしておきましょう。
git add .gitignore
git commit -m "add elastic beanstalk files to .gitignore"
これで初期化が終わりました。
アプリケーションの環境の作成
これまでの作業でマネジメントコンソールからElastic Benastalkの管理画面に行くと、以下のような形になっているかと思います。 eb-init.png
今すぐ作成しましょう。と書いてあるので作成しましょう。
eb createで作成します。こちらも対話形式で設定が可能です。
まず触ってみるだけならば、defaultのままで大丈夫かと思います。タイプしなくてもEnterで可能です。

```
$ eb create
```

Enter Environment Name
(default is sample-app-dev): sample-app-dev
Enter DNS CNAME prefix
(default is sample-app): sample-app # eb openコマンドで見れるときのURL。http://sample-app.ap-northeast-1.elasticbeanstalk.com/などとなる。

Select a load balancer type
1) classic
2) application
(default is 1): 1
しばらく時間がかかるので、みかんでも食べて(冬場の場合)しばしお待ちください。コマンドラインにあるように(safe to Ctrl+C)なのでCtrl+Cしても大丈夫です。経過はマネジメントコンソールから確認できます。
RDSの作成
しばらく待っていると、おそらく失敗すると思います。こういう場合は基本中の基本、ログを見ます。

```
error.png
```

eb logsコマンドでログが見れます。eb logsコマンドを実行すると/var/log/nginx/error.logなど、複数のログが表示されます。今回のログはElastic Beanstalkに関するログなので、/var/log/eb-activity.logのとこ ろを見ます。

```
$ eb logs
```

# lessで表示される。

```
-------------------------------------
/var/log/eb-activity.log
-------------------------------------
```

```
  ++ /opt/elasticbeanstalk/bin/get-config container -k app_user
  + EB_APP_USER=webapp
  ・・・(中略)
  + su -s /bin/bash -c 'leader_only bundle exec rake db:migrate' webapp
  rake aborted!
  PG::ConnectionBad: could not connect to server: No such file or directory
        Is the server running locally and accepting
        connections on Unix domain socket "/var/run/postgresql/.s.PGSQL.5432"?
```

db:migrateができないよと言っているわけです。この辺りは、Railsのconfig/database.ymlにどのように書かれているかにもよるのですが、defaultでlocalhostが指定されていてそれをproductionにも`<<: *default`のまま指定してあったりすると当然Elastic Beanstalkで作成されたEC2上にはデータベースサーバはありませんので、接続できないというわけです。

RDSを作成すると、エンドポイントなどが表示されると思います。また、マネジメントコンソールのRDSからも作成されているのが確認できるかと思います。そこでもエンドポイントやポートなどを確認できるかと思います。
RDSへの接続は、AWSのDocumentにもあるように、config/database.ymlに設定しておかなければいけません。
```
default: &default
  adapter: postgresql
  encoding: unicode
・・・(中略)
production:
  <<: *default
  database: <%= ENV['RDS_DB_NAME'] %>
  username: <%= ENV['RDS_USERNAME'] %>
  password: <%= ENV['RDS_PASSWORD'] %>
  host: <%= ENV['RDS_HOSTNAME'] %>
  port: <%= ENV['RDS_PORT'] %>
```



## 環境変数の設定
環境変数の設定は、eb setenvコマンドで行います。

```
eb setenv RDS_DB_NAME=ebdb RDS_USERNAME=hogehoge RDS_PASSWORD=hogehoge RDS_HOSTNAME=hogehoge.rds.amazonaws.com RDS_PORT=hogehoge
```

設定する項目

- AWS_ACCESS_KEY_ID
- AWS_REGION
- AWS_SECRET_ACCESS_KEY
- BUNDLE_WITHOUT
- RACK_ENV
- RAILS_SKIP_ASSET_COMPILATION
- RAILS_SKIP_MIGRATIONS
- RDS_DB_NAME
- RDS_HOSTNAME
- RDS_PASSWORD
- RDS_PORT
- RDS_USERNAME
- SECRET_KEY_BASE


設定されている環境変数は、eb printenvコマンドで確認できます。

```
$ eb printenv
```

 Environment Variables:
     RDS_PORT = ****
     SECRET_KEY_BASE = ***************
     RAILS_SKIP_ASSET_COMPILATION = false
     RDS_DB_NAME = ebdb
     RACK_ENV = production
     RDS_PASSWD = *************
     RDS_USERNAME = *******
     BUNDLE_WITHOUT = test:development
     RAILS_SKIP_MIGRATIONS = false
     RDS_HOSTNAME = ************rds.amazonaws.com
デプロイ
この状態でもう一度デプロイして見ます。今回は２回目なのでeb deployコマンドを使います。
eb deploy
しばらく待ちます。
これで、正しくdeployが行われれば、eb openでサイトが見れるはずです。
eb open
うまくできない場合は、eb logsでエラーを確認してGoogle先生等に聞いてエラーを解消してあげてください。
以上で、初期セットアップは終わりです。以下は開発上のTips的な記述ですので、必要に応じて参考にしていただければと思います。
Tips
Application Versionが規定数を超えていてデプロイできない場合
ERROR: You cannot have more than 500 Application Versions. Either remove some Application Versions or request a limit increase.
AWSコンソールから作業することもできますが、CLIで行う場合、eb appversionコマンドの--deleteオプションで削除できますが、version-label（VersionLabel）を知らなければいけません。
aws elasticbeanstalk describe-application-versions --application-name your-application-name
上記コマンドを実行すると以下のようなJSONが得られます。（値は適当なものを入れています）
    [
        {
            "ApplicationName": "your-application-name",
            "Status": "UNPROCESSED",
            "VersionLabel": "app-000f-191111_112017",
            "Description": "hogefuga",
            "DateCreated": "2017-03-27T07:20:16.892Z",
            "DateUpdated": "2017-03-27T07:20:16.892Z",
            "SourceBundle": {
                "S3Bucket": "elasticbeanstalk-ap-northeast-1-100000000001",
                "S3Key": "your-application-name/app-000f-191111_112017.zip"
            }
        }
    ]
上記JSONのVersionLabelを指定して削除します。古いのが一番下に出てくるので、古いのから削除していけばいいでしょう。
eb appversion --delete app-000f-191111_112017
yarnを利用する場合
yarnをinstallするためのコマンドを.ebextensionsディレクトリ配下に置きます。
webpackerのissueにconfigファイルを掲示してくれている方がいるので参考にしてください。
私の場合、deploy時に、yarnコマンドでトランスパイルを実行させています。
トランスパイル実行後にassets:precompileを走らせているので、RAILS_SKIP_ASSET_COMPILATIONの環境変数はtrueにしてassets:precompileを実行させないようにし、.ebextensions内で実行しています。
.ebextensions/10_yarn.config
# see https://gist.github.com/yuyasat/dcc2f2214f5087833aca2069e69f92fb
.ebextensions/11_container_commands.config
container_commands:
  11-npm_install_build:
    command: cd frontend && sudo yarn install && sudo yarn release
  23-assets_precompile:
    command: bundle exec rake assets:precompile
https接続する場合
流れとしては、
ドメインの取得
証明書の発行（AWS Cetrificate Manager（ACM）、Let's encryptなどを利用する）
証明書のLoadBalancerやEC2への紐付け
Clasic Load Balancerの場合
.ebextensions/loadbalancer-terminatehttps.configが参考になります。
Application Load Balancer の設定の場合
.ebextensions/alb-secure-listener.configが参考になります。こちらの記事も大変参考になりました。
ネットワークロードバランサー の設定の場合
.ebextensions/nlb-secure-listener.configが参考になります。ただし、NLBの場合、SSLの終端がEC2になります。2018/4/6現在、ACMはEC2に適応できないため、ほかの方法を利用する必要があります。
ACMでサブドメインのあり・なし共に利用できるワイルドカード証明書を作成する場合は、「ドメイン名の追加」において、*.hogehoge.comとhogehoge.comの二つを入力する必要があります。こちらが詳しいです。
httpをhttpsへリダイレクトする場合、ELBで80番ポートで受け取り、EC2（nginx）に81番ポートにフォワードし、nginx側で81番ポートにきた場合は、httpsにリダイレクトをする処理をかけるのがシンプルです。この手法は、Clasic Load BalancerとApplication Load Balancerで利用できます。
81番ポートの手法を使わなくてもGistに載せたように、/etc/nginx/conf.d/webapp_healthd.confをカスタマイズしても良さそうです。いろんなところでよく見るnginxのconfです。最終的に私のElasticBeanstalkの01_nginx.confと02_load-balancer.configはGistに載せたような形になりました。
EC2のタイムゾーンを変更する場合
初期はUTCになっています。
$ date
2018年  5月 23日 水曜日 01:22:22 UTC
.ebextensionsの中にJSTに変える処理を追加します。
.ebextensions/01_timezone.config
commands:
  timezone-change:
    command: sed -i -e "s/UTC/Japan/g" /etc/sysconfig/clock
    ignoreErrors: false
  localtime-change:
    command: ln -sf /usr/share/zoneinfo/Japan /etc/localtime
    ignoreErrors: false
gitコマンドを入れる
例えばGemfileにgem 'elasticsearch-rails', github: 'elastic/elasticsearch-rails', branch: '6.x'のようにgitコマンドがないとbundle installができない場合、入れる必要があります。
.ebextensionsの中に以下のような設定を行います。
.ebextensions/00_packages.config
packages:
  yum:
    git: []
cronでrails runnerやrakeタスクを動かす
cronでrails runnerやrakeタスクを実行したい場合、Elastic BeanstalkのWorker tierを用いれば良いのですが、そこまでするほどではない（orなるべく安く済ませたい）とき、.ebextensionsの中にcronの設定をしてあげる必要があります。
そのとき、単純にcd /var/app/current && rake -vTなどと書いたのでは動きません。Rails用の環境変数などが読み込まれていないからです。（参考）
環境変数を読み込む
/var/app/currentにディレクトリを移動する
bundleコマンドやrailsコマンドをフルパスで指定して実行する
コマンドが少し長くなってしまうので、下記ではAWSのドキュメントにならい、シェルスクリプトを実行させる形にしてあります。
.ebextensions/12_cronjob.config
files:
    "/etc/cron.d/mycron":
        mode: "000644"
        owner: root
        group: root
        content: |
            */2 * * * * root /usr/local/bin/my_rails_runner.sh

    "/usr/local/bin/my_rails_runner.sh":
        mode: "000755"
        owner: root
        group: root
        content: |
            #!/bin/bash

            . /opt/elasticbeanstalk/support/envvars
            cd /var/app/current

            # rails runnerの場合
            # 使っているrubyのversionに合わせる。eb sshして確認すること。
            /opt/rubies/ruby-2.5.0/bin/bundle exec /opt/rubies/ruby-2.5.0/bin/rails runner "puts MyModel.count" >> /var/log/cron-error.log 2>&1

            # rakeタスクの場合
            # /opt/rubies/ruby-2.5.0/bin/bundle exec /opt/rubies/ruby-2.5.0/bin/rake -vT >> /var/log/cron-error.log 2>&1

            exit 0

commands:
    remove_old_cron:
        command: "rm -f /etc/cron.d/*.bak"
はまりポイント
アプリケーションを起動させるのに環境変数を正しく設定する必要がある場合があります。しかし、eb setenvコマンドをつかっても、画面の設定->ソフトウェアの変更から変更してもエラーになって反映されない・・・！
私のケースの場合、ヘルスチェックに合格しなくてもデプロイに失敗しない。にチェックが入っており、アプリケーション側でエラーになってヘルスチェックが通らず、設定も反映されない状態でした。
ローリング更新とデプロイの変更->ヘルスチェックを無視にチェックを入れてヘルスチェックが通らない場合でも無視するように変更する。
初期構築の際、トライアンドエラーを繰り返すことがあるかと思います。その時に、実行終了までに時間がかかってしまうことがあります。こういう場合は、ローリング更新とデプロイの変更->コマンドタイムアウトの値を減らすことも一つの方法です。デフォルトでは600（10分）になっていると思いますが、初期構築時には300（5分）にしても大きな問題とならないでしょう。
デバッグの方法
sshしてEC2インスタンス内でlogを見ると捗ります。個人的によく使うのは以下のようなコマンドです。
$ tail -f -n500 /var/log/eb-activity.log # eb-activity.logを監視
$ tail -f -n500 /var/log/puma/puma.log # puma.logを監視
$ top # プロセスやCPU使用率などを確認
$ ps aux | sort -n -k 3 | tail -n10 # 具体的なプロセスを確認。-nで数値で並び替え、-kで3列目（CPU%）で並び替え対象列。
よく使うコマンド
環境名（以下、environment-name)一覧を取得したい時
eb list
eb list --profile default # profile名を指定する場合
# profile名は、cat ~/.aws/credentialsで確認できます。
deployする時（ブランチにデフォルトの環境名を設定することもできますが、環境名を指定してdeployすることの方が多いです）
eb deploy environment-name # envorinment-nameは個々の環境名
eb deploy environment-name --profile default # profile名を指定する場合
セットされている環境変数を知る時
eb printenv environment-name
環境変数をセットする時
eb setenv PGHOST=xxxxxxxxx -e envorinment-name
EC2にsshする時

```
eb ssh envorinment-name
cd /var/app/current/ # Rails.rootへ。
bin/rails console # Rails consoleを起動。
```

上記コマンドで`log/*.log`にアクセス権限がないと言われてしまう場合chmodで権限を変更するか、rootユーザーになって行う。

```
sudo su
bin/rails console
```
