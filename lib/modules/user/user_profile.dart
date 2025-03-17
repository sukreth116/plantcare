// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class UserProfilePage extends StatelessWidget {
//   final String userId; // Assume userId is available

//   const UserProfilePage({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text(
//           'User Profile',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future:
//             FirebaseFirestore.instance.collection('users').doc(userId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text("User data not found"));
//           }

//           var userData = snapshot.data!.data() as Map<String, dynamic>;

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundImage: userData['profilePic'] != null
//                       ? NetworkImage(userData['profilePic'])
//                       : const AssetImage(
//                               'assets/images/profile_placeholder.png')
//                           as ImageProvider,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   userData['name'] ?? 'Unknown',
//                   style: const TextStyle(
//                       fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   userData['email'] ?? 'No email available',
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 16),
//                 ListTile(
//                   leading: const Icon(Icons.phone, color: Colors.green),
//                   title: const Text('Phone'),
//                   subtitle: Text(userData['phone'] ?? 'No phone available'),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.location_on, color: Colors.green),
//                   title: const Text('Address'),
//                   subtitle: Text(userData['address'] ?? 'No address available'),
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
import 'package:plantcare/modules/user/edit_profile.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'User Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
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
                SizedBox(
                  height: 20,
                ),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('asset/image/profile_placeholder.jpg'),
                ),
                const SizedBox(height: 16),

                // Name with Edit Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userData['name'] ?? 'Unknown',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8), // Space between name and icon
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(userId: userId),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.edit,
                        color: Colors.teal,
                        size: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  userData['email'] ?? 'No Email',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.teal),
                  title: const Text('Phone'),
                  subtitle: Text(userData['phone'] ?? 'No Phone'),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.teal),
                  title: const Text('Address'),
                  subtitle: Text(userData['address'] ?? 'No Address'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
