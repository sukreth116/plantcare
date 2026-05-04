import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  final Map article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['source']['name'] ?? 'News Source'),
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article['urlToImage'] != null
                ? Image.network(
                    article['urlToImage'],
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'asset/image/no thumbnail.jpg',
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'asset/image/no thumbnail.jpg',
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(height: 12),
            Text(
              article['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              article['publishedAt'] != null
                  ? DateTime.parse(article['publishedAt']).toLocal().toString()
                  : 'Date not available',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              article['description'] ?? 'No Description Available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              article['content'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
