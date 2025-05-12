import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantcare/clodinary_upload.dart';

class WorkerProfileEditScreen extends StatefulWidget {
  final String workerId;

  const WorkerProfileEditScreen({Key? key, required this.workerId})
      : super(key: key);

  @override
  _WorkerProfileEditScreenState createState() =>
      _WorkerProfileEditScreenState();
}

class _WorkerProfileEditScreenState extends State<WorkerProfileEditScreen> {
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
    DocumentSnapshot workerDoc = await FirebaseFirestore.instance
        .collection('nursery_workers')
        .doc(widget.workerId)
        .get();

    if (workerDoc.exists) {
      var data = workerDoc.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _addressController.text = data['address'] ?? '';
        _idCardNumberController.text = data['workerIdNumber'] ?? '';
        _idCardImageUrl = data['idProofImageUrl'];
        _profilePhotoUrl = data['profileImageUrl'];
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

  Future<void> _updateWorkerProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null && user.email != _emailController.text) {
          String password = await _getPasswordFromWorker();
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
            .collection('nursery_workers')
            .doc(widget.workerId)
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<String> _getPasswordFromWorker() async {
    return 'worker-password-here'; // Replace with actual input dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
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
                      onPressed: _isLoading ? null : _updateWorkerProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade300,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Update Profile',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
