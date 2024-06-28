import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';
import 'package:sports_project/pages/news/news_web_view.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<Article>> future;
  String? searchTerm;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<String> categoryItems = [
    "SPORTS",
  ];

  late String selectedCategory;

  @override
  void initState() {
    selectedCategory = categoryItems[0];
    future = getNewsData();

    super.initState();
  }

  Future<List<Article>> getNewsData() async {
    NewsAPI newsAPI = NewsAPI("f0382504da8c4ef8b8270c194a244656");
    return await newsAPI.getTopHeadlines(
      country: "us",
      query: searchTerm,
      category: selectedCategory,
      pageSize: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error loading the news"),
                    );
                  } else {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return _buildNewsListView(snapshot.data as List<Article>);
                    } else {
                      return const Center(
                        child: Text("No news available"),
                      );
                    }
                  }
                },
                future: future,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNewsListView(List<Article> articleList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Article article = articleList[index];
        return _buildNewsItem(article);
      },
      itemCount: articleList.length,
    );
  }

  Widget _buildNewsItem(Article article) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsWebView(url: article.url!),
            ));
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 180,
                width: double.infinity,
                child: Image.network(
                  article.urlToImage ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported);
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                article.title!,
                maxLines: 2,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                article.source.name!,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedCategory = categoryItems[index];
                  future = getNewsData();
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  categoryItems[index] == selectedCategory
                      ? Colors.green.withOpacity(0.5)
                      : Colors.green,
                ),
              ),
              child: Text(categoryItems[index]),
            ),
          );
        },
        itemCount: categoryItems.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}