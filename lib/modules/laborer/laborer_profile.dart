import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantcare/choose_screen.dart';

class LaborerProfileScreen extends StatelessWidget {
  const LaborerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown[700],
        title: const Text(
          'Laborer Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              bool confirmLogout = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red[600]),
                        const SizedBox(width: 10),
                        const Text('Confirm Logout'),
                      ],
                    ),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('Logout',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('laborers')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            final laborerData = snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 6,
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.brown[800]!,
                                      Colors.brown[500]!
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 30,
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    laborerData['profileImageUrl'] ??
                                        'asset/image/profile_placeholder.jpg',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                          Text(
                            laborerData['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Skilled Farm Laborer',
                            style: TextStyle(
                                fontSize: 16, color: Colors.brown[600]),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    _sectionHeader('Personal Details', Colors.brown),
                    _detailCard([
                      _detailRow(
                          Icons.email, laborerData['email'] ?? 'Not available'),
                      _detailRow(
                          Icons.phone, laborerData['phone'] ?? 'Not available'),
                      _detailRow(Icons.location_on,
                          laborerData['location'] ?? 'Not available'),
                    ]),

                    const SizedBox(height: 20),
                    _sectionHeader('Skills & Experience', Colors.brown),
                    _detailCard([
                      _detailRow(
                        Icons.build,
                        (laborerData['skills'] as List<dynamic>?)?.join(', ') ??
                            'Not specified',
                      ),
                      _detailRow(Icons.work,
                          'Experience: ${laborerData['experience'] ?? 'Not specified'} years'),
                    ]),

                    const SizedBox(height: 20),
                    _sectionHeader('Approval Status', Colors.brown),
                    _detailCard([
                      _detailRow(
                        Icons.verified,
                        laborerData['isApproved'] == true
                            ? 'Approved'
                            : 'Not Approved',
                      ),
                    ]),

                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => LaborerEditProfile(
                        //       laborerId: FirebaseAuth.instance.currentUser!.uid,
                        //     ),
                        //   ),
                        // );
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('Edit Profile',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Laborer data not found'));
          }
        },
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(width: 5, height: 20, color: color),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _detailCard(List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.brown),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
