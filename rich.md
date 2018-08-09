## SEO

### リッチカードとは？
リッチカードとは、「ユーザーやクローラにWebサイトの構造をわかりやすく伝える」という役割を果たすものです。このリッチカードを導入することで、検索ページにおいて視覚的に強い印象を与えることができ、結果としてサイトのSEO強化に繋がります。リッチカードを導入するには、構造化データをHTMLの中に記述する必要があります。

### 構造化データとは？
構造化データとは、サーチエンジンにサイトの構造をわかりやすく伝えるデータのことです。そのため、この構造化データを正しく記述することができれば、検索エンジンからの評価も向上します。

### 構造化データの種類
構造化データには、以下の種類があります。

- Breadcrumbs
- Corporate contacts
- Carousels
- Logos
- Sitelinks Searchbox
- Social profiles
- Articles
- Books
- Courses
- Datasets
- Events
- Fact checks
- Job postings
- Local businesses
- Music
- Occupations
- Podcasts
- Products
- Recipes
- Reviews
- TV & movies
- Video

### 構造化データはスマホ表示にも有効
構造化データはPC、スマホなど、どちらの検索結果にも表示されます。

### 注意
リッチカードを導入する際は、必ずテストを行い、文法的におかしくないかどうかを確かめるようにしてください。もし何かしらのエラーが発生していた場合、SEOに悪影響があるので必ず確認するようにしましょう。確認方法に関しては、[構造化データテストツール](https://search.google.com/structured-data/testing-tool)を使用してください。


### 構造化データの実装方法
構造化データはJavaScriptをベースとした`JSON-LD`というデータ形式で記述します。こちらは、HTMLに直接埋め込むことで実装することができます。以下に書いてあるものが、実際の構造化データのサンプルになります。

```html
<script type="application/ld+json">
{
  "@context": "http://schema.org/",
  "@type": "Product",
  "name": "Yoast SEO for WordPress",
  "image": "https://cdn-images.yoast.com/...",
  "description": "Yoast SEO is the most ...",
  "brand": {
    "@type": "Thing",
    "name": "Yoast"
  },
  "offers": {
    "@type": "Offer",
    "priceCurrency": "USD",
    "price": "89.00"
  }
}
</script>
```

構造化データの実装方法についてもっと学びたい場合は、[公式チュートリアル](https://codelabs.developers.google.com/codelabs/structured-data/#0)をご利用ください。また、[構造化データのサンプル集](https://developers.google.com/search/docs/data-types/corporate-contact)もあわせてご利用ください。

### 構造化データの実装方法
こちらでは、構造化データの実装方法について書いていきます。

#### 構造化データのタイプを定義
1. `<head>`タグの中に`<script>`を記述し、`type`を`application/ld+json`にしてください。
2. Googleに`schema.org`という構造化データを使用することを伝えるため、`@context`には`http://schema.org/`を記述します。
3. `@type`には、どういう種類の構造化データにするかを記述します。料理サイトの場合は、下記のように`Recipe`と記述します。
```html
<html>
  <head>
    ...
    <script type="application/ld+json">
    {
      "@context": "http://schema.org/",
      "@type": "Recipe"
    }
    </script>
  </head>
</html>
```

#### 推奨データの追加
構造化データには、記述を推奨されているデータがあります。これらのデータもぜひ実装するようにしましょう。

1. `name`属性はページの内容を伝えるために重要な要素です。基本的に記述するようにしましょう。
2. 下の例では、nameにどういうレシピのページなのかを記述しています。

```html
<html>
<head>
...
<script type="application/ld+json">
{
  "@context": "http://schema.org/",
  "@type": "Recipe",
  "name": "Party Coffee Cake"
}
</script>
</head>
</html>
```

3. 推奨データを全て実装すると以下のようになります。`Recipe`に関する推奨データは[こちらのページ](https://developers.google.com/search/docs/data-types/recipe#recipe_properties)をご参考ください。

```html
<html>
<head>
...
<script type="application/ld+json">
  {
  "@context": "http://schema.org/",
  "@type": "Recipe",
  "name": "Party Coffee Cake",
  "image": "https://www.leannebrown.com/...",
  "author": {
    "@type": "Person",
    "name": "Mary Stone"
  },
  "datePublished": "2018-03-10",
  "description": "This coffee cake...",
    "prepTime": "PT20M",
    "cookTime": "PT30M",
    "totalTime": "PT50M",
    "recipeYield": "10 servings",
    "recipeCategory": "Dessert",
    "recipeCuisine": "American",
    "keywords": "cake for a party, coffee",
    "nutrition": {
      "@type": "NutritionInformation",
      "calories": "270 calories"
     },
      "recipeIngredient": [
        "2 cups of flour",
        "3/4 cup white sugar",
        "2 teaspoons baking powder",
        "1/2 teaspoon salt",
        "1/2 cup butter",
        "2 eggs",
        "3/4 cup milk"
       ],
    "recipeInstructions": [
      {
      "@type": "HowToStep",
      "text": "Preheat the oven to 350..."
      },
      {
      "@type": "HowToStep",
      "text": "In a medium bowl, combine..."
      },
      {
      "@type": "HowToStep",
      "text": "Mix in butter until the..."
      },
      {
      "@type": "HowToStep",
      "text": "In a large bowl, combine..."
      },
      {
      "@type": "HowToStep",
      "text": "Mix in the butter."
      },
      {
      "@type": "HowToStep",
      "text": "Spread into the prepared pan."
      },
      {
      "@type": "HowToStep",
      "text": "Sprinkle the streusel..."
      },
      {
      "@type": "HowToStep",
      "text": "Bake for 30 to 35..."
      },
      {
      "@type": "HowToStep",
      "text": "Allow to cool."
     }
  ],
  "video": [
     {
    "name": "How to make a Party Coffee Cake",
    "description": "This is how ...",
    "thumbnailUrl": [
      "https://example.com/hoge.jpg",
      "https://example.com/hoge.jpg",
      "https://example.com/hoge.jpg"
     ],
    "contentUrl": "http://hoge",
    "embedUrl": "http://www.hoge",
    "uploadDate": "2018-02-05T08:00:00+08:00",
    "duration": "PT1M33S",
    "interactionCount": "2347",
    "expires": "2019-02-05T08:00:00+08:00"
   }
  ]
}
</script>
</head>
</html>
```

[サンプルプレビュー画面](https://www.google.com/search?prvw=AHHjJUP1eLCiw6FDJPNL0cEKfK7ubbDQ3Q&q=previewid%3A72ff15e6-fc5c-4c15-aefa-b95741821240&useragent=Mozilla%2F5.0+%28Linux%3B+Android+5.1.1%3B+Nexus+5X+Build%2FMMB29P%29+AppleWebKit%2F537.36+%28KHTML%2C+like+Gecko%29+Chrome%2F48.0.2564.23+Mobile+Safari%2F537.36&filter=0&gws_rd=cr&newwindow=1&igu=1)
