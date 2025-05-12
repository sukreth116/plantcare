import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:plantcare/clodinary_upload.dart';

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
            ? await getCloudinaryUrl(_companyLogo!.path) ?? ''
            : _logoUrl ?? '';
        String licenseUrl = _companyLicense != null
            ? await getCloudinaryUrl(_companyLicense!.path) ?? ''
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
        if (mounted) {
          setState(() {
            _errorMessage = e.toString();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Nursery Profile'),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _address = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) =>
                    value!.length < 10 ? 'Invalid number' : null,
                onSaved: (value) => _phone = value!,
              ),

              const SizedBox(height: 20),

              // Change License Button
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tap to upload new License',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickImage(false),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          image: _companyLicense != null
                              ? DecorationImage(
                                  image: FileImage(_companyLicense!),
                                  fit: BoxFit.cover,
                                )
                              : (_licenseUrl != null && _licenseUrl!.isNotEmpty)
                                  ? DecorationImage(
                                      image: NetworkImage(_licenseUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: (_companyLicense == null &&
                                (_licenseUrl == null || _licenseUrl!.isEmpty))
                            ? const Center(
                                child: Text(
                                  'Tap to upload license',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(_errorMessage,
                      style: const TextStyle(color: Colors.red)),
                ),

              const SizedBox(height: 20),

              // Update Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateNurseryProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Change to your desired color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(
                        vertical: 16), // Optional: button height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Optional: rounded corners
                    ),
                  ),
                  child: const Text('Update Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
