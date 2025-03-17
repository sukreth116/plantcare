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
//       appBar: AppBar(
//         title: Text("Plant & Agriculture News"),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.all(10),
//         itemCount: newsArticles.length,
//         itemBuilder: (context, index) {
//           final article = newsArticles[index];
//           return Card(
//             elevation: 3,
//             margin: EdgeInsets.symmetric(vertical: 10),
//             child: ListTile(
//               contentPadding: EdgeInsets.all(10),
//               leading: Image.asset(
//                 article["image"]!,
//                 width: 80,
//                 fit: BoxFit.cover,
//               ),
//               title: Text(
//                 article["title"]!,
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(article["description"]!),
//               trailing: Icon(Icons.arrow_forward),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => NewsDetailScreen(article: article),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
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
//         backgroundColor: Colors.green,
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
import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  final List<Map<String, String>> newsArticles = [
    {
      "title": "Sustainable Farming Techniques",
      "description":
          "Learn how farmers are adopting sustainable methods to enhance productivity while preserving nature.",
      "image": "asset/image/news_image_1.jpg",
      "content":
          "Sustainable farming involves techniques such as crop rotation, organic fertilizers, and precision irrigation..."
    },
    {
      "title": "New Plant Species Discovered",
      "description":
          "Scientists have discovered a new plant species that thrives in dry conditions.",
      "image": "asset/image/news_image_2.jpg",
      "content":
          "The newly discovered plant species is capable of surviving in extreme drought conditions due to its unique root system..."
    },
    {
      "title": "Organic Gardening Tips",
      "description":
          "Discover essential tips for growing organic vegetables in your home garden.",
      "image": "asset/image/news_image_3.jpg",
      "content":
          "Organic gardening focuses on using natural compost, avoiding pesticides, and maintaining healthy soil..."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Latest News"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'asset/image/Exciting news-pana.png',
              height: 100,
            ),
            Text(
              "Agriculture and Plant News",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Milky'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: newsArticles.length,
                itemBuilder: (context, index) {
                  final article = newsArticles[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: Image.asset(
                        article["image"]!,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        article["title"]!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(article["description"]!),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NewsDetailScreen(article: article),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final Map<String, String> article;

  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News in detail'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              article["image"]!,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              article["title"]!,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              article["content"]!,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
