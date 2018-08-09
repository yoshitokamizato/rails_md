# Markdownで文章を書き、HTML・Word・PDFに展開する方法

## Markdownで文章を書くメリット

## Markdownの書き方に慣れる

### AtomでMarkdownをプレビュー
Atomでmarkdownする方法
https://qiita.com/kouichi-c-nakamura/items/5b04fb1a127aac8ba3b0

## MarkdownをHTML・Wordに変換

[pandocをインストール](https://github.com/jgm/pandoc/releases/tag/2.2.2.1)

```
pandoc-2.2.2.1-macOS.pkg（Mac環境）
```

MarkdownファイルをHTMLファイルに変換

```
pandoc -o rails.html rails.md
```

MarkdownファイルをWordファイルに変換

```
pandoc -o rails.docx rails.md
```

### シェルスクリプトで自動化

```
touch conv.sh
```

```
chmod 755 conv.sh
```

```
vi conv.sh
```

```
echo "HTMLとWordに変換したいファイルの名前を入力してください（拡張子は不要です）"
read file_name
pandoc -o ${file_name}.docx ${file_name}.md
pandoc -o ${file_name}.html ${file_name}.md
```

```
./conv.sh
```

```
HTMLとWordに変換したいファイルの名前を入力してください（拡張子は不要です）
json
```

```
json.docx
json.html
```

```
conv.command
```

## MarkdownをPDFに変換
