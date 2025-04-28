// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:plantcare/clodinary_upload.dart';

// class AddNurseryProduct extends StatefulWidget {
//   final String nurseryId;
//   const AddNurseryProduct({required this.nurseryId, Key? key})
//       : super(key: key);

//   @override
//   _AddNurseryProductState createState() => _AddNurseryProductState();
// }

// class _AddNurseryProductState extends State<AddNurseryProduct> {
//   final _formKey = GlobalKey<FormState>();
//   String productName = '';
//   String productDescription = '';
//   double productPrice = 0.0;
//   File? _imageFile; // Updated to File
//   int productQuantity = 0;
//   String selectedCategory = 'Plants'; // Default value

//   final List<String> categories = [
//     'Plants',
//     'Seeds',
//     'Fertilizers',
//     'Pesticide',
//     'Pots'
//   ];

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   void _uploadProduct() async {
//     if (_formKey.currentState!.validate()) {
//       if (selectedCategory == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Please select a category")),
//         );
//         return;
//       }
//       if (_imageFile == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Please upload an image")),
//         );
//         return;
//       }

//       try {
//         // 1. Upload image to Cloudinary
//         String? imageUrl = await getCloudinaryUrl(_imageFile!.path);

//         if (imageUrl == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Image upload failed")),
//           );
//           return;
//         }

//         String nurseryId = FirebaseAuth.instance.currentUser!.uid;

//         // 2. Upload product details to Firestore
//         await FirebaseFirestore.instance.collection('nursery_products').add({
//           'name': productName,
//           'category': selectedCategory,
//           'price': productPrice,
//           'quantity': productQuantity,
//           'description': productDescription,
//           'nurseryId': nurseryId,
//           'imageUrl': imageUrl,
//           'createdAt': FieldValue.serverTimestamp(),
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Product Added Successfully!")),
//         );

//         Navigator.pop(context);
//       } catch (e) {
//         print('Error uploading product: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to add product")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20),
//                 Center(
//                   child: Text(
//                     'Add Product',
//                     style: TextStyle(
//                       fontSize: 40,
//                       fontFamily: 'Pinkish',
//                       color: Colors.orange,
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Text(
//                     'Add your product like Plants, Seed, Pots, Fertilizer etc.',
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: "Product Name"),
//                   validator: (value) {
//                     if (value == null || value.isEmpty)
//                       return 'Please enter a product name';
//                     return null;
//                   },
//                   onChanged: (value) => setState(() => productName = value),
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: "Description"),
//                   maxLines: 3,
//                   validator: (value) {
//                     if (value == null || value.isEmpty)
//                       return 'Please enter a description';
//                     return null;
//                   },
//                   onChanged: (value) =>
//                       setState(() => productDescription = value),
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: "Price"),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty)
//                       return 'Please enter a price';
//                     if (double.tryParse(value) == null)
//                       return 'Enter a valid number';
//                     return null;
//                   },
//                   onChanged: (value) => setState(
//                       () => productPrice = double.tryParse(value) ?? 0.0),
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: "Quantity"),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty)
//                       return 'Please enter quantity';
//                     if (int.tryParse(value) == null)
//                       return 'Enter a valid number';
//                     return null;
//                   },
//                   onChanged: (value) => setState(
//                       () => productQuantity = int.tryParse(value) ?? 0),
//                 ),
//                 SizedBox(height: 20),
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(labelText: "Category"),
//                   value: selectedCategory,
//                   items: categories.map((category) {
//                     return DropdownMenuItem(
//                       value: category,
//                       child: Text(category),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       setState(() {
//                         selectedCategory = value;
//                       });
//                     }
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton.icon(
//                     onPressed: _pickImage,
//                     icon: Icon(Icons.image, color: Colors.white),
//                     label: Text("Upload Image"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange[300],
//                       foregroundColor: Colors.white,
//                       minimumSize: Size(180, 50),
//                     ),
//                   ),
//                 ),
//                 if (_imageFile != null)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: Image.file(
//                         _imageFile!,
//                         height: 150,
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: _uploadProduct,
//                     child: Text("Add Product"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green[300],
//                       foregroundColor: Colors.white,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                       minimumSize: Size(180, 50),
//                     ),
//                   ),

//                 ),

//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Future<void> _uploadProduct() async {
  //   if (_formKey.currentState!.validate()) {
  //     if (_imageFile == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Please upload an image")),
  //       );
  //       return;
  //     }

  //     try {
  //       // Show loading dialog
  //       showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         },
  //       );

  //       // 1. Upload image to Cloudinary
  //       String? imageUrl = await getCloudinaryUrl(_imageFile!.path);

  //       if (imageUrl == null) {
  //         Navigator.pop(context); // Close loading
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("Image upload failed")),
  //         );
  //         return;
  //       }

  //       String nurseryId = FirebaseAuth.instance.currentUser!.uid;

  //       // 2. Upload product details to Firestore
  //       await FirebaseFirestore.instance.collection('nursery_products').add({
  //         'name': productName,
  //         'category': selectedCategory,
  //         'price': productPrice,
  //         'quantity': productQuantity,
  //         'description': productDescription,
  //         'nurseryId': nurseryId,
  //         'imageUrl': imageUrl,
  //         'createdAt': FieldValue.serverTimestamp(),
  //       });

  //       Navigator.pop(context); // Close loading

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Product Added Successfully!")),
  //       );

  //       Navigator.pop(context); // Go back after success
  //     } catch (e) {
  //       Navigator.pop(context); // Close loading
  //       print('Error uploading product: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Failed to add product")),
  //       );
  //     }
  //   }
  // }
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Pinkish',
                      color: Colors.orange,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Add your product like Plants, Seed, Pots, Fertilizer etc.',
                    textAlign: TextAlign.center,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Product Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter a product name';
                    return null;
                  },
                  onChanged: (value) => setState(() => productName = value),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter a description';
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
                    if (value == null || value.isEmpty)
                      return 'Please enter a price';
                    if (double.tryParse(value) == null)
                      return 'Enter a valid number';
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
                    if (value == null || value.isEmpty)
                      return 'Please enter quantity';
                    if (int.tryParse(value) == null)
                      return 'Enter a valid number';
                    return null;
                  },
                  onChanged: (value) => setState(
                      () => productQuantity = int.tryParse(value) ?? 0),
                ),
                SizedBox(height: 20),
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
                      });
                    }
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
