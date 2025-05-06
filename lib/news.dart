// import 'package:flutter/material.dart';

// class NewsPage extends StatelessWidget {
//   final List<Map<String, String>> newsArticles = [
//     {
//       "title": "Sustainable Farming Techniques",
//       "description":
//           "Learn how farmers are adopting sustainable methods to enhance productivity while preserving nature.",
//       "image": "asset/image/news_image_1.jpg",
//       "content":
//           "Sustainable farming involves techniques such as crop rotation, organic fertilizers, and precision irrigation..."
//     },
//     {
//       "title": "New Plant Species Discovered",
//       "description":
//           "Scientists have discovered a new plant species that thrives in dry conditions.",
//       "image": "asset/image/news_image_2.jpg",
//       "content":
//           "The newly discovered plant species is capable of surviving in extreme drought conditions due to its unique root system..."
//     },
//     {
//       "title": "Organic Gardening Tips",
//       "description":
//           "Discover essential tips for growing organic vegetables in your home garden.",
//       "image": "asset/image/news_image_3.jpg",
//       "content":
//           "Organic gardening focuses on using natural compost, avoiding pesticides, and maintaining healthy soil..."
//     }
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(
//               'asset/image/Exciting news-pana.png',
//               height: 100,
//             ),
//             Text(
//               "Agriculture and Plant News",
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Milky'),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: newsArticles.length,
//                 itemBuilder: (context, index) {
//                   final article = newsArticles[index];
//                   return Card(
//                     elevation: 3,
//                     margin: EdgeInsets.symmetric(vertical: 10),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(10),
//                       leading: Image.asset(
//                         article["image"]!,
//                         width: 80,
//                         fit: BoxFit.cover,
//                       ),
//                       title: Text(
//                         article["title"]!,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(article["description"]!),
//                       trailing: Icon(Icons.arrow_forward),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 NewsDetailScreen(article: article),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NewsDetailScreen extends StatelessWidget {
//   final Map<String, String> article;

//   NewsDetailScreen({required this.article});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('News in detail'),
//         backgroundColor: Colors.green.shade300,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               article["image"]!,
//               width: double.infinity,
//               height: 250,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 16),
//             Text(
//               article["title"]!,
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               article["content"]!,
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
                    height: 100,
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
