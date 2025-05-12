// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:plantcare/modules/nursery/profile_edit.dart';

// // class NurseryProfilePage extends StatelessWidget {
// //   final String nurseryId;

// //   const NurseryProfilePage({Key? key, required this.nurseryId})
// //       : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: StreamBuilder<DocumentSnapshot>(
// //         stream: FirebaseFirestore.instance
// //             .collection('nurseries')
// //             .doc(nurseryId)
// //             .snapshots(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           if (!snapshot.hasData || !snapshot.data!.exists) {
// //             return const Center(child: Text("Nursery not found"));
// //           }

// //           var nurseryData =
// //               snapshot.data!.data() as Map<String, dynamic>? ?? {};
// //           String? logoUrl = nurseryData['companyLogoUrl'];

// //           return SingleChildScrollView(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 const SizedBox(height: 20),
// //                 CircleAvatar(
// //                   radius: 50,
// //                   backgroundImage: (logoUrl != null && logoUrl.isNotEmpty)
// //                       ? NetworkImage(logoUrl)
// //                       : const AssetImage('assets/image/profile_placeholder.jpg')
// //                           as ImageProvider,
// //                   onBackgroundImageError: (_, __) => const Icon(Icons.error),
// //                 ),
// //                 const SizedBox(height: 16),

// //                 // Nursery Name with Edit Icon
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       nurseryData['nurseryName'] ?? 'Unknown',
// //                       style: const TextStyle(
// //                           fontSize: 22, fontWeight: FontWeight.bold),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     GestureDetector(
// //                       onTap: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) =>
// //                                 NurseryProfileEditScreen(nurseryId: nurseryId),
// //                           ),
// //                         );
// //                       },
// //                       child: const Icon(
// //                         Icons.edit,
// //                         color: Colors.green,
// //                         size: 22,
// //                       ),
// //                     ),
// //                   ],
// //                 ),

// //                 const SizedBox(height: 8),
// //                 Text(
// //                   nurseryData['email'] ?? 'No Email',
// //                   style: const TextStyle(fontSize: 16, color: Colors.grey),
// //                 ),
// //                 const SizedBox(height: 16),

// //                 ListTile(
// //                   leading: const Icon(Icons.phone, color: Colors.green),
// //                   title: const Text('Phone'),
// //                   subtitle: Text(nurseryData['phone'] ?? 'No Phone'),
// //                 ),
// //                 ListTile(
// //                   leading: const Icon(Icons.location_on, color: Colors.green),
// //                   title: const Text('Address'),
// //                   subtitle: Text(nurseryData['address'] ?? 'No Address'),
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:plantcare/modules/nursery/profile_edit.dart';

// class NurseryProfilePage extends StatelessWidget {
//   final String nurseryId;

//   const NurseryProfilePage({Key? key, required this.nurseryId})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('nurseries')
//             .doc(nurseryId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text("Nursery not found"));
//           }

//           var data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
//           String? logoUrl = data['companyLogoUrl'];

//           return Stack(
//             children: [
//               Container(
//                 height: 230,
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade300,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(40),
//                     bottomRight: Radius.circular(40),
//                   ),
//                 ),
//               ),
//               SafeArea(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 30),
//                       CircleAvatar(
//                         radius: 60,
//                         backgroundColor: Colors.white,
//                         backgroundImage: (logoUrl != null && logoUrl.isNotEmpty)
//                             ? NetworkImage(logoUrl)
//                             : const AssetImage(
//                                     'assets/image/profile_placeholder.jpg')
//                                 as ImageProvider,
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             data['nurseryName'] ?? 'Unknown',
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => NurseryProfileEditScreen(
//                                       nurseryId: nurseryId),
//                                 ),
//                               );
//                             },
//                             child: const Icon(Icons.edit, color: Colors.white),
//                           )
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         data['email'] ?? 'No Email',
//                         style: const TextStyle(color: Colors.white70),
//                       ),
//                       const SizedBox(height: 30),
//                       _buildInfoCard(
//                           Icons.phone, 'Phone', data['phone'] ?? 'No Phone'),
//                       _buildInfoCard(Icons.location_on, 'Address',
//                           data['address'] ?? 'No Address'),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInfoCard(IconData icon, String title, String content) {
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: Colors.green.shade100,
//           child: Icon(icon, color: Colors.green),
//         ),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//         subtitle: Text(content),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantcare/modules/nursery/profile_edit.dart';

class NurseryProfilePage extends StatelessWidget {
  final String nurseryId;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  NurseryProfilePage({Key? key, required this.nurseryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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

          var data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          String? logoUrl = data['companyLogoUrl'];
          String? licenseUrl = data['companyLicenseUrl'];

          return Stack(
            children: [
              Container(
                height: 230,
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: (logoUrl != null && logoUrl.isNotEmpty)
                            ? NetworkImage(logoUrl)
                            : const AssetImage(
                                    'assets/image/profile_placeholder.jpg')
                                as ImageProvider,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['nurseryName'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NurseryProfileEditScreen(
                                      nurseryId: nurseryId),
                                ),
                              );
                            },
                            child: const Icon(Icons.edit, color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data['email'] ?? 'No Email',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 30),

                      _buildInfoCard(
                          Icons.phone, 'Phone', data['phone'] ?? 'No Phone'),
                      _buildInfoCard(Icons.location_on, 'Address',
                          data['address'] ?? 'No Address'),

                      if (licenseUrl != null && licenseUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Company License",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  licenseUrl,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 30),

                      // Logout Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          await _auth.signOut();
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text("Logout"),
                      ),

                      const SizedBox(height: 12),

                      // Delete Account Button
                      TextButton.icon(
                        onPressed: () => _confirmDelete(context),
                        icon:
                            const Icon(Icons.delete_forever, color: Colors.red),
                        label: const Text("Delete Account",
                            style: TextStyle(color: Colors.red)),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String content) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(content),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              User? user = _auth.currentUser;
              if (user != null) {
                await FirebaseFirestore.instance
                    .collection('nurseries')
                    .doc(nurseryId)
                    .delete();
                await user.delete();
                Navigator.of(context).pushReplacementNamed('/register');
              }
            },
          )
        ],
      ),
    );
  }
}
