# VPCの領域を作る（手順）
まず、AWSマネジメントコンソールのホーム画面にある`サービス` から`VPC` を選択します。

VPCを選択したら、次は対象となる`リージョン` を選択します。（日本だとアジアパシフィックです）

リージョンを選択したら、`VPCダッシュボード` から　`VPC` メニューをクリックします。

VPCメニューが開くと`VPCの作成` ボタンがあるので、それをクリックします。

名前タグには、作成するVPC領域につける名前を入力します。ここでは、`VPC` とつけておきます。

CIDRは使用するIPアドレス範囲で、今回は`20.0.0.0/16` と入力します。その後、`作成` をクリックし、VPC領域を作成します。

# AWSでのサーバー構築に関する基礎知識
AWSでのサーバー構築についてもっと良く知りたいと思ったのですが、調べていくと理解しておかなければいけない基礎知識が結構たくさんあったのでまとめてみました。これからAWSを触り始める初心者の方向けの内容となっています。

# IPアドレスとは
`IPアドレス（Internet Protocol Address）`とは、インターネット上に接続された機器が持つ番号のことです。データをやりとりする際、対象となる相手に確実に届けるためにこのIPアドレスが利用されます。

## ネットワーク部とホスト部
IPアドレスは`ネットワーク部`と`ホスト部`に分かれています。そして、ネットワーク部とホスト部は、以下の方法で区別されています。

- クラスによる分類（クラスフルアドレス）
- サブネットマスクによる分類（クラスレスアドレス）

### クラスによる分類（クラスフルアドレス）
クラスフルアドレスでは、クラスA~Cにおいて以下のようにネットワーク部とホスト部が区別されています。

```
N => ネットワーク部
H => ホスト部

クラスA : NNN.HHH.HHH.HHH
クラスB : NNN.NNN.HHH.HHH
クラスC : NNN.NNN.NNN.HHH
```

### サブネットマスクによる分類（クラスレスアドレス）
クラスレスアドレスの場合、IPアドレスのネットワーク部とホスト部の境界が定まっていません。なので、サブネットマスクを使用し、32ビットあるIPアドレスのうち、ネットワーク部とホスト部がどこからどこまでの範囲なのかを示す必要があります。このサブネットマスクによって柔軟に範囲を変えることで、アドレス空間の無駄使いを防ぐことができます。また、サブネットマスクはIPアドレスと同様に32ビットの整数値で表現され、ネットワーク部を表す部分のビットが1になり、ホスト部を表す部分のビットが0になります。

例えば、先頭25ビットをネットワーク部に、残り7ビットをホスト部に割り当てたい場合は以下のようになります。

```
11111111.11111111.11111111.10000000
```

# CIDRとは
`CIDR（サイダー：Classless Inter-Domain Routing）`は、クラスを使わないIPアドレスの割り当てを行う技術です。`ネットワーク部とホスト部`での説明の通り、クラスはIPアドレスのネットワーク部とホスト部を決められたブロック単位で区切ります。この考え方はとてもシンプルなのですが、それだとアドレス空間の利用に無駄が生じてしまいます。これに対してクラスを使わないCIDRでは、任意のブロック単位で区切ることができるため、IPアドレス空間を効率的に利用することができます。

# VPCとは
`VPC（Virtual Private Cloud）`は、AWSにおけるユーザー専用のプライベートな領域のことです。このVPCを構築する事でサブネット単位、ホスト単位での柔軟なアクセス制御ができます。

## VPCが必要な理由
AWSではネットワーク構成を考えなくてもサーバを立ち上げることができるわけですが、それだとセキュリティー的にかなり弱いです。このアクセス制御を行うために、VPCが必要になります。

# VPCをサブネットに分割
VPCを作成することでプライベートなネットワーク空間が出来上がるのですが、この空間は他のユーザーからは見ることができません。そのため、VPC領域が持っているCIDR（サイダー）ブロックを、さらに`パブリックサブネット`と`プライベートサブネット`に分けます。これによって、ユーザーがアクセスできる空間とそうでない空間を分けることができるのです。

## パブリックサブネットとは
インターネットからアクセスすることを目的として用意するサブネットです。この領域にWebサーバーを設置してインターネットから外部の人がアクセスできるようにします。

## プライベートサブネットとは
インターネットから隔離したサブネットです。この領域に、データベースサーバーを設置します。

# インターネットゲートウェイ
Amazon VPCにおいて、サブネットをインターネットに接続するには`インターネットゲートウェイ`を用います。これにより、自分のネットワーク領域にインターネットワーク回線を引き込むことができます。

# ルーティング情報
ネットワークに情報を流すためには、` ルートテーブル（Routing Table）`と呼ばれるルーティング情報を設定する必要があります。この設定により宛先のIPアドレスを区別し、`送信されたデータ（パケット）`をどのネットワークに転送するかを決めることができます。

## パケットとは？
ここで、`パケット`というワードが出てきたのでご説明します。インターネットで使われる`TCP/IPプロトコル`において、細切れにされたデータを`パケット`と呼びます。

パケットは、`ヘッダー情報`と`データの実体`を含んでいます。そのヘッダー情報の中に、宛先IPアドレスが存在するというわけです。

## ルートテーブルの設定
ルートテーブルの設定は、

宛先アドレス  データを転送するネットワークのルーター

という形で行います。`宛先アドレス`は、一般的にディスティネーションと呼ばれ、`データを転送するネットワーク`はターゲットと呼ばれています。

# デフォルトゲートウェイ
デフォルトゲートウェイとは、通信の出入り口になるもので、通信先が設定されていない時のデフォルトの転送先のことです。インターネットに接続するためには、デフォルトゲートウェイをインターネットゲートウェイとして設定する必要があります。

# 仮想サーバ構築
AWSにおける仮想サーバは、`EC2`を用いて作成します。この仮想サーバのことを、AWSではインスタンスと呼びます。このインスタンスには、パブリックサブネットで利用可能な`プライベートIPアドレス`を割り当てます。ただし、プライベートIPアドレスはインターネットとの接続には利用できないので、`パブリックIPアドレス`も同時に設定する必要があります。パブリックIPアドレスには、AWSに割り当てられているIPアドレスブロックの適当な値が使用されます。

最終的に、作成したインスタンスは、VPC内で使用するためのプライベートIPアドレスと、インターネットで使用するためのパブリックIPアドレスを持つことになります。インスタンスにインターネット側からアクセスするには、パブリックIPアドレスを使用します。

## AMI
`AMI（Amazon Machine Image）`とは、インスタンスを起動する際に用いるイメージファイルのことです。このイメージは、OSがインストールされて初期アカウントの設定までが済んだもので、選んだ内容がそのままコピーされ、インスタンスが作成されます。

# EGP（Exterior Gateway Protocol）
`ISP（インターネットサービスプロバイダー）`やAWSなどの、ある程度の規模があるネットワークでは、そのネットワークを管理するために`AS（Autonomous System）番号`を持っています。EGPでは、このAS番号をやりとりして、どのネットワーク先にどのネットワークが接続されているのかをやりとりします。

# IGP（Interior Gateway Protocol）
EGPの内部のルーター同士で、ルートテーブルの情報のやり取りをします。つまり、AWSやプロバイダーでの詳細なやり取りに使われます。

## EGPとIGPの区別
ざっくりいうと、大まかな情報に関してはEGPで情報交換し、細かい情報に関してはIGPで情報交換するということです。この仕組みにより、インターネット上のルーティング情報は末端まで更新されているため、新たにネットワークが追加されてもIPアドレスさえわかればパケットを送信できるわけです。

# ポート
TCP/IPで通信するサーバーなどの機器には、他のコンピュータとデータを送受信するためのデータの出入り口が用意されていて、これを`ポート`と呼びます。ポートは、`0~65535`まであります。このポートのおかげで、1つのIPアドレスに対して複数のアプリケーションが同時に通信できるようになります。

ポートには、相手にデータが届いたことを保証する`TCP（Transmission Control Protocol）`と、高速だけど確認せずにデータを送信する`UDP（User Datagram Protocol）`の2種類があります。

## ウェルノウンポート（Well Known Port）
SSHで使用されている`ポート22番`といったように、代表的なアプリケーションが良く使用するポート番号のことを`ウェルノウンポート`と言います。ウェルノウンポートは`0~1023`までの番号を取り、以下のように値が決まっています。

- 22 : SSH
- 25 : SMTP（メールの送受信に使用されるプロトコル）
- 80 : HTTP（暗号化されていないWeb通信）
- 443 : HTTPS（暗号化されたWeb通信）

クライアントが接続先のポート番号を指定しなかった場合、このウェルのウンポートが優先して使用されるので、明示的に指定する必要がないというわけです。

## エフェメラルポート（ephemaral ports）
エフェメラルポートは、サーバーと接続している間だけ使用され、切断すると解放されるポートです。TCP/IPプロトコルのポート番号は、サーバー側だけではなくクライアント側にも存在し、クライアント側のポート番号は未使用のランダムなものが適用されます。このように、一時的に使用されるランダムなポート番号のことをエフェメラルポートと呼ぶわけです。

エフェメラルポートは、サーバーからクライアントに向けてデータを送信する際に必要です。これにより、クライアント上でたくさんのアプリケーションが起動していても、目的のアプリケーションに正しくデータを送信することができるわけです。

# ファイアウォール
ファイアウォールとは、通していいデータだけを通し、それ以外は遮断するという機能の総称です。セキュリティーを高めるには、このファイアウォールを設けることが重要です。特定のデータだけを通す機能のうち、もっとも単純な構造のものが`パケットフィルタリング`です。

## パケットフィルタリング（Packet Filtering）
パケットフィルタリングとは、流れるパケットを分析し、通過の可否を決める仕組みです。パケットには、`IPアドレス`と`ポート番号`という情報が含まれているのですが、パケットフィルタリングではそれらのパケットに付随する情報を確認し、通過の可否を決めます。そのため、IPアドレスを判定して接続元を制限したり、特定のポートを制限してアプリケーションへのアクセスを不可能にしたり、といったことができます。

## セキュリティーグループ
AWSでは、インスタンスに対してセキュリティーグループを構成することができます。このセキュリティーグループが、インスタンスにおけるパケットフィルタリングを可能にします。

# Apache
オープンソースで提供され、世界で最も多く利用されているWebサーバーソフトです。Apacheの大きな特徴は以下のようになります。

- 無償で誰でも利用可能
- 信頼性が高い
- データベースと連携がしやすい
- 昨日の拡張が可能
- Linux、Windowsなど複数のサーバOS上で拡張可能
- CMS(Contents Management System)を利用する際に簡単な設定で済む
- 技術情報が膨大にあるためトラブルシューティングしやすい
- レンタルサーバープランにあらかじめ組み込まれている場合が多い
- 公開ページを更に高速化表示する対策が行われている
- セキュリティ対策が随時更新されている

## Webサーバーとは
Webサーバーとは、クライアント（Webブラウザ）のリクエストを解釈し、そのリクエストに応じたデータをクライアントへ返す機能を持ったサーバーのことです。また、このやりとりはHTTPプロトコル上で行われます。ブラウザーは、ユーザーから入力されたURLを元にWebサーバーへ接続し、要求された情報を取得して画面に表示しています。

## URLとは
URLとは、インターネット上の住所のことです。URLは、プロトコル・ホスト名・ドメイン名・ファイル名で構成されています。

## ドメインとは
ドメインとはURLを構成するもので、英数字で表現されます。また、ドメインはピリオドで区切られていて、その区切られた部分を`ラベル`と言います。一番右のラベルをトップレベルドメインといい、そこから左へと、第2レベルドメイン、第3レベルドメイン、第4レベルドメインとなっています。

```
www.hoge.co.jp

=> 第4.第3.第2.トップ
```

トップレベルドメインには以下の種類があります。

- jp
- com
- net

### ドメインの管理
ドメインはIPアドレスと同様にICANNが管理していて、トップレベルのドメインごとにそれぞれの事業者が管理しています。

ドメインの管理組織（レジストリ）

- com, net => Verisign
- jp => JPRS
- org => Public Interest Registry

# DNS（Domain Name System）
DNSとは、ドメインとIPアドレスを対応させるシステムのことです。TCP/IPの世界では、ドメインでアクセスするときも最終的にはIPアドレスに変換して接続を行うので、その時にDNSを使用します。また、ドメイン名に対応するIPアドレスを見つけることを`名前解決`と呼びます。実際にドメインをIPアドレスに変換するのは、DNSサーバーで行います。DNSのシステムは世界中に散らばったDNSサーバー群で構成され、それぞれのDNSサーバーは自分の担当する範囲でのみ、ドメインとIPアドレスの変換を行ないます。もし、担当する範囲外の名前解決が必要になった場合は、他のDNSサーバーへと処理を転送します。

## 名前解決
名前解決は、以下のような順序で行われます。

1. ルートのDNSサーバー（トップレベルドメインのDNSサーバーに処理を振る）
2. トップレベルドメインのDNSサーバー（第2レベルのDNSサーバーに処理を振る）
3. 第2レベルのDNSサーバー（第3レベルのDNSサーバーに処理を振る）
4. 第3レベルのDNSサーバー（第4レベルのDNSサーバーに処理を振る）
5. 第4レベルのDNSサーバー（対応するIPアドレスを返す）

DNSは上記のように階層的に処理することによって、ドメインをIPアドレスに変換しています。

# HTTP（Hyper Text Transfer Protocol）
HTTPは、HTMLをはじめとするWebサービスの情報をやり取りするための規約で、クライアント・サーバー間のリクエスト、レスポンスをやり取りする方式を定めています。

## HTTPリクエストの構成
HTTPリクエストは以下の要素で構成されています。

- リクエストライン
- ヘッダー
- ボディ

### リクエストライン
リクエストラインは要求コマンドのことで、要求方法と要求するURLが含まれています。

### ヘッダー
ヘッダーはブラウザから送信される追加情報で、以下のような構成になっています。

- 要求したいホスト名
- ブラウザの種類
- 対応言語
- Cookieの情報
- 直前に見ていたページのURL

### ボディー
ボディーにはHTTPリクエストの補足情報が書かれています。HTMLやAjaxなどで、データをサーバーに伝えます。

## HTTPレスポンスの構成
HTTPレスポンスは以下の要素で構成されています。

- ステータスライン
- ヘッダー
- ボディ

### ステータスライン
ステータスラインは要求の成否を返すものです。何も異常がなければ、`200 OK`というステータスコードが返されます。

- 100番台 => 処理中
- 200番台 => リクエスト成功
- 300番台 => リダイレクト
- 400番台 => クライアントエラー
- 500番台 => サーバーエラー

### ヘッダー
HTTPヘッダはデータの状態を示す情報が入っている部分です。

### ボディー
ボディーは、要求されたURLに対応するコンテンツです。HTMLや画像など、要求されたデータが該当します。