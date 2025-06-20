import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantcare/clodinary_upload.dart';

class AddNurseryProduct extends StatefulWidget {
  final String nurseryId;
  const AddNurseryProduct({required this.nurseryId, Key? key})
      : super(key: key);

  @override
  _AddNurseryProductState createState() => _AddNurseryProductState();
}

class _AddNurseryProductState extends State<AddNurseryProduct> {
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  String productDescription = '';
  double productPrice = 0.0;
  File? _imageFile;

  int productQuantity = 0;
  String selectedCategory = 'Plants'; // Default value

  final List<String> categories = [
    'Plants',
    'Seeds',
    'Fertilizers',
    'Pesticide',
    'Pots'
  ];

  String? selectedSubCategory;
  final List<String> plantSubCategories = [
    'Flowering plants',
    'Non-flowering plants',
    'Trees',
    'Shrubs',
    'Herbs',
    'Climbers and Creepers',
    'Succulents',
    'Aquatic plants',
    'Indoor plants',
    'Medicinal plants',
    'Carnivorous plants',
    'Ornamental plants',
  ];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please upload an image")),
        );
        return;
      }

      try {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        String? imageUrl = await getCloudinaryUrl(_imageFile!.path);

        if (!mounted) return;
        Navigator.pop(context); // Close loading dialog

        if (imageUrl == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Image upload failed")),
          );
          return;
        }

        String nurseryId = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance.collection('nursery_products').add({
          'name': productName,
          'category': selectedCategory,
          'subCategory': selectedSubCategory ?? '',
          'price': productPrice,
          'quantity': productQuantity,
          'description': productDescription,
          'nurseryId': nurseryId,
          'imageUrl': imageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product Added Successfully!")),
        );

        Navigator.pop(context); // Go back after success
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add product")),
          );
        }
        print('Error uploading product: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
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
                        'asset/image/cute cactus-pana.png', // Replace with your image URL
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'Add your product like Plants Seeds Pots, Fertilizer etc.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'DugiPundi',
                            color: Colors.green.shade300),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Product Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => productName = value),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onChanged: (value) =>
                      setState(() => productDescription = value),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(
                      () => productPrice = double.tryParse(value) ?? 0.0),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: "Quantity"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(
                      () => productQuantity = int.tryParse(value) ?? 0),
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Category"),
                  value: selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                        selectedSubCategory =
                            null; // Reset sub-category when category changes
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                if (selectedCategory == 'Plants')
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Sub Category"),
                    value: selectedSubCategory,
                    items: plantSubCategories.map((subCat) {
                      return DropdownMenuItem(
                        value: subCat,
                        child: Text(subCat),
                      );
                    }).toList(),
                    validator: (value) {
                      if (selectedCategory == 'Plants' &&
                          (value == null || value.isEmpty)) {
                        return 'Please select a sub-category';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedSubCategory = value;
                      });
                    },
                  ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image, color: Colors.white),
                    label: Text("Upload Image"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[300],
                      foregroundColor: Colors.white,
                      minimumSize: Size(180, 50),
                    ),
                  ),
                ),
                if (_imageFile != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Image.file(
                        _imageFile!,
                        height: 150,
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _uploadProduct,
                    child: Text("Add Product"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300],
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      minimumSize: Size(180, 50),
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
