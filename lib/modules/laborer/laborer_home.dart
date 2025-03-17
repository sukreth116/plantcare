import 'package:flutter/material.dart';

class LaborerHomePage extends StatelessWidget {
  const LaborerHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          'Laborer Hub',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                color: Colors.brown.shade700,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        AssetImage('assets/images/profile_placeholder.png'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome, Laborer!',
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

            // Scheduled Jobs
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Scheduled Jobs'),
              onTap: () {
                // Navigate to Scheduled Jobs Page
              },
            ),

            // Job History
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Job History'),
              onTap: () {
                // Navigate to Job History Page
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Explore Laborer Hub Features!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade700,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.brown.shade700,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Active tab
        onTap: (index) {
          // Handle Navigation for Footer
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Job Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Available Jobs',
          ),
        ],
      ),
    );
  }
}
