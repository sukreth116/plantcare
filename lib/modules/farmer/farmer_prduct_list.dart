import 'package:flutter/material.dart';
import 'package:plantcare/modules/farmer/farmer_product_details_screen.dart';

class ViewProductsScreen extends StatefulWidget {
  @override
  _ViewProductsScreenState createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
  List<Map<String, dynamic>> products = [
    {
      "name": "Fresh Tomatoes",
      "category": "Vegetables",
      "price": 10.99,
      "quantity": 50,
      "image": "asset/image/tomato.png",
    },
    {
      "name": "Almond Nuts",
      "category": "Nuts",
      "price": 15.50,
      "quantity": 30,
      "image": "asset/image/almond.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Products"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Image.asset(product['image'], width: 50, height: 50),
              title: Text(product['name'], style: TextStyle(fontSize: 18)),
              subtitle: Text(
                  "Category: ${product['category']}\nPrice: \$${product['price']}\nQuantity: ${product['quantity']}"),
              trailing:
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
              onTap: () {                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FarmerAddProductDetailScreen()),
                );
                // Navigate to product details screen (implement later)
              },
            ),
          );
        },
      ),
    );
  }
}
