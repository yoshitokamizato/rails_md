# ネットワーク構築

# IPアドレスの範囲を決める
**Amazon VPC** を用いてVPC領域を構成すると、ユーザーごとに隔離されたネットワークが構築され、任意の設定を行うことができます。VPC領域を構成する際、まずは**IPアドレス範囲** の割り当てを考えましょう。

# IPアドレスとは
インターネットでは、**TCP/IPプロトコル** では、通信先を特定するためにIPアドレスを用います。IPアドレスはネットワーク上のユニークな番号で、重複することは許されません。このIPアドレスが、**ネットワーク上の住所** に相当します。このIPアドレスは、32ビットで構成されていて、8ビットずつ **.（ピリオド）** で区切られています。ビットは2進数でデータを取り扱うので、1ビットで2通りのデータを表現することができます。つまり、8ビットだと2の8乗通りのデータを表現することができるわけです。

2の8乗を10進数に直すと256なので、256通りのデータを表現することができます。それがIPアドレスだと、0~255で振り分けられるわけです。そして、IPアドレスは8ビットごとに.で区切られ、32ビットで構成されているので、0~255の番号のまとまりが4個続くというわけです。つまり、IPアドレスは`0.0.0.0 ~ 255.255.255.255`の間となります。

IPアドレスの例

```
172.33.31.254
```

# パブリックIPアドレス
インターネットに接続する際に使用するIPアドレスのことを　**パブリックIPアドレス** と言います。このパブリックIPアドレスは、 **ICANN(Internet Corporation for Assigned Names and Numbers)** という団体が一括管理していて、プロバイダーやサーバー業者から貸りることができます。

# プライベートIPアドレス
プライベートIPアドレスとは、誰にも申請することなく自由に使えるIPアドレスで、インターネットでは利用されません。社内LANを構築するときや、個人的にネットワークの実験をする時には、このIPアドレスが利用されます。このプライベートIPアドレスには、以下のような範囲が決められています。

- 10.0.0.0 ~ 1.255.255.255
- 172.16.0.0 ~ 172.31.255.255
- 192.168.0.0 ~ 192.168.255.255