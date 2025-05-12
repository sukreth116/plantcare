// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserSignupScreen extends StatefulWidget {
//   const UserSignupScreen({Key? key}) : super(key: key);

//   @override
//   State<UserSignupScreen> createState() => _UserSignupScreenState();
// }

// class _UserSignupScreenState extends State<UserSignupScreen> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   bool _obscurePassword = true;
//   bool _isLoading = false;
//   String _errorMessage = '';

//   void _registerUser() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'address': _addressController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Signup Successful!')),
//       );

//       Navigator.pop(context);
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _errorMessage = e.message ?? 'An error occurred';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 2),
//               Image.asset(
//                 'asset/image/Blooming-cuate.png',
//                 height: 200,
//               ),
//               const SizedBox(height: 2),
//               const Text(
//                 "Create Your Account",
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontFamily: 'Milky',
//                   fontSize: 22,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     _buildTextField(_nameController, 'Full Name', Icons.person),
//                     _buildTextField(_emailController, 'Email', Icons.email,
//                         keyboardType: TextInputType.emailAddress),
//                     _buildPasswordField(),
//                     _buildTextField(_addressController, 'Address', Icons.home),
//                     _buildTextField(
//                         _phoneController, 'Phone Number', Icons.phone,
//                         keyboardType: TextInputType.phone),
//                     const SizedBox(height: 16.0),
//                     _isLoading
//                         ? const CircularProgressIndicator(color: Colors.green)
//                         : SizedBox(
//                             width: double.infinity,
//                             height: 50,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green[300],
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                               onPressed: _registerUser,
//                               child: const Text(
//                                 'SIGN UP',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                     const SizedBox(height: 16.0),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       TextEditingController controller, String hint, IconData icon,
//       {TextInputType keyboardType = TextInputType.text}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.green),
//           hintText: hint,
//           filled: true,
//           fillColor: Colors.green[100],
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         validator: (value) {
//           if (value == null || value.trim().isEmpty) {
//             return '$hint is required';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _buildPasswordField() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: _passwordController,
//         obscureText: _obscurePassword,
//         decoration: InputDecoration(
//           prefixIcon: const Icon(Icons.lock, color: Colors.green),
//           suffixIcon: IconButton(
//             icon: Icon(
//               _obscurePassword ? Icons.visibility : Icons.visibility_off,
//               color: Colors.green,
//             ),
//             onPressed: () {
//               setState(() {
//                 _obscurePassword = !_obscurePassword;
//               });
//             },
//           ),
//           hintText: 'Password',
//           filled: true,
//           fillColor: Colors.green[100],
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         validator: (value) {
//           if (value == null || value.length < 6) {
//             return 'Password must be at least 6 characters long';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:plantcare/clodinary_upload.dart'; // Import your Cloudinary function

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({Key? key}) : super(key: key);

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
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

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String _errorMessage = '';
  File? _profileImage;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_profileImage == null) return null;

    try {
      // Use your existing Cloudinary function
      return await getCloudinaryUrl(_profileImage!.path);
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
      return null;
    }
  }

  void _registerUser() async {
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
      // First upload image if selected
      final imageUrl = await _uploadImage();

      // Then create user account
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'profileImageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'isApproved': false,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 2),
              Image.asset(
                'asset/image/personal growth-pana.png',
                height: 200,
              ),
              const SizedBox(height: 2),
              const Text(
                "Create Your Account",
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
                    // Profile Picture Upload
                    GestureDetector(
                      onTap: _pickImage,
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
                          ? 'Add Profile Picture (Optional)'
                          : 'Profile Picture Selected',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(_nameController, 'Full Name', Icons.person),
                    _buildTextField(_emailController, 'Email', Icons.email,
                        keyboardType: TextInputType.emailAddress),
                    _buildPasswordField(),
                    _buildConfirmPasswordField(),
                    _buildTextField(_addressController, 'Address', Icons.home),
                    _buildTextField(
                        _phoneController, 'Phone Number', Icons.phone,
                        keyboardType: TextInputType.phone),

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
                              onPressed: _registerUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'SIGN UP',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
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
