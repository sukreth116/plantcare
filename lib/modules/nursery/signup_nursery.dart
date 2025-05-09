import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:plantcare/clodinary_upload.dart';

class NurserySignupScreen extends StatefulWidget {
  const NurserySignupScreen({Key? key}) : super(key: key);

  @override
  State<NurserySignupScreen> createState() => _NurserySignupScreenState();
}

class _NurserySignupScreenState extends State<NurserySignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String _errorMessage = '';
  File? _companyLogo;
  File? _licenseImage;

  Future<void> _pickLogoImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _companyLogo = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickLicenseImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _licenseImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      return await getCloudinaryUrl(image.path);
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }

  void _registerNursery() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final logoUrl =
          _companyLogo != null ? await _uploadImage(_companyLogo!) : null;
      final licenseUrl =
          _licenseImage != null ? await _uploadImage(_licenseImage!) : null;

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore
          .collection('nurseries')
          .doc(userCredential.user!.uid)
          .set({
        'nurseryName': _companyNameController.text.trim(),
        'email': _emailController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'companyLogoUrl': logoUrl,
        'companyLicenseUrl': licenseUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'isApproved': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup Successful!')),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Registration error';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Unexpected error: ${e.toString()}';
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
    _companyNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
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
              Image.asset('asset/image/Nursery.png', height: 200),
              const SizedBox(height: 2),
              const Text(
                "Register Your Nursery",
                style: TextStyle(
                  color: Colors.green,
                  fontFamily: 'Milky',
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Company Logo
                    GestureDetector(
                      onTap: _pickLogoImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green[100],
                        backgroundImage: _companyLogo != null
                            ? FileImage(_companyLogo!)
                            : null,
                        child: _companyLogo == null
                            ? const Icon(Icons.add_a_photo,
                                size: 40, color: Colors.green)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _companyLogo == null
                          ? 'Add Company Logo (Optional)'
                          : 'Logo Selected',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                        _companyNameController, 'Company Name', Icons.business),
                    _buildTextField(_emailController, 'Email', Icons.email,
                        keyboardType: TextInputType.emailAddress),
                    _buildPasswordField(),
                    _buildConfirmPasswordField(),
                    _buildTextField(_addressController, 'Address', Icons.home),
                    _buildTextField(
                        _phoneController, 'Phone Number', Icons.phone,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 5),

                    // License Image
                    GestureDetector(
                      onTap: _pickLicenseImage,
                      child: Container(
                        width: 350,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(30),
                          image: _licenseImage != null
                              ? DecorationImage(
                                  image: FileImage(_licenseImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _licenseImage == null
                            ? const Center(
                                child: Icon(Icons.add_a_photo,
                                    size: 40, color: Colors.green),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _licenseImage == null
                          ? 'Add Company License Image (Required)'
                          : 'License Image Selected',
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
                              onPressed: _registerNursery,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('SIGN UP',
                                  style: TextStyle(color: Colors.white)),
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
          if (value == null || value.trim().isEmpty) return '$hint is required';
          if (hint == 'Email' && !value.contains('@'))
            return 'Enter a valid email';
          if (hint == 'Phone Number' && value.length < 10)
            return 'Enter a valid phone number';
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
            return 'Password must be at least 6 characters';
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
          if (value == null || value.isEmpty)
            return 'Please confirm your password';
          if (value != _passwordController.text)
            return 'Passwords do not match';
          return null;
        },
      ),
    );
  }
}
