import 'package:flutter/material.dart';
import 'package:plantcare/modules/farmer/farmer_add_prduct_edit_screen.dart';

class FarmerAddProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'asset/image/tomato.png', // Dummy placeholder
                height: 250,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Dummy Product Name",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              "\$99.99",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(height: 2),
            Text(
              "Category: Vegetables",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 2),
            Text(
              "Quantity: 5",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              "This is a dummy description of the product. It includes details about freshness, quality, and storage instructions.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Farmer ID: 12345",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement Edit Functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text("Remove Product",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement Edit Functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FarmerEditProductScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text("Edit Product",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
