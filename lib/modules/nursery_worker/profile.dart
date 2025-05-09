import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerProfilePage extends StatelessWidget {
  final String workerId;

  const WorkerProfilePage({Key? key, required this.workerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('nursery_workers')
            .doc(workerId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Worker not found"));
          }

          var workerData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                        fontFamily: 'Milky',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade300),
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: workerData['profileImageUrl'] != null
                        ? NetworkImage(workerData['profileImageUrl'])
                        : const AssetImage(
                                'asset/image/profile_placeholder.jpg')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 8),

                  // Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        workerData['name'] ?? 'Unknown',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade300),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: Colors.green.shade300,
                          ))
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workerData['email'] ?? 'No Email',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.green.shade300),
                    title: const Text('Phone'),
                    subtitle: Text(workerData['phone'] ?? 'No Phone'),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.location_on, color: Colors.green.shade300),
                    title: const Text('Address'),
                    subtitle: Text(workerData['address'] ?? 'No Address'),
                  ),
                  ListTile(
                    leading: Icon(Icons.badge, color: Colors.green.shade300),
                    title: const Text('Worker ID'),
                    subtitle: Text(workerData['workerId'] ?? 'No ID'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'ID Card',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade300,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: workerData['idProofImageUrl'] !=
                                                null
                                            ? NetworkImage(
                                                workerData['idProofImageUrl'])
                                            : const AssetImage(
                                                    'assets/id_placeholder.png')
                                                as ImageProvider,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                    ),
                    label: const Text("Show ID Card"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green.shade300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // Logout Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      final confirmLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Logout"),
                            ),
                          ],
                        ),
                      );

                      if (confirmLogout == true) {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        // Optionally navigate to login page here
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 55, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Delete Account Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Account"),
                          content: const Text(
                              "Are you sure you want to permanently delete your account?"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Delete")),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        try {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            // Delete from Firestore
                            await FirebaseFirestore.instance
                                .collection('nursery_worker')
                                .doc(workerId)
                                .delete();
                            // Delete Firebase user account
                            await user.delete();
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Account deleted successfully")),
                          );

                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Error deleting account: ${e.toString()}")),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.delete_forever),
                    label: const Text("Delete Account"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
