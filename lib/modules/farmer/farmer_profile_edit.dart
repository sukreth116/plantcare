// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FarmerProfileEditScreen extends StatefulWidget {
//   final String farmerId;

//   const FarmerProfileEditScreen({Key? key, required this.farmerId})
//       : super(key: key);

//   @override
//   _FarmerProfileEditScreenState createState() =>
//       _FarmerProfileEditScreenState();
// }

// class _FarmerProfileEditScreenState extends State<FarmerProfileEditScreen> {
//   final _formKey = GlobalKey<FormState>();

//   // Text Editing Controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _idCardNumberController = TextEditingController();
//   String? _idCardImageUrl;
//   String? _profilePhotoUrl;

//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchFarmerData();
//   }

//   // Fetch user data from Firestore
//   void _fetchFarmerData() async {
//     DocumentSnapshot farmerDoc = await FirebaseFirestore.instance
//         .collection('farmers')
//         .doc(widget.farmerId)
//         .get();

//     if (farmerDoc.exists) {
//       var farmerData = farmerDoc.data() as Map<String, dynamic>;
//       setState(() {
//         _nameController.text = farmerData['name'] ?? '';
//         _emailController.text = farmerData['email'] ?? '';
//         _phoneController.text = farmerData['phone'] ?? '';
//         _addressController.text = farmerData['address'] ?? '';
//         _idCardNumberController.text = farmerData['farmerIdCardNumber'] ?? '';
//         _idCardImageUrl = farmerData['farmerIdCard'];
//         _profilePhotoUrl = farmerData['profileImage'];
//         _isLoading = false;
//       });
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _updateFarmerProfile() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         User? user = FirebaseAuth.instance.currentUser;

//         if (user != null && user.email != _emailController.text) {
//           // Ask user for their current password before changing email
//           String password = await _getPasswordFromFarmer();

//           AuthCredential credential = EmailAuthProvider.credential(
//             email: user.email!,
//             password: password, // User-provided password
//           );

//           // Re-authenticate
//           await user.reauthenticateWithCredential(credential);

//           // Update email in Firebase Authentication
//           await user.updateEmail(_emailController.text);
//         }

//         // Update user details in Firestore
//         await FirebaseFirestore.instance
//             .collection('farmers')
//             .doc(widget.farmerId)
//             .update({
//           'name': _nameController.text,
//           'email': _emailController.text,
//           'phone': _phoneController.text,
//           'address': _addressController.text,
//           'farmerIdCardNumber': _idCardNumberController.text,
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile Updated Successfully')),
//         );

//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   Future<String> _getPasswordFromFarmer() async {
//     return 'farmer-password-here'; // Replace with actual input from the user.
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
//                     TextFormField(
//                       controller: _idCardNumberController,
//                       decoration:
//                           const InputDecoration(labelText: 'ID Card Number'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your ID card number';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     if (_idCardImageUrl != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('ID Card Image:'),
//                           const SizedBox(height: 5),
//                           Image.network(_idCardImageUrl!, height: 150),
//                           const SizedBox(height: 10),
//                         ],
//                       ),
//                     if (_profilePhotoUrl != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('Profile Photo:'),
//                           const SizedBox(height: 5),
//                           CircleAvatar(
//                             backgroundImage: NetworkImage(_profilePhotoUrl!),
//                             radius: 50,
//                           ),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 40, vertical: 15),
//                       ),
//                       onPressed: _updateFarmerProfile,
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
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantcare/clodinary_upload.dart';

class FarmerProfileEditScreen extends StatefulWidget {
  final String farmerId;

  const FarmerProfileEditScreen({Key? key, required this.farmerId})
      : super(key: key);

  @override
  _FarmerProfileEditScreenState createState() =>
      _FarmerProfileEditScreenState();
}

class _FarmerProfileEditScreenState extends State<FarmerProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _idCardNumberController = TextEditingController();

  String? _idCardImageUrl;
  String? _profilePhotoUrl;
  File? _newIdCardImageFile;
  File? _newProfilePhotoFile;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    DocumentSnapshot farmerDoc = await FirebaseFirestore.instance
        .collection('farmers')
        .doc(widget.farmerId)
        .get();

    if (farmerDoc.exists) {
      var data = farmerDoc.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _addressController.text = data['address'] ?? '';
        _idCardNumberController.text = data['idCardNumber'] ?? '';
        _idCardImageUrl = data['idCardImageUrl'];
        _profilePhotoUrl = data['profilePhotoUrl'];
        _isLoading = false;
      });
    } else {
      _isLoading = false;
    }
  }

  Future<void> _pickImage(bool isProfilePhoto) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isProfilePhoto) {
          _newProfilePhotoFile = File(pickedFile.path);
        } else {
          _newIdCardImageFile = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _updateFarmerProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null && user.email != _emailController.text) {
          String password = await _getPasswordFromFarmer();
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );
          await user.reauthenticateWithCredential(credential);
          await user.updateEmail(_emailController.text);
        }

        // Upload images if new
        if (_newProfilePhotoFile != null) {
          _profilePhotoUrl = await getCloudinaryUrl(_newProfilePhotoFile!.path);
        }
        if (_newIdCardImageFile != null) {
          _idCardImageUrl = await getCloudinaryUrl(_newIdCardImageFile!.path);
        }

        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('farmers')
            .doc(widget.farmerId)
            .update({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'idCardNumber': _idCardNumberController.text,
          'profilePhotoUrl': _profilePhotoUrl,
          'idCardImageUrl': _idCardImageUrl,
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

  Future<String> _getPasswordFromFarmer() async {
    return 'farmer-password-here'; // Replace with actual input dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Photo
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _newProfilePhotoFile != null
                              ? FileImage(_newProfilePhotoFile!)
                                  as ImageProvider
                              : (_profilePhotoUrl != null
                                  ? NetworkImage(_profilePhotoUrl!)
                                  : const AssetImage(
                                      'asset/image/profile_placeholder.jpg')),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _pickImage(true),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Input Fields
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter phone' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter address'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _idCardNumberController,
                      decoration:
                          const InputDecoration(labelText: 'ID Card Number'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter ID card number'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // ID Card Image
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('ID Card Image',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickImage(false),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: _newIdCardImageFile != null
                                ? FileImage(_newIdCardImageFile!)
                                    as ImageProvider
                                : (_idCardImageUrl != null
                                    ? NetworkImage(_idCardImageUrl!)
                                    : const AssetImage(
                                        'asset/image/no thumbnail.jpg')),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        child: _newIdCardImageFile == null &&
                                _idCardImageUrl == null
                            ? const Center(child: Icon(Icons.add_a_photo))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _updateFarmerProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      child: const Text('Update Profile',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
