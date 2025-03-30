// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class NurseryProfileEditScreen extends StatefulWidget {
//   final String nurseryId;

//   const NurseryProfileEditScreen({Key? key, required this.nurseryId})
//       : super(key: key);

//   @override
//   _NurseryProfileEditScreenState createState() =>
//       _NurseryProfileEditScreenState();
// }

// class _NurseryProfileEditScreenState extends State<NurseryProfileEditScreen> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();

//   String _name = '';
//   String _address = '';
//   String _phone = '';
//   String _email = '';
//   File? _companyLogo;
//   File? _companyLicense;
//   String? _logoUrl;
//   String? _licenseUrl;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadNurseryData();
//   }

//   Future<void> _loadNurseryData() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       DocumentSnapshot doc =
//           await _firestore.collection('nurseries').doc(user.uid).get();
//       if (doc.exists) {
//         setState(() {
//           _name = doc['nurseryName'];
//           _address = doc['address'];
//           _phone = doc['phone'];
//           _email = doc['email'];
//           _logoUrl = doc['companyLogoUrl'];
//           _licenseUrl = doc['companyLicenseUrl'];
//         });
//       }
//     }
//   }

//   Future<String> uploadToCloudinary(File image) async {
//     final url =
//         Uri.parse("https://api.cloudinary.com/v1_1/ds0psaxoc/image/upload");
//     final request = http.MultipartRequest("POST", url)
//       ..fields["upload_preset"] = "products"
//       ..files.add(await http.MultipartFile.fromPath("file", image.path));

//     final response = await request.send();
//     if (response.statusCode == 200) {
//       final responseData = await response.stream.bytesToString();
//       final jsonData = json.decode(responseData);
//       return jsonData["secure_url"];
//     } else {
//       throw Exception("Failed to upload image");
//     }
//   }

//   Future<void> _pickImage(bool isLogo) async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         if (isLogo) {
//           _companyLogo = File(pickedFile.path);
//         } else {
//           _companyLicense = File(pickedFile.path);
//         }
//       });
//     }
//   }

//   void _updateNurseryProfile() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       try {
//         User? user = _auth.currentUser;
//         if (user == null) return;

//         String logoUrl = _companyLogo != null
//             ? await uploadToCloudinary(_companyLogo!)
//             : _logoUrl ?? '';
//         String licenseUrl = _companyLicense != null
//             ? await uploadToCloudinary(_companyLicense!)
//             : _licenseUrl ?? '';

//         await _firestore.collection('nurseries').doc(user.uid).update({
//           'nurseryName': _name,
//           'address': _address,
//           'phone': _phone,
//           'companyLogoUrl': logoUrl,
//           'companyLicenseUrl': licenseUrl,
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile Updated Successfully')),
//         );
//       } catch (e) {
//         setState(() {
//           _errorMessage = e.toString();
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit Nursery Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 initialValue: _name,
//                 decoration: const InputDecoration(labelText: 'Nursery Name'),
//                 validator: (value) => value!.isEmpty ? 'Required' : null,
//                 onSaved: (value) => _name = value!,
//               ),
//               TextFormField(
//                 initialValue: _address,
//                 decoration: const InputDecoration(labelText: 'Address'),
//                 validator: (value) => value!.isEmpty ? 'Required' : null,
//                 onSaved: (value) => _address = value!,
//               ),
//               TextFormField(
//                 initialValue: _phone,
//                 decoration: const InputDecoration(labelText: 'Phone Number'),
//                 validator: (value) =>
//                     value!.length < 10 ? 'Invalid number' : null,
//                 onSaved: (value) => _phone = value!,
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () => _pickImage(true),
//                 child: Text(_companyLogo == null
//                     ? 'Change Company Logo'
//                     : 'Logo Selected'),
//               ),
//               ElevatedButton(
//                 onPressed: () => _pickImage(false),
//                 child: Text(_companyLicense == null
//                     ? 'Change Company License'
//                     : 'License Selected'),
//               ),
//               if (_errorMessage.isNotEmpty)
//                 Text(_errorMessage, style: const TextStyle(color: Colors.red)),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: _updateNurseryProfile,
//                 child: const Text('Update Profile'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NurseryProfileEditScreen extends StatefulWidget {
  final String nurseryId;

  const NurseryProfileEditScreen({Key? key, required this.nurseryId})
      : super(key: key);

  @override
  _NurseryProfileEditScreenState createState() =>
      _NurseryProfileEditScreenState();
}

class _NurseryProfileEditScreenState extends State<NurseryProfileEditScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _name = '';
  String _address = '';
  String _phone = '';
  File? _companyLogo;
  File? _companyLicense;
  String? _logoUrl;
  String? _licenseUrl;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadNurseryData();
  }

  Future<void> _loadNurseryData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('nurseries').doc(user.uid).get();
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;

          setState(() {
            _nameController.text = data['nurseryName'] ?? '';
            _addressController.text = data['address'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _emailController.text = data['email'] ?? '';
            _logoUrl = data['companyLogoUrl'];
            _licenseUrl = data['companyLicenseUrl'];
          });
        }
      }
    } catch (e) {
      print("Error loading nursery data: $e");
    }
  }

  Future<String> uploadToCloudinary(File image) async {
    try {
      final url =
          Uri.parse("https://api.cloudinary.com/v1_1/ds0psaxoc/image/upload");

      var request = http.MultipartRequest("POST", url)
        ..fields["upload_preset"] = "products"
        ..files.add(await http.MultipartFile.fromPath("file", image.path));

      var response = await request.send();

      final responseBody = await response.stream.bytesToString();
      print("Cloudinary Response: $responseBody");

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        return jsonData["secure_url"];
      } else {
        throw Exception("Upload failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Upload Error: $e");
      throw Exception("Image upload failed. Please try again.");
    }
  }

  Future<void> _pickImage(bool isLogo) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isLogo) {
          _companyLogo = File(pickedFile.path);
        } else {
          _companyLicense = File(pickedFile.path);
        }
      });
    }
  }

  void _updateNurseryProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        User? user = _auth.currentUser;
        if (user == null) return;

        String logoUrl = _companyLogo != null
            ? await uploadToCloudinary(_companyLogo!)
            : _logoUrl ?? '';
        String licenseUrl = _companyLicense != null
            ? await uploadToCloudinary(_companyLicense!)
            : _licenseUrl ?? '';

        await _firestore.collection('nurseries').doc(widget.nurseryId).update({
          'nurseryName': _name,
          'address': _address,
          'phone': _phone,
          'companyLogoUrl': logoUrl,
          'companyLicenseUrl': licenseUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }
  // void _updateNurseryProfile() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //     try {
  //       User? user = _auth.currentUser;
  //       if (user == null) return;

  //       print("Uploading images...");

  //       String logoUrl = _companyLogo != null
  //           ? await uploadToCloudinary(_companyLogo!)
  //           : _logoUrl ?? '';
  //       print("Logo URL: $logoUrl");

  //       String licenseUrl = _companyLicense != null
  //           ? await uploadToCloudinary(_companyLicense!)
  //           : _licenseUrl ?? '';
  //       print("License URL: $licenseUrl");

  //       print("Updating Firestore...");
  //       await _firestore.collection('nurseries').doc(widget.nurseryId).update({
  //         'nurseryName': _name,
  //         'address': _address,
  //         'phone': _phone,
  //         'companyLogoUrl': logoUrl,
  //         'companyLicenseUrl': licenseUrl,
  //       });

  //       print("Firestore updated successfully.");

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Profile Updated Successfully')),
  //       );

  //       Navigator.pop(context);
  //     } catch (e) {
  //       print("Error updating profile: $e");
  //       setState(() {
  //         _errorMessage = e.toString();
  //       });
  //     }
  //   }
  // }
  
  // void _updateNurseryProfile() async {
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       User? user = _auth.currentUser;
  //       if (user == null) return;

  //       String logoUrl = _logoUrl ?? '';
  //       String licenseUrl = _licenseUrl ?? '';

  //       if (_companyLogo != null) {
  //         try {
  //           logoUrl = await uploadToCloudinary(_companyLogo!);
  //         } catch (e) {
  //           print("Logo upload failed: $e");
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Failed to upload logo')),
  //           );
  //           return; // Stop execution if upload fails
  //         }
  //       }

  //       if (_companyLicense != null) {
  //         try {
  //           licenseUrl = await uploadToCloudinary(_companyLicense!);
  //         } catch (e) {
  //           print("License upload failed: $e");
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Failed to upload license')),
  //           );
  //           return;
  //         }
  //       }

  //       await _firestore.collection('nurseries').doc(widget.nurseryId).update({
  //         'nurseryName': _nameController.text,
  //         'address': _addressController.text,
  //         'phone': _phoneController.text,
  //         'companyLogoUrl': logoUrl,
  //         'companyLicenseUrl': licenseUrl,
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Profile Updated Successfully')),
  //       );

  //       Navigator.pop(context);
  //     } catch (e) {
  //       print("Error updating profile: $e");
  //       setState(() {
  //         _errorMessage = e.toString();
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Nursery Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image (Company Logo)
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _companyLogo != null
                          ? FileImage(_companyLogo!) as ImageProvider
                          : (_logoUrl != null && _logoUrl!.isNotEmpty
                                  ? NetworkImage(_logoUrl!)
                                  : const AssetImage(
                                      'asset/image/profile_placeholder.jpg'))
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _pickImage(true),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nursery Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _address = value!,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) =>
                    value!.length < 10 ? 'Invalid number' : null,
                onSaved: (value) => _phone = value!,
              ),

              const SizedBox(height: 10),

              // Change License Button
              ElevatedButton(
                onPressed: () => _pickImage(false),
                child: Text(_companyLicense == null
                    ? 'Change Company License'
                    : 'License Selected'),
              ),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(_errorMessage,
                      style: const TextStyle(color: Colors.red)),
                ),

              const SizedBox(height: 10),

              // Update Profile Button
              ElevatedButton(
                onPressed: _updateNurseryProfile,
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
