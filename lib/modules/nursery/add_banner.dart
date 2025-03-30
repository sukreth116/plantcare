import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPromoBannerScreen extends StatefulWidget {
  @override
  _AddPromoBannerScreenState createState() => _AddPromoBannerScreenState();
}

class _AddPromoBannerScreenState extends State<AddPromoBannerScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      // Process the banner submission (Upload to database/storage)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Promo Banner Submitted!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please complete the form and upload an image.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Promo Banner"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green[300],
        elevation: 3,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                // Title Field
                TextFormField(
                  controller: titleController,
                  validator: (value) => value!.isEmpty ? "Enter a title" : null,
                  decoration: InputDecoration(
                    labelText: 'Promo Title',
                    hintText: "Enter a catchy title",
                    prefixIcon: Icon(Icons.title, color: Colors.green),
                  ),
                ),
                SizedBox(height: 20),

                // Subtitle Field
                TextFormField(
                  controller: subtitleController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter a subtitle" : null,
                  decoration: InputDecoration(
                    labelText: 'Promo Subtitle',
                    hintText: "Enter a short description",
                    prefixIcon: Icon(Icons.subtitles, color: Colors.green),
                  ),
                ),
                SizedBox(height: 20),

                // Image Upload Section
                Text("Upload Image", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload,
                                  size: 50, color: Colors.green),
                              SizedBox(height: 10),
                              Text(
                                "Tap to upload an image",
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 16),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 30),

                // Submit Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: Icon(Icons.send, color: Colors.white),
                    label: Text(
                      "Upload Promo",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
