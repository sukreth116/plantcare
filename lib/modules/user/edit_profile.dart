import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;

  const EditProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  void _fetchUserData() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

    if (userDoc.exists) {
      var userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _addressController.text = userData['address'] ?? '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

Future<void> _updateUserProfile() async {
  if (_formKey.currentState!.validate()) {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != _emailController.text) {
        // Ask user for their current password before changing email
        String password = await _getPasswordFromUser();

        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password, // User-provided password
        );

        // Re-authenticate
        await user.reauthenticateWithCredential(credential);

        // Update email in Firebase Authentication
        await user.updateEmail(_emailController.text);
      }

      // Update user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Updated Successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}

Future<String> _getPasswordFromUser() async {
  // TODO: Implement a UI to get the user's password for re-authentication.
  return 'user-password-here'; // Replace with actual input from the user.
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      onPressed: _updateUserProfile,
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EditProfilePage extends StatefulWidget {
//   final String userId;

//   const EditProfilePage({Key? key, required this.userId}) : super(key: key);

//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final _formKey = GlobalKey<FormState>();

//   // Text Editing Controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();

//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//   // Fetch user data from Firestore
//   void _fetchUserData() async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.userId)
//           .get();

//       if (userDoc.exists) {
//         var userData = userDoc.data() as Map<String, dynamic>;
//         setState(() {
//           _nameController.text = userData['name'] ?? '';
//           _emailController.text = userData['email'] ?? '';
//           _phoneController.text = userData['phone'] ?? '';
//           _addressController.text = userData['address'] ?? '';
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching user data: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // Function to update user profile
//   Future<void> _updateUserProfile() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         User? user = FirebaseAuth.instance.currentUser;

//         if (user != null) {
//           if (user.email != _emailController.text) {
//             // Ask for password before changing email
//             String? password = await _askForPassword();
//             if (password == null) {
//               return; // User canceled, stop update
//             }

//             // Re-authenticate user
//             AuthCredential credential = EmailAuthProvider.credential(
//               email: user.email!,
//               password: password,
//             );
//             await user.reauthenticateWithCredential(credential);

//             // Update email in Firebase Authentication
//             await user.updateEmail(_emailController.text);
//           }

//           // Update Firestore with new user details
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(widget.userId)
//               .update({
//             'name': _nameController.text,
//             'email': _emailController.text,
//             'phone': _phoneController.text,
//             'address': _addressController.text,
//           });

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profile Updated Successfully')),
//           );

//           Navigator.pop(context);
//         }
//       } catch (e) {
//         String errorMessage = "An error occurred.";
//         if (e is FirebaseAuthException) {
//           if (e.code == 'wrong-password') {
//             errorMessage = "Incorrect password. Please try again.";
//           } else if (e.code == 'requires-recent-login') {
//             errorMessage =
//                 "You need to log in again before updating your email.";
//           } else {
//             errorMessage = e.message ?? "Unknown error occurred.";
//           }
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage)),
//         );
//       }
//     }
//   }

//   // Function to ask user for password before updating email
//   Future<String?> _askForPassword() async {
//     TextEditingController passwordController = TextEditingController();
//     String? enteredPassword;

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Re-authenticate"),
//           content: TextField(
//             controller: passwordController,
//             obscureText: true,
//             decoration: const InputDecoration(labelText: "Enter your password"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Cancel input
//               },
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 enteredPassword = passwordController.text;
//                 Navigator.pop(context);
//               },
//               child: const Text("Submit"),
//             ),
//           ],
//         );
//       },
//     );

//     return enteredPassword;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text(
//           'Edit Profile',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: const InputDecoration(labelText: 'Name'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your name';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: const InputDecoration(labelText: 'Email'),
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       controller: _phoneController,
//                       decoration: const InputDecoration(labelText: 'Phone'),
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your phone number';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       controller: _addressController,
//                       decoration: const InputDecoration(labelText: 'Address'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your address';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 40, vertical: 15),
//                       ),
//                       onPressed: _updateUserProfile,
//                       child: const Text(
//                         'Update Profile',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
