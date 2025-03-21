import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NurserySignupScreen extends StatefulWidget {
  const NurserySignupScreen({Key? key}) : super(key: key);

  @override
  State<NurserySignupScreen> createState() => _NurserySignupScreenState();
}

class _NurserySignupScreenState extends State<NurserySignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  
  String _name = '';
  String _address = '';
  String _phone = '';
  String _email = '';
  String _password = '';
  File? _companyLogo;
  File? _companyLicense;
  String _errorMessage = '';

  Future<String> uploadToCloudinary(File image) async {
    final url = Uri.parse("https://api.cloudinary.com/v1_1/ds0psaxoc/image/upload");
    final request = http.MultipartRequest("POST", url)
      ..fields["upload_preset"] = "products"
      ..files.add(await http.MultipartFile.fromPath("file", image.path));
    
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return jsonData["secure_url"];
    } else {
      throw Exception("Failed to upload image");
    }
  }

  Future<void> _pickImage(bool isLogo) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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

  void _registerNursery() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        String logoUrl = _companyLogo != null ? await uploadToCloudinary(_companyLogo!) : '';
        String licenseUrl = _companyLicense != null ? await uploadToCloudinary(_companyLicense!) : '';

        await _firestore.collection('nurseries').doc(userCredential.user!.uid).set({
          'nurseryName': _name,
          'email': _email,
          'address': _address,
          'phone': _phone,
          'companyLogoUrl': logoUrl,
          'companyLicenseUrl': licenseUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup Successful')),
        );

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
      appBar: AppBar(title: const Text('Nursery Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nursery Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _address = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value!.length < 10 ? 'Invalid number' : null,
                onSaved: (value) => _phone = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}").hasMatch(value!)
                        ? 'Invalid email'
                        : null,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.length < 6 ? 'Too short' : null,
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _pickImage(true),
                child: Text(_companyLogo == null ? 'Upload Company Logo' : 'Logo Selected'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(false),
                child: Text(_companyLicense == null ? 'Upload Company License' : 'License Selected'),
              ),
              if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _registerNursery,
                child: const Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
