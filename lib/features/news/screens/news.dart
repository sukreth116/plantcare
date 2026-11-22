import 'package:flutter/material.dart';
import 'package:plantcare/features/news/screens/news_details.dart';
import 'package:plantcare/features/news/services/news_service.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List articles = [];
  bool isLoading = true;

  Future<void> fetchNews() async {
    try {
      final fetchedArticles = await NewsService.fetchPlantNews();
      if (mounted) {
        setState(() {
          articles = fetchedArticles;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  // Top Image
                  Image.asset(
                    'asset/image/Exciting news-pana.png',
                    width: double.infinity,
                    height: 150,
                    // fit: BoxFit.fitHeight,
                  ),

                  const SizedBox(height: 8),

                  // Top Text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "Agricultural and Plants News",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Milky'),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // List of cards
                  ...articles.map((article) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsDetailPage(article: article),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            article['urlToImage'] != null
                                ? Image.network(
                                    article['urlToImage'],
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.fitWidth,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'asset/image/no thumbnail.jpg',
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.fitWidth,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'asset/image/no thumbnail.jpg',
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.fitWidth,
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                article['title'] ?? 'No Title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                article['source']['name'] ?? '',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }
}
