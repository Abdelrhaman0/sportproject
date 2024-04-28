class Article
{

  final String? author;
  final String? title;
  final String? url;
  final String? publishedAt;

  Article(
      {
        this.author,
        this.title,
        this.url,
        this.publishedAt
      }
      );


  factory Article.formJson(Map<String, dynamic> jsonData){
    return Article(
        author : jsonData['author'],
        title : jsonData['title'],

        url : jsonData['url'],
        publishedAt : jsonData['publishedAt']

    );
  }
}
