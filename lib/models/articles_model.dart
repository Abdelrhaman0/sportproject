
class Articles{

  final  List<dynamic> articles;

  Articles({required this.articles});

  factory Articles.formJson(Map<String, dynamic> jsonData){
    return Articles(
      articles: jsonData["articles"],

    );

  }
}