import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/modules/nursery/nursery_edit_product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> productData;
  final String productId; // <-- Add this

  const ProductDetailsScreen(
      {Key? key, required this.productData, required this.productId})
      : super(key: key);

  void _deleteProduct(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('nursery_products')
          .doc(productId) // <-- Use the actual passed productId
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );

      Navigator.pop(context); // Go back after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productData['name'] ?? 'Product Details'),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: productData['imageUrl'] != null
                    ? Image.network(
                        productData['imageUrl'],
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 200,
                        color: Colors.grey,
                        child:
                            Icon(Icons.image, size: 100, color: Colors.white),
                      ),
              ),
              SizedBox(height: 20),
              Text(
                productData['name'] ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Price: ₹${productData['price'] ?? 0}',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                'Stock Available: ${productData['quantity'] ?? 0}',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              SizedBox(height: 20),
              Text(
                productData['description'] ?? 'No description available.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditNurseryProduct(
                        productId: productId,
                        productData: productData,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text("Edit Product", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Confirm Delete'),
                      content:
                          Text('Are you sure you want to delete this product?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(); // Close the dialog
                            _deleteProduct(context);
                          },
                          child: Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text("Delete Product", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
