import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerProfilePage extends StatelessWidget {
  final String farmerId;

  const FarmerProfilePage({Key? key, required this.farmerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green,
      //   title: const Text(
      //     'Farmer Profile',
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      //   ),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      // ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('farmers')
            .doc(farmerId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Farmer not found"));
          }

          var farmerData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Profile',
                  style: TextStyle(
                      fontFamily: 'Happy Autumn',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade300),
                ),
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: farmerData['profilePhoto'] != null
                      ? NetworkImage(farmerData['profilePhoto'])
                      : const AssetImage('asset/image/profile_placeholder.jpg')
                          as ImageProvider,
                ),
                const SizedBox(height: 16),

                // Name
                Text(
                  farmerData['name'] ?? 'Unknown',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade300),
                ),
                const SizedBox(height: 8),
                Text(
                  farmerData['email'] ?? 'No Email',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: const Text('Phone'),
                  subtitle: Text(farmerData['phone'] ?? 'No Phone'),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.green),
                  title: const Text('Address'),
                  subtitle: Text(farmerData['address'] ?? 'No Address'),
                ),
                ListTile(
                  leading: const Icon(Icons.badge, color: Colors.green),
                  title: const Text('Farmer ID'),
                  subtitle: Text(farmerData['farmerId'] ?? 'No ID'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
