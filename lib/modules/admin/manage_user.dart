import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserList(false), // Pending users
          _buildUserList(true), // Approved users
        ],
      ),
    );
  }

  Widget _buildUserList(bool isApproved) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('isApproved', isEqualTo: isApproved)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              isApproved
                  ? 'No approved users found.'
                  : 'No pending users found.',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          );
        }

        final users = snapshot.data!.docs;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final name = user['name'] ?? 'No Name';
            final email = user['email'] ?? 'No Email';
            final phone = user['phone'] ?? 'No Phone';
            final location = user['address'] ?? 'No Location';

            return _buildUserCard(
                context, name, email, isApproved, phone, location, user.id);
          },
        );
      },
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    String name,
    String email,
    bool isApproved,
    String phone,
    String location,
    String id,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetails(
              userId: id,
              name: name,
              email: email,
              isApproved: isApproved,
              phone: phone,
              location: location,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 10, // More floating effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isApproved ? Colors.green.shade100 : Colors.blue.shade100,
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color:
                      isApproved ? Colors.green.shade700 : Colors.blue.shade700,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isApproved
                              ? Colors.green.shade700
                              : Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Email: $email',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Location: $location',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isApproved ? Icons.check_circle : Icons.pending,
                  color: isApproved ? Colors.green : Colors.blue,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// User Details Page
class UserDetails extends StatelessWidget {
  final String userId;
  final String name;
  final String email;
  final bool isApproved;
  final String phone;
  final String location;

  const UserDetails({
    super.key,
    required this.userId,
    required this.name,
    required this.email,
    required this.isApproved,
    required this.phone,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $email',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: $phone',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: $location',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({'isApproved': !isApproved});
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isApproved ? Colors.red : Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text(
                isApproved ? 'Revoke Approval' : 'Approve User',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
