// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:news_api_flutter_package/model/article.dart';
// import 'package:sports_project/models/articles_model.dart';
//
// class NewsApi{
//
//
//   final String apiKey= "eaee5eed62f5421fb5acc14af698e4f4";
//   Future <List<Article>?> fetchArticles()async
//   {
//     try {
//       final url = Uri.parse(
//           "https://newsapi.org/v2/top-headlines?country=eg&apiKey=$apiKey");
//
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         String data = response.body ;
//         var jsonData = jsonDecode(data);
//         Articles articles =Articles.formJson(jsonData);
//         List<Article>? articlesList=
//         articles.articles.map((e) => Article).cast<Article>().toList();
//         return articlesList;
//       } else {
//         print("status code=${response.statusCode}");
//       }
//
//     }catch(ex)
//     {
//       print('ex');
//     }
//
//   }
//   Future <List<Article>?> fetchArticlesByCategory()async
//   {
//     try {
//       final url = Uri.parse(
//           "https://newsapi.org/v2/top-headlines?country=eg&category=sports&apiKey=$apiKey");
//
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         String data = response.body ;
//         var jsonData = jsonDecode(data);
//         Articles articles =Articles.formJson(jsonData);
//         List<Article>? articlesList=
//         articles.articles.map((e) => Article).cast<Article>().toList();
//         return articlesList;
//       } else {
//         print("status code=${response.statusCode}");
//       }
//
//     }catch(ex)
//     {
//       print('ex');
//     }
//
//   }
// }
