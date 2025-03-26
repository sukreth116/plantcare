import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantcare/modules/nursery/profile_edit.dart';

class NurseryProfilePage extends StatelessWidget {
  final String nurseryId;
  

  const NurseryProfilePage({Key? key, required this.nurseryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('nurseries')
            .doc(nurseryId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Nursery not found"));
          }

          var nurseryData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          String? logoUrl = nurseryData['companyLogoUrl'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: (logoUrl != null && logoUrl.isNotEmpty)
                      ? NetworkImage(logoUrl)
                      : const AssetImage('assets/image/profile_placeholder.jpg')
                          as ImageProvider,
                  onBackgroundImageError: (_, __) => const Icon(Icons.error),
                ),
                const SizedBox(height: 16),

                // Nursery Name with Edit Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nurseryData['nurseryName'] ?? 'Unknown',
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
                                NurseryProfileEditScreen(nurseryId: nurseryId),
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
                  nurseryData['email'] ?? 'No Email',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: const Text('Phone'),
                  subtitle: Text(nurseryData['phone'] ?? 'No Phone'),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.green),
                  title: const Text('Address'),
                  subtitle: Text(nurseryData['address'] ?? 'No Address'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
