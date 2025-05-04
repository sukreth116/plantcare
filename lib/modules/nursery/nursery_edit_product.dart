import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/clodinary_upload.dart';
import 'package:image_picker/image_picker.dart';

class EditNurseryProduct extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  const EditNurseryProduct({
    required this.productId,
    required this.productData,
    Key? key,
  }) : super(key: key);

  @override
  State<EditNurseryProduct> createState() => _EditNurseryProductState();
}

class _EditNurseryProductState extends State<EditNurseryProduct> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late String _category;
  late String _subCategory;
  bool _isLoading = false;
  late String _imageUrl; // Variable to store the image URL
  bool _isImageSelected = false;
  late XFile? _imageFile;

  final List<String> _categories = [
    'Plants',
    'Seeds',
    'Pots',
    'Fertilizers',
    'Pesticides',
  ];

  final List<String> _subCategories = [
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productData['name']);
    _descriptionController =
        TextEditingController(text: widget.productData['description']);
    _priceController =
        TextEditingController(text: widget.productData['price'].toString());
    _quantityController =
        TextEditingController(text: widget.productData['quantity'].toString());
    _category = widget.productData['category'] ?? '';
    _subCategory = widget.productData['subCategory'] ?? '';
    _imageUrl = widget.productData['imageUrl'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
        _isImageSelected = true;
      });
    }
  }

  // Function to upload the image using Cloudinary
  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    try {
      // Call your Cloudinary function to upload the image
      String? imageUrl = await getCloudinaryUrl(_imageFile!.path);
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
      return null;
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;
      if (_isImageSelected) {
        imageUrl = await _uploadImage(); // Upload the image and get the URL
      }
      await FirebaseFirestore.instance
          .collection('nursery_products')
          .doc(widget.productId)
          .update({
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'quantity': int.parse(_quantityController.text.trim()),
        'category': _category,
        'subCategory': _category == 'Plants' ? _subCategory : '',
        'updatedAt': Timestamp.now(),
        'imageUrl': imageUrl ?? _imageUrl,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating product: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Colors.green.shade300,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: 'Product Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter product name' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter description' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(labelText: 'Price'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter price' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Quantity'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter quantity' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _category.isNotEmpty ? _category : null,
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _category = value!;
                            if (_category != 'Plants') {
                              _subCategory = '';
                            }
                          });
                        },
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        validator: (value) =>
                            value == null ? 'Please select category' : null,
                      ),
                      const SizedBox(height: 16),
                      if (_category == 'Plants')
                        DropdownButtonFormField<String>(
                          value: _subCategory.isNotEmpty ? _subCategory : null,
                          items: _subCategories.map((subCategory) {
                            return DropdownMenuItem(
                              value: subCategory,
                              child: Text(subCategory),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _subCategory = value!;
                            });
                          },
                          decoration:
                              const InputDecoration(labelText: 'Sub-Category'),
                          validator: (value) => value == null
                              ? 'Please select sub-category'
                              : null,
                        ),
                      const SizedBox(height: 10),
                      // Add Image section
                      _isImageSelected
                          ? Image.file(
                              File(_imageFile!.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : _imageUrl.isNotEmpty
                              ? Image.network(
                                  _imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image, size: 100),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Change Image'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _updateProduct,
                        child: const Text('Update Product'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
