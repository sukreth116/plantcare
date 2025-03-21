import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedCategory;
  File? _image;

  final List<String> categories = [
    'Vegetables',
    'Fruits',
    'Nuts',
    'Legumes',
    'Tubers',
    'Seeds'
  ];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select a category")),
        );
        return;
      }
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please upload an image")),
        );
        return;
      }
      // Process form submission
      print("Product Added: ${nameController.text}");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product"), backgroundColor: Colors.teal),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Product Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter product name" : null,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(labelText: "Category"),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Select a category" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Price"),
                  validator: (value) => value!.isEmpty ? "Enter price" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Quantity"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter quantity" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter description" : null,
                ),
                SizedBox(height: 10),
                _image == null
                    ? Text("No image selected")
                    : Image.file(_image!, height: 150),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.image),
                  label: Text("Pick an Image"),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text("Submit"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal),
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
