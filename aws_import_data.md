

# 改行コード

# 文字エンコード

# 改行コード&文字エンコード変換ツール

`nkf`をインストールします。

```
brew install nkf
```

`nkf`のバージョンを表示させ、インストールが成功しているか確かめます。

```
nkf --version
```

出力結果

```
Network Kanji Filter Version 2.1.4 (2015-12-12)
Copyright (C) 1987, FUJITSU LTD. (I.Ichikawa).
Copyright (C) 1996-2015, The nkf Project.
```

文字エンコードを`UTF-8`、改行コードを`LF`に変換する場合は以下のコマンドを実行します。

```
$ nkf -g sample.csv
UTF-8 (LF)
```
