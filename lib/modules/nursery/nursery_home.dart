import 'package:flutter/material.dart';

class NurseryHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(
            'asset/image/company_logo.png',
          ), // Your app logo
        ),
        title: Text(
          "GREENIFY",
          style: TextStyle(
            color: Colors.green[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.green[800]),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promotional Banner
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "There's a Plant for Everyone",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Get your 1st plant at 30% off",
                      style: TextStyle(fontSize: 16, color: Colors.green[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search plant with name, type, etc...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.filter_list, color: Colors.green[700]),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Plant Categories
              PlantCard(
                title: "Kalanchoe - Orange",
                description:
                    "An evergreen succulent featuring waxy leaves and striking flame-orange flowers.",
                imagePath: 'asset/image/plant_sample_1.png',
              ),
              SizedBox(height: 10),
              PlantCard(
                title: "Ixora - Dark Orange",
                description:
                    "Ixoras are small tropical shrubs with vibrant orange-red flower clusters.",
                imagePath: 'asset/image/plant_sample_1.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Plant Card Widget
class PlantCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  PlantCard(
      {required this.title,
      required this.description,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.cover),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
