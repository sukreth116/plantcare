// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:plantcare/modules/user/edit_profile.dart';

// class UserProfilePage extends StatelessWidget {
//   final String userId;

//   const UserProfilePage({Key? key, required this.userId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<DocumentSnapshot>(
//         future:
//             FirebaseFirestore.instance.collection('users').doc(userId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text("User not found"));
//           }

//           var userData = snapshot.data!.data() as Map<String, dynamic>;

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 20,
//                 ),
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundImage: userData['profileImageUrl'] != null
//                       ? NetworkImage(userData['profileImageUrl'])
//                       : AssetImage('asset/image/profile_placeholder.jpg')
//                           as ImageProvider,
//                 ),
//                 const SizedBox(height: 16),

//                 // Name with Edit Icon
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       userData['name'] ?? 'Unknown',
//                       style: const TextStyle(
//                           fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(width: 8), // Space between name and icon
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 EditProfilePage(userId: userId),
//                           ),
//                         );
//                       },
//                       child: const Icon(
//                         Icons.edit,
//                         color: Colors.green,
//                         size: 22,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 8),
//                 Text(
//                   userData['email'] ?? 'No Email',
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 16),

//                 ListTile(
//                   leading: const Icon(Icons.phone, color: Colors.green),
//                   title: const Text('Phone'),
//                   subtitle: Text(userData['phone'] ?? 'No Phone'),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.location_on, color: Colors.green),
//                   title: const Text('Address'),
//                   subtitle: Text(userData['address'] ?? 'No Address'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantcare/modules/user/edit_profile.dart';
import 'package:plantcare/modules/user/user_login.dart'; // Replace with your login screen

class UserProfilePage extends StatelessWidget {
  final String userId;

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (_) => const UserLoginScreen()), // Your login page
      (route) => false,
    );
  }

  void _deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // close dialog

              try {
                await docRef.delete(); // Delete Firestore data
                await user?.delete(); // Delete Firebase Auth account
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const UserLoginScreen()),
                  (route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${e.toString()}")),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User not found"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: userData['profileImageUrl'] != null
                      ? NetworkImage(userData['profileImageUrl'])
                      : const AssetImage('asset/image/profile_placeholder.jpg')
                          as ImageProvider,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userData['name'] ?? 'Unknown',
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
                                  EditProfilePage(userId: userId)),
                        );
                      },
                      child:
                          const Icon(Icons.edit, color: Colors.green, size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(userData['email'] ?? 'No Email',
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: const Text('Phone'),
                  subtitle: Text(userData['phone'] ?? 'No Phone'),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.green),
                  title: const Text('Address'),
                  subtitle: Text(userData['address'] ?? 'No Address'),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => _deleteAccount(context),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("Delete Account"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
