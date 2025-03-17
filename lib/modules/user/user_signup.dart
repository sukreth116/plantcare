import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({Key? key}) : super(key: key);

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String _errorMessage = '';

  void _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup Successful!')),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'asset/image/Reforestation-pana.png',
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                "Create Your Account",
                style: TextStyle(
                  color: Colors.green,
                  fontFamily: 'Pacifico',
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_nameController, 'Full Name', Icons.person),
                    _buildTextField(_emailController, 'Email', Icons.email,
                        keyboardType: TextInputType.emailAddress),
                    _buildPasswordField(),
                    _buildTextField(_addressController, 'Address', Icons.home),
                    _buildTextField(
                        _phoneController, 'Phone Number', Icons.phone,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 16.0),
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.green)
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: _registerUser,
                              child: const Text(
                                'SIGN UP',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                    const SizedBox(height: 16.0),
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
}
