import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NurseryProfilePage extends StatelessWidget {
  final String nurseryId;

  const NurseryProfilePage({Key? key, required this.nurseryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('nurseries')
            .doc(nurseryId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Nursery not found"));
          }

          var nurseryData = snapshot.data!.data() as Map<String, dynamic>;
          String? logoUrl = nurseryData['companyLogoUrl'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: logoUrl != null && logoUrl.isNotEmpty
                      ? NetworkImage(logoUrl)
                      : const AssetImage('asset/image/profile_placeholder.jpg')
                          as ImageProvider,
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
                    const SizedBox(width: 8), // Space between name and icon
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => EditNurseryProfilePage(nurseryId: nurseryId),
                        //   ),
                        // );
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
