import 'package:flutter/material.dart';

class AddNurseryProduct extends StatefulWidget {
  @override
  _AddNurseryProductState createState() => _AddNurseryProductState();
}

class _AddNurseryProductState extends State<AddNurseryProduct> {
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  String productDescription = '';
  double productPrice = 0.0;
  String? imagePath; // For storing the image path (to be implemented)
  int productQuantity = 0;

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
                  SizedBox(
                    height: 20,
                  ),
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
                    decoration: InputDecoration(
                      labelText: "Product Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        productName = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Description",
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        productDescription = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Price",
                    ),
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
                    onChanged: (value) {
                      setState(() {
                        productPrice = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Quantity",
                    ),
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
                    onChanged: (value) {
                      setState(() {
                        productQuantity = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Implement image picker functionality
                      },
                      icon: Icon(Icons.image,
                          color: Colors.white), // Ensures icon color is white
                      label: Text("Upload Image"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[300],
                        foregroundColor:
                            Colors.white, // Changes text color to white
                        minimumSize: Size(180, 50),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission (save product details)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Product Added Successfully!")),
                          );
                        }
                      },
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
        ));
  }
}
