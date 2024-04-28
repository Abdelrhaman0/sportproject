// import 'package:flutter/material.dart';
// import 'package:news_api_flutter_package/model/article.dart';
// import 'package:sports_project/pages/news/news_service.dart';
//
// class NewsScreen extends StatefulWidget {
//   @override
//   _NewsScreenState createState() => _NewsScreenState();
// }
//
// class _NewsScreenState extends State<NewsScreen> {
//   List<String> imageUrls = [
//     'assets/image/football.jpg',
//     'assets/image/tennis.jpg',
//     'assets/image/ball.jpg',
//     'assets/image/basketball.jpg',
//
//   ];
//
//   List<String> imageTexts = [
//     'Sports for life',
//     '',
//     'Movement is life',
//     '',
//   ];
//
//   List<Article>? articles = [];
//
//   int _currentImageIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchArticles();
//   }
//
//   void fetchArticles() async {
//     try {
//       final newsApi = NewsApi();
//       List<Article>? fetchedArticles = await newsApi.fetchArticlesByCategory();
//       setState(() {
//         articles = fetchedArticles;
//       });
//     } catch (ex) {
//       print('Exception: $ex');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Daily News'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 200,
//             child: PageView.builder(
//               itemCount: imageUrls.length,
//               onPageChanged: (int index) {
//                 setState(() {
//                   _currentImageIndex = index;
//                 });
//               },
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     showNewsDetails(index);
//                   },
//                   child: Container(
//                     margin: EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(imageUrls[index]),
//                         fit: BoxFit.cover,
//                       ),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Align(
//                       alignment: Alignment.bottomLeft,
//                       child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text(
//                           imageTexts[index], // Display the corresponding text
//                           style: TextStyle(
//                             color: Colors.black54,
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List<Widget>.generate(imageUrls.length, (int index) {
//               return Container(
//                 margin: EdgeInsets.symmetric(horizontal: 4.0),
//                 width: 10.0,
//                 height: 10.0,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _currentImageIndex == index
//                       ? Colors.redAccent
//                       : Colors.grey,
//                 ),
//               );
//             }),
//           ),
//           SizedBox(height: 16.0),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               'Latest News',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 color: Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: articles?.length ?? 0,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(articles?[index].title ?? ''),
//                   subtitle: Text(articles?[index].author ?? ''),
//                   onTap: () {
//                     showNewsDetails(index);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showNewsDetails(int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('News ${index + 1}'),
//           content: Text('News details here...'),
//           actions: [
//             TextButton(
//               child: Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }