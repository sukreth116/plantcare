import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerSignupScreen extends StatefulWidget {
  const FarmerSignupScreen({Key? key}) : super(key: key);

  @override
  State<FarmerSignupScreen> createState() => _FarmerSignupScreenState();
}

class _FarmerSignupScreenState extends State<FarmerSignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance; // Initialize Firestore
  final _formKey = GlobalKey<FormState>();

  // Input fields
  String _email = '';
  String _password = '';
  String _name = '';
  String _address = '';
  String _phoneNumber = '';
  String _farmerIdProof = '';
  String _errorMessage = '';

  void _registerFarmer() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Register with Firebase Authentication
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Store farmer details in Firestore
        await _firestore
            .collection('farmers')
            .doc(userCredential.user!.uid)
            .set({
          'name': _name,
          'email': _email,
          'address': _address,
          'phone': _phoneNumber,
          'farmerIdProof': _farmerIdProof,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup Successful')),
        );

        // Clear the form
        _formKey.currentState!.reset();
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message ?? 'An error occurred';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'GREENIFY - Farmer Signup',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Create Account For Farmer',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),

              // Name Field
              const Text("Full Name"),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Enter your full name",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),

              // Email Field

              const Text("Email Address"),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Enter your email address",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                          .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 16),

              // Password Field
              const Text("Password"),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Create a password",
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 16),

              // Address Field
              const Text("Address"),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Enter your address",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address cannot be empty';
                  }
                  return null;
                },
                onSaved: (value) => _address = value!,
              ),
              const SizedBox(height: 16),

              // Phone Field
              const Text("Phone Number"),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Enter your phone number",
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.length < 10) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
                onSaved: (value) => _phoneNumber = value!,
              ),
              const SizedBox(height: 16),

              // Farmer ID Proof Field
              const Text("Farmer ID Proof"),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.badge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Enter your farmer ID proof",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Farmer ID proof is required';
                  }
                  return null;
                },
                onSaved: (value) => _farmerIdProof = value!,
              ),
              const SizedBox(height: 24),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),

              // Signup Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _registerFarmer,
                  child: const Text(
                    "Signup",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
