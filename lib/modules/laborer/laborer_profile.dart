import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantcare/modules/laborer/laborer_profile_edit.dart';

class LaborerProfileScreen extends StatelessWidget {
  const LaborerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            String? profileImageUrl = laborerData['profileImageUrl'];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: (profileImageUrl != null &&
                              profileImageUrl.isNotEmpty)
                          ? NetworkImage(profileImageUrl)
                          : const AssetImage(
                                  'assets/image/profile_placeholder.jpg')
                              as ImageProvider,
                      onBackgroundImageError: (_, __) =>
                          const Icon(Icons.error),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          laborerData['name'] ?? 'Unknown',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LaborerProfileUpdateScreen(
                                        laborerId: FirebaseAuth
                                            .instance.currentUser!.uid),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.green,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      laborerData['email'] ?? 'No Email',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.green),
                      title: const Text('Phone'),
                      subtitle: Text(laborerData['phone'] ?? 'No Phone'),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.location_on, color: Colors.green),
                      title: const Text('Address'),
                      subtitle: Text(laborerData['location'] ?? 'No Address'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.work, color: Colors.green),
                      title: const Text('Experience'),
                      subtitle: Text(
                        laborerData['experience'] != null
                            ? '${laborerData['experience']} Years Experience'
                            : 'No Experience',
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.build, color: Colors.green),
                      title: const Text('Skills'),
                      subtitle: Text(
                        (laborerData['skills'] as List<dynamic>?)?.join(', ') ??
                            'No Skills Available',
                      ),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.location_on, color: Colors.green),
                      title: const Text('Price'),
                      subtitle: Text(
                        laborerData['pricePerHour'] != null
                            ? '${laborerData['pricePerHour']} per hour'
                            : 'No Price',
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
}
