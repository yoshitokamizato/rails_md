# 画像ファイルのアップロード

gemをインストール

```ruby
gem 'carrierwave'
gem 'rmagick'
```

```
bundle install
```

エラーが出る場合RMagickを6系から7系に切り替える

```
brew unlink imagemagick
```

```
brew uninstall imagemagick
```

```
brew install imagemagick@6
```

```
brew link imagemagick@6 --force
```

マイグレーションファイルの作成

```
rails g migration AddImageToUser image:text
```

```
bundle exec rake db:migrate
```

アップローダを作成

```
rails g uploader image
```

アップローダファイルの中身を書き換え(uploaders/image_uploader.rb)

```ruby
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  storage :file
  process convert: 'jpg'
  # 保存するディレクトリ名
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  # thumb バージョン(width 400px x height 200px)
  version :thumb do
    process :resize_to_fit => [400, 200]
  end
  # 許可する画像の拡張子
  def extension_white_list
    %W[jpg jpeg gif png]
  end
  # 変換したファイルのファイル名の規則
  def filename
    "#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.jpg" if original_filename.present?
  end
end
```

画像をアップするモデルクラスに以下の記述を追加

```ruby
mount_uploader :image, ImageUploader
```

ファイルをアップロードするフォームを作成（form_for , simple_form_forに記述）

```
<%= f.file_field :image %>
```

画像を表示させたい場所に以下のコードを書く。

```
<%= image_tag user.image_url(:thumb) %>
```
