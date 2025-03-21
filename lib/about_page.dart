import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Greenify"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'asset/image/cute cactus-amico.png', // Replace with your logo path
                  height: 120,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Welcome to Greenify",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Greenify is an AI-powered plant care and e-commerce platform designed to revolutionize plant care for individuals and plant nurseries. With AI-driven tools, a robust marketplace, and a nursery communication module, Greenify offers a seamless and intelligent experience for plant lovers and businesses alike.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Key Features:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildFeatureItem("🌿 AI-Powered Plant Care",
                  "Identify plant species, detect diseases, and get personalized care recommendations."),
              _buildFeatureItem("🛍️ E-Commerce Integration",
                  "Explore and purchase plants, gardening tools, fertilizers, and accessories."),
              _buildFeatureItem("🏡 Nursery Management",
                  "Monitor plant health, manage inventory, and streamline nursery operations."),
              _buildFeatureItem("💬 Worker Communication",
                  "Connect nursery workers with real-time chat and task coordination."),
              _buildFeatureItem("📊 Performance Analytics",
                  "Gain insights into plant health trends, sales, and operational performance."),
              SizedBox(height: 20),
              Text(
                "Technology Stack:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "✅ Flutter for cross-platform app development\n"
                "✅ Python (Flask/Django) for backend & AI functionalities\n"
                "✅ TensorFlow Lite for AI-based plant diagnostics\n"
                "✅ Firebase/PostgreSQL for secure data storage\n"
                "✅ Stripe/Razorpay for secure transactions",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                  child: Text(
                    "Back to Home",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
