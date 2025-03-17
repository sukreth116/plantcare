import 'package:flutter/material.dart';

class FarmerProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'asset/image/plant_sample_1.png',
                height: 250,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Product Name",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              "\$199.99",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(Icons.star, color: Colors.amber);
                  }),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () {
                    // Add favorite functionality here
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "This is a detailed description of the product. It includes features, specifications, and other details.",
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text("Add to Cart",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
