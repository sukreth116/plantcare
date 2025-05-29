// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:plantcare/clodinary_upload.dart';

// class FarmerSignupScreen extends StatefulWidget {
//   const FarmerSignupScreen({Key? key}) : super(key: key);

//   @override
//   State<FarmerSignupScreen> createState() => _FarmerSignupScreenState();
// }

// class _FarmerSignupScreenState extends State<FarmerSignupScreen> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   bool _isPasswordVisible = false;

//   String _email = '';
//   String _password = '';
//   String _confirmPassword = '';
//   String _name = '';
//   String _address = '';
//   String _phoneNumber = '';
//   String _errorMessage = '';
//   bool _isLoading = false;

//   File? _idProofImage;
//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickProfileImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _pickIdProofImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _idProofImage = File(pickedFile.path);
//       });
//     }
//   }

//   void _registerFarmer() async {
//     if (_formKey.currentState!.validate()) {
//       if (_idProofImage == null) {
//         setState(() {
//           _errorMessage = 'Please upload your Farmer ID Proof image';
//         });
//         return;
//       }

//       _formKey.currentState!.save();
//       setState(() {
//         _isLoading = true;
//         _errorMessage = '';
//       });

//       try {
//         UserCredential userCredential =
//             await _auth.createUserWithEmailAndPassword(
//           email: _email,
//           password: _password,
//         );

//         // Upload images
//         String idProofUrl = await getCloudinaryUrl(_idProofImage!.path) ?? '';
//         String? profilePhotoUrl;

//         if (_profileImage != null) {
//           profilePhotoUrl = await getCloudinaryUrl(_profileImage!.path);
//         }

//         await _firestore
//             .collection('farmers')
//             .doc(userCredential.user!.uid)
//             .set({
//           'name': _name,
//           'email': _email,
//           'address': _address,
//           'phone': _phoneNumber,
//           'farmerIdProof': idProofUrl,
//           'profilePhoto': profilePhotoUrl ?? '',
//           'createdAt': FieldValue.serverTimestamp(),
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Signup Successful')),
//         );

//         _formKey.currentState!.reset();
//         setState(() {
//           _idProofImage = null;
//           _profileImage = null;
//         });
//       } on FirebaseAuthException catch (e) {
//         setState(() {
//           _errorMessage = e.message ?? 'An error occurred';
//         });
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),
//                 Image.asset(
//                   'asset/image/Blooming-cuate.png',
//                   height: 200,
//                 ),

//                 Text(
//                   'Create your Account',
//                   style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                       color: Colors.yellow.shade700,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Milky'),
//                 ),
//                 const SizedBox(height: 16),
//                 Stack(
//                   alignment: Alignment.bottomRight,
//                   children: [
//                     GestureDetector(
//                       onTap: _pickProfileImage,
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.green[100],
//                         backgroundImage: _profileImage != null
//                             ? FileImage(_profileImage!)
//                             : null,
//                         child: _profileImage == null
//                             ? const Icon(Icons.add_a_photo,
//                                 size: 40, color: Colors.green)
//                             : null,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   _profileImage == null
//                       ? 'Add Profile Picture (Optional)'
//                       : 'Profile Picture Selected',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),

//                 const SizedBox(height: 10),

//                 // 👤 Name
//                 TextFormField(
//                   decoration: _inputDecoration(
//                       icon: Icons.person, hintText: "Enter your full name"),
//                   validator: (value) => value == null || value.trim().isEmpty
//                       ? 'Name is required'
//                       : null,
//                   onSaved: (value) => _name = value!,
//                 ),
//                 const SizedBox(height: 16),

//                 // 📧 Email
//                 TextFormField(
//                   decoration: _inputDecoration(
//                       icon: Icons.email, hintText: "Enter your email address"),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null ||
//                         !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
//                             .hasMatch(value)) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) => _email = value!,
//                 ),
//                 const SizedBox(height: 16),

//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: !_isPasswordVisible,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.green.shade100,
//                     prefixIcon:
//                         const Icon(Icons.lock_outline, color: Colors.green),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: Colors.green,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible =
//                               !_isPasswordVisible; // Toggle visibility
//                         });
//                       },
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                       borderSide: BorderSide.none,
//                     ),
//                     hintText: "Enter your password",
//                     hintStyle: const TextStyle(color: Colors.grey),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Password is required';
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 // Confirm Password Field
//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   obscureText: !_isPasswordVisible,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.green.shade100,
//                     prefixIcon:
//                         const Icon(Icons.lock_outline, color: Colors.green),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: Colors.green,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible =
//                               !_isPasswordVisible; // Toggle visibility
//                         });
//                       },
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                       borderSide: BorderSide.none,
//                     ),
//                     hintText: "Confirm your password",
//                     hintStyle: const TextStyle(color: Colors.grey),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Confirm password is required';
//                     } else if (value != _passwordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 16),

//                 TextFormField(
//                   decoration: _inputDecoration(
//                       icon: Icons.home, hintText: "Enter your address"),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Address cannot be empty'
//                       : null,
//                   onSaved: (value) => _address = value!,
//                 ),
//                 const SizedBox(height: 16),

//                 // 📱 Phone Number
//                 TextFormField(
//                   decoration: _inputDecoration(
//                       icon: Icons.phone, hintText: "Enter your phone number"),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) => value == null || value.length < 10
//                       ? 'Enter a valid phone number'
//                       : null,
//                   onSaved: (value) => _phoneNumber = value!,
//                 ),
//                 const SizedBox(height: 16),

//                 // 📄 Farmer ID Proof Upload
//                 const Text("Farmer ID Proof"),
//                 const SizedBox(height: 8),
//                 GestureDetector(
//                   onTap: _pickIdProofImage,
//                   child: Container(
//                     height: 150,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(12),
//                       color: Colors.green.shade50,
//                     ),
//                     child: _idProofImage != null
//                         ? ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child:
//                                 Image.file(_idProofImage!, fit: BoxFit.cover),
//                           )
//                         : const Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.cloud_upload,
//                                     size: 40, color: Colors.green),
//                                 Text("Tap to upload ID proof image"),
//                               ],
//                             ),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 if (_errorMessage.isNotEmpty)
//                   Text(_errorMessage,
//                       style: const TextStyle(color: Colors.red)),

//                 _isLoading
//                     ? const Center(
//                         child: CircularProgressIndicator(color: Colors.green))
//                     : SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: _registerFarmer,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green[300],
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           child: const Text(
//                             'SIGN UP',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(
//       {required IconData icon, required String hintText}) {
//     return InputDecoration(
//       prefixIcon: Icon(icon, color: Colors.green),
//       filled: true,
//       fillColor: Colors.green.shade100,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30.0),
//         borderSide: BorderSide.none,
//       ),
//       hintText: hintText,
//       hintStyle: const TextStyle(color: Colors.grey),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:plantcare/clodinary_upload.dart'; // Import your Cloudinary function

class FarmerSignupScreen extends StatefulWidget {
  const FarmerSignupScreen({Key? key}) : super(key: key);

  @override
  State<FarmerSignupScreen> createState() => _FarmerSignupScreenState();
}

class _FarmerSignupScreenState extends State<FarmerSignupScreen> {
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
  final TextEditingController _farmerIdController =
      TextEditingController(); // New field for farmer ID

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String _errorMessage = '';
  File? _profileImage;
  File? _farmerIdCardImage; // New variable for the farmer's ID card

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickFarmerIdCardImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _farmerIdCardImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      // Use your existing Cloudinary function
      return await getCloudinaryUrl(image.path);
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
      return null;
    }
  }

  void _registerFarmer() async {
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
      // First upload images if selected
      final profileImageUrl = await _uploadImage(_profileImage!);
      final farmerIdImageUrl = _farmerIdCardImage != null
          ? await _uploadImage(_farmerIdCardImage!)
          : null;

      // Then create user account
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save farmer data to Firestore
      await _firestore.collection('farmers').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'profilePhotoUrl': profileImageUrl,
        'idCardImageUrl': farmerIdImageUrl,
        'idCardNumber': _farmerIdController.text.trim(), // Storing farmer ID
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
    _farmerIdController.dispose(); // Dispose the farmer ID controller
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
                'asset/image/Cactus lover-pana.png',
                height: 200,
              ),
              const SizedBox(height: 2),
              const Text(
                "Register As Farmer",
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
                    _buildTextField(_farmerIdController, 'ID Proof Number',
                        Icons.card_membership),
                    const SizedBox(height: 5),

                    // Farmer ID Card Upload
                    GestureDetector(
                      onTap: _pickFarmerIdCardImage,
                      child: Container(
                        width: 350,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(
                              30), // Slightly rounded corners
                          image: _farmerIdCardImage != null
                              ? DecorationImage(
                                  image: FileImage(_farmerIdCardImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _farmerIdCardImage == null
                            ? const Center(
                                child: Icon(Icons.add_a_photo,
                                    size: 40, color: Colors.green),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _farmerIdCardImage == null
                          ? 'Add Farmer ID Card (Required)'
                          : 'Farmer ID Card Selected',
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
                              onPressed: _registerFarmer,
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
