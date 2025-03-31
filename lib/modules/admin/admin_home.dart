import 'package:flutter/material.dart';
import 'package:plantcare/modules/admin/manage_farmer.dart';
import 'package:plantcare/modules/admin/manage_nursery.dart';
import 'package:plantcare/modules/admin/manage_user.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Greenify',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        backgroundColor: const Color.fromARGB(234, 32, 203, 32),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Section
            const Center(
              child: Column(
                children: [
                  Text(
                    'Welcome, Admin!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildCard(context, Icons.person, 'Manage    Users'),
                  _buildCard(context, Icons.agriculture, 'Manage Farmers'),
                  _buildCard(context, Icons.local_shipping, 'Manage Nursery'),
                  _buildCard(context, Icons.work, 'Manage Laborers'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        _navigateToPage(context, title);
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.greenAccent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, String title) {
    Widget page;

    switch (title) {
      case 'Manage    Users':
        page = const ManageUsers();
        break;
      case 'Manage Farmers':
        page = const ManageFarmers();
        break;
      case 'Manage Nursery':
        page = const ManageNurseries();
        break;
      case 'Manage Laborers':
        page = const ManageLaborersScreen();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title tapped')),
        );
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class ManageLaborersScreen extends StatelessWidget {
  const ManageLaborersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderScreen(context, 'Manage Laborers');
  }
}

// Reusable Placeholder Screen
Widget _buildPlaceholderScreen(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      backgroundColor: Colors.green[700],
    ),
    body: Center(
      child: Text(
        "Welcome to $title Page!",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
