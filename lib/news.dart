import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List articles = [];
  bool isLoading = true;

  Future<void> fetchNews() async {
    const apiKey =
        '229d8c21cbd94ee7b04b3f997ac88594'; // replace with your API key
    const url =
        'https://newsapi.org/v2/everything?q=plants+agriculture+nature&language=en&pageSize=20&sortBy=publishedAt&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        setState(() {
          articles = data['articles'];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load news");
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
                    return Card(
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
                    );
                  }).toList(),
                ],
              ),
      ),
    );
  }
}
