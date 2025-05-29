import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:plantcare/clodinary_upload.dart'; // Cloudinary upload

class NurseryWorkerSignupScreen extends StatefulWidget {
  const NurseryWorkerSignupScreen({Key? key}) : super(key: key);

  @override
  _NurseryWorkerSignupScreenState createState() =>
      _NurseryWorkerSignupScreenState();
}

class _NurseryWorkerSignupScreenState extends State<NurseryWorkerSignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _workerIdController =
      TextEditingController(); // New field for worker ID

  String? _selectedNurseryId; // Store selected nursery ID
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String _errorMessage = '';
  File? _profileImage;
  File? _idProofImage;
  List<Map<String, String>> _nurseries = []; // List to hold nurseries

  // Fetch nurseries from Firestore
  Future<void> _fetchNurseries() async {
    try {
      final nurseryQuery = await _firestore.collection('nurseries').get();
      setState(() {
        _nurseries = nurseryQuery.docs.map((doc) {
          return {
            'nurseryId': doc.id,
            'nurseryName': (doc['nurseryName'] ?? 'Unnamed Nursery')
                .toString(), // Ensure it's a string
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching nurseries: $e");
    }
  }

// Image picker for profile photo
  Future<void> _pickProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Image picker for ID proof
  Future<void> _pickIdProofImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _idProofImage = File(pickedFile.path);
      });
    }
  }

  // Upload image to Cloudinary
  Future<String?> _uploadImage(File image) async {
    try {
      // Use your existing Cloudinary function
      return await getCloudinaryUrl(image.path);
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNurseries();
  }

  Future<void> _registerWorker() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    if (_selectedNurseryId == null) {
      setState(() {
        _errorMessage = 'Please select a nursery';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      if (_profileImage == null) {
        setState(() {
          _errorMessage = 'Please upload a profile photo.';
        });
        return;
      }
      final profileImageUrl =
          _profileImage != null ? await _uploadImage(_profileImage!) : null;
      final idProofImageUrl =
          _idProofImage != null ? await _uploadImage(_idProofImage!) : null;

      // Create user account
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save worker data to Firestore
      await _firestore
          .collection('nursery_workers')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'workerIdNumber': _workerIdController.text.trim(),
        'nurseryId': _selectedNurseryId, // Storing selected nursery ID
        'profileImageUrl': profileImageUrl,
        'idProofImageUrl': idProofImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'isApproved': false
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup Successful!')),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred during registration';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _workerIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                'asset/image/Nursery-Worker (2).png',
                height: 200,
              ),
              const Text(
                "Create Your Account",
                style: TextStyle(
                  color: Colors.green,
                  fontFamily: 'Milky',
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickProfileImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green[100],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? const Icon(Icons.add_a_photo,
                                size: 40, color: Colors.green)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _profileImage == null
                          ? 'Add Profile Picture (Required)'
                          : 'Profile Picture Selected',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    _buildTextField(_nameController, 'Full Name', Icons.person),
                    _buildTextField(_emailController, 'Email', Icons.email,
                        keyboardType: TextInputType.emailAddress),
                    _buildPasswordField(),
                    _buildConfirmPasswordField(),
                    _buildTextField(_addressController, 'Address', Icons.home),
                    _buildTextField(
                        _phoneController, 'Phone Number', Icons.phone,
                        keyboardType: TextInputType.phone),
                    _buildTextField(_workerIdController, 'Worker ID',
                        Icons.card_membership),

                    // Nursery Selection Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedNurseryId,
                      hint: Text('Select Nursery'),
                      items: _nurseries.map((nursery) {
                        return DropdownMenuItem<String>(
                          value: nursery['nurseryId'],
                          child: Text(nursery['nurseryName']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedNurseryId = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.business, color: Colors.green),
                        filled: true,
                        fillColor: Colors.green[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: _pickIdProofImage,
                      child: Container(
                        width: 350,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(30),
                          image: _idProofImage != null
                              ? DecorationImage(
                                  image: FileImage(_idProofImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _idProofImage == null
                            ? const Center(
                                child: Icon(Icons.add_a_photo,
                                    size: 40, color: Colors.green))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _idProofImage == null
                          ? 'Add ID Proof (Required)'
                          : 'ID Proof Selected',
                      style: TextStyle(color: Colors.grey[600]),
                    ),

                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.green)
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _registerWorker,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'SIGN UP',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.green),
          hintText: hint,
          filled: true,
          fillColor: Colors.green[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$hint is required';
          }
          if (hint == 'Email' && !value.contains('@')) {
            return 'Please enter a valid email';
          }
          if (hint == 'Phone Number' && value.length < 10) {
            return 'Please enter a valid phone number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock, color: Colors.green),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.green,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          hintText: 'Password',
          filled: true,
          fillColor: Colors.green[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.length < 6) {
            return 'Password must be at least 6 characters long';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscureConfirmPassword,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.green,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          hintText: 'Confirm Password',
          filled: true,
          fillColor: Colors.green[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }
}
