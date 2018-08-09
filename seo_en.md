## Rich Card
Rich cards are a new Search result format building on the success of rich snippets. Just like rich snippets, rich cards use schema.org structured markup to display content in an even more engaging and visual format, with a focus on providing a better mobile user experience.

### What is structured data?
Structured data is the data you add to your website to make it easier for search engines to understand. You need a so-called vocabulary to make it work and the one used by the big search engines is called Schema.org. Schema.org provides a series of tags and properties to mark up your products, reviews, local business listings, etc in detail. The major search engines, Google, Bing, Yandex, and Yahoo, collectively developed this vocabulary to reach a shared language that allows them to gain a better understanding of websites.

### structured data
Below is a sampling of the rich search results that are currently available; you can find examples of all in [Google’s Search Gallery](https://developers.google.com/search/docs/guides/search-gallery).

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

### Does structured data work on mobile?
Yes, the results of implementing structured data work everywhere. Mobile implementation of Schema.org data is in its infancy, although Google has been pushing mobile rich search results for a while now.

### How to implement structured data
Actually there’s nothing scary about adding the data to your pages any more thanks to JSON-LD. This JavaScript-based data format makes it much easier to add structured data since it forms a block of code and is no longer embedded in the HTML of your page. This makes it easier to write and maintain, plus it’s better understood by both humans and machines.


### Add structured data
To define the type of structured data, follow the steps below.

#### Define the type of structured data
1. In your code snippet in SDTT, create a `<script>` element with the type set to `application/ld+json` in the <head> of the page.
```
Note: You can place the structured data anywhere in the page.
```
2. Inside the `<script>` element, set `@context` to `http://schema.org` to tell Google you're using schema.org structured data.
3. Set `@type`to Recipe to tell Google what kind of thing you're describing; in this case, it's a recipe. You should have this so far:
```
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

#### Add required and recommended properties
Each structured data type supports a list of required and recommended properties that give Google more information about the thing being described. These requirements and recommendations power various Google products and features. There is nothing wrong with your page if it's missing some properties; it just means that it is less likely to work with certain features.

1. Look at the list of required properties in the Recipe documentation and locate the name property to see if there are additional guidelines for this property.
2. In SDTT, enter the name of the dish (which is Party Coffee Cake) as the value for name.
You should have this so far:
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
