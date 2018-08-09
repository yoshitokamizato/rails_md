echo "HTMLとWordに変換したいファイルの名前を入力してください（拡張子は不要です）"
read file_name
pandoc -o ${file_name}.html ${file_name}.md
pandoc -o ${file_name}.docx ${file_name}.md
