import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Greenify"),
        backgroundColor: Colors.green.shade300,
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
                  'asset/image/cute cactus-amico.png',
                  height: 120,
                ),
              ),
              SizedBox(height: 20),
              _buildSectionTitle("What is Greenify?"),
              _buildSectionText(
                  "Greenify is a next-generation AI-powered plant care and e-commerce platform designed to transform how individuals and nurseries manage plants. It moves beyond traditional, manual methods by using intelligent features that are both efficient and personalized."),
              SizedBox(height: 16),
              _buildSectionTitle("Smart Plant Care"),
              _buildSectionText(
                  "Our app identifies plant species, detects diseases and pests through image analysis, and provides custom care routines tailored to each plant’s environment and condition using AI technologies like TensorFlow Lite and Scikit-learn."),
              SizedBox(height: 16),
              _buildSectionTitle("Powerful Nursery Tools"),
              _buildSectionText(
                  "Nursery professionals benefit from features like inventory tracking, health monitoring, and performance analytics. These tools enable efficient nursery operations through real-time data and insights."),
              SizedBox(height: 16),
              _buildSectionTitle("Real-Time Communication"),
              _buildSectionText(
                  "Greenify’s built-in communication module connects nursery workers with chat and task coordination powered by Web Sockets. This ensures seamless collaboration and operational efficiency."),
              SizedBox(height: 16),
              _buildSectionTitle("Integrated E-Commerce"),
              _buildSectionText(
                  "Users can shop for plants, tools, and accessories with real-time updates, personalized product suggestions, and secure payment gateways. Our marketplace is designed for a smooth and engaging shopping experience."),
              SizedBox(height: 16),
              _buildSectionTitle("Personalized User Experience"),
              _buildSectionText(
                  "User profiles track plant collections, purchase history, and care routines, offering a highly personalized dashboard powered by data-driven insights and intelligent recommendations."),
              SizedBox(height: 16),
              _buildSectionTitle("Advanced Technology Stack"),
              _buildSectionText(
                  "Greenify uses Flutter for cross-platform development, Firebase for backend services, TensorFlow Lite and Scikit-learn for AI, and integrates secure payments via Stripe or Razorpay."),
              SizedBox(height: 16),
              _buildSectionTitle("A Vision for the Future"),
              _buildSectionText(
                  "Greenify represents the future of digital plant care—an ecosystem where smart diagnostics, automation, and real-time collaboration come together to redefine how we grow, manage, and care for plants."),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSectionText(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.justify,
    );
  }
}