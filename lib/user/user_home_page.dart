import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Greenify Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green.shade700,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome, User!',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Profile
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to Profile Page
              },
            ),

            // Cart
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Cart'),
              onTap: () {
                // Navigate to Cart Page
              },
            ),

            // Order History
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Order History'),
              onTap: () {
                // Navigate to Orders Page
              },
            ),

            // AR Integration
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('AR Integration'),
              onTap: () {
                // Navigate to AR Page
              },
            ),

            // AI Disease & Species Detection
            ListTile(
              leading: const Icon(Icons.science),
              title: const Text('AI Disease & Species Detection'),
              onTap: () {
                // Navigate to AI Detection Page
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Explore Greenify Features!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Active tab
        onTap: (index) {
          // Handle Navigation for Footer
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'News Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Social Media',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'E-Commerce',
          ),
        ],
      ),
    );
  }
}
