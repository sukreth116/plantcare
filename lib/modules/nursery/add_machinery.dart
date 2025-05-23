import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary/cloudinary.dart';

class AddMachinery extends StatefulWidget {
  final String nurseryId;
  const AddMachinery({required this.nurseryId, super.key});

  @override
  _AddMachineryState createState() => _AddMachineryState();
}

class _AddMachineryState extends State<AddMachinery> {
  final _formKey = GlobalKey<FormState>();
  String machineryName = '';
  String machineryDescription = '';
  double machineryPrice = 0.0;
  int machineryQuantity = 0;
  String availability = 'Available';
  String? imageUrl;
  File? _selectedImage;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> pickImageAndUpload() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    if (!mounted) return;
    setState(() {
      _selectedImage = File(pickedFile.path);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Uploading image...")),
    );

    final uploadedUrl = await getCloudinaryUrl(pickedFile.path);
    if (!mounted) return;
    if (uploadedUrl != null) {
      setState(() {
        imageUrl = uploadedUrl;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image uploaded successfully!")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed")),
      );
    }
  }

  Future<String?> getCloudinaryUrl(String image) async {
    final cloudinary = Cloudinary.signedConfig(
        cloudName: 'ds0psaxoc',
        apiKey: '467315474851437',
        apiSecret: 'DuxlsUbu1oahxHDkQkzXmggBb7Q');

    final response = await cloudinary.upload(
      file: image,
      resourceType: CloudinaryResourceType.image,
    );
    return response.secureUrl;
  }

  Future<void> _submitMachinery() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload an image')),
      );
      return;
    }

    final String nurseryId = user.uid;

    setState(() => _isLoading = true); // Start loading

    try {
      await _firestore.collection('machinery').add({
        'name': machineryName,
        'description': machineryDescription,
        'price': machineryPrice,
        'quantity': machineryQuantity,
        'availability': availability,
        'nurseryId': nurseryId,
        'imageUrl': imageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Machinery Added Successfully!")),
        );

        _formKey.currentState!.reset();
        setState(() {
          availability = 'Available';
          imageUrl = null;
          _selectedImage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false); // Stop loading
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Machinery'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green.shade300,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'asset/image/farm tractor-pana.png', // Replace with your image URL
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      'Add machinery like Tractors, Tools, Irrigation Equipment, etc. for rental',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'DugiPundi',
                          color: Colors.green.shade300),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: "Machinery Name"),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a machinery name'
                    : null,
                onChanged: (value) => setState(() => machineryName = value),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description'
                    : null,
                onChanged: (value) =>
                    setState(() => machineryDescription = value),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a price';
                  if (double.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
                onChanged: (value) => setState(
                    () => machineryPrice = double.tryParse(value) ?? 0.0),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter quantity';
                  if (int.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
                onChanged: (value) => setState(
                    () => machineryQuantity = int.tryParse(value) ?? 0),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Availability"),
                value: availability,
                items: ['Available', 'Not Available']
                    .map(
                        (val) => DropdownMenuItem(value: val, child: Text(val)))
                    .toList(),
                onChanged: (value) => setState(() => availability = value!),
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: pickImageAndUpload,
                  child: Container(
                    width: 180,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_selectedImage!,
                                fit: BoxFit.fitHeight),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo,
                                  size: 40, color: Colors.green),
                              SizedBox(height: 8),
                              Text("Upload Image",
                                  style: TextStyle(color: Colors.green[700])),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _submitMachinery();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    foregroundColor: Colors.white,
                    minimumSize: Size(180, 50),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text("Add Machinery"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
