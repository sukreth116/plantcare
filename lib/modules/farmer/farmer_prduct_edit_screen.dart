import 'package:flutter/material.dart';

class FarmerEditProductScreen extends StatefulWidget {
  @override
  _FarmerEditProductScreenState createState() =>
      _FarmerEditProductScreenState();
}

class _FarmerEditProductScreenState extends State<FarmerEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Dummy initial values (these should be replaced with real data from database)
  TextEditingController nameController = TextEditingController(text: "Tomato");
  TextEditingController priceController = TextEditingController(text: "20.00");
  TextEditingController quantityController = TextEditingController(text: "50");
  TextEditingController descriptionController = TextEditingController(
      text: "Fresh organic tomatoes, great for salads and cooking.");
  String selectedCategory = "Vegetables";

  final List<String> categories = ["Vegetables", "Fruits", "Nuts", "Legumes"];

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      // Implement update logic (e.g., send data to database)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product Updated Successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image Placeholder
              Center(
                child: Image.asset(
                  'asset/image/tomato.png',
                  height: 200,
                ),
              ),
              SizedBox(height: 10),

              // Product Name
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Product Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a product name" : null,
              ),
              SizedBox(height: 10),

              // Category Dropdown
              DropdownButtonFormField(
                value: selectedCategory,
                decoration: InputDecoration(labelText: "Category"),
                items: categories.map((category) {
                  return DropdownMenuItem(
                      value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value.toString();
                  });
                },
              ),
              SizedBox(height: 10),

              // Price
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a price" : null,
              ),
              SizedBox(height: 10),

              // Quantity
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter quantity" : null,
              ),
              SizedBox(height: 10),

              // Description
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a description" : null,
              ),
              SizedBox(height: 20),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text("Update Product",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
