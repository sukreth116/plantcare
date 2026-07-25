import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/modules/nursery/add_product_nursery.dart';
import 'package:plantcare/modules/nursery/nursery_product_detail.dart';

class NurseryProductsScreen extends StatelessWidget {
  const NurseryProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String nurseryId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Nursery Products'),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('nursery_products')
            .where('nurseryId', isEqualTo: nurseryId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No products found.'));
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final data = product.data() as Map<String, dynamic>;
              final productId = product.id;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: data['imageUrl'] != null
                      ? Image.network(
                          data['imageUrl'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey,
                          child: Icon(Icons.image, color: Colors.white),
                        ),
                  title: Text(
                    data['name'] ?? 'Unnamed Product',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('₹${data['price'] ?? 0}'),
                  trailing: Text(
                    'Stock: ${data['quantity'] ?? 0}',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          productId: productId,
                          productData: {
                            ...data,
                          },
                        ),
                      ),
                    );
                    // Handle product click (edit/view details)
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNurseryProduct(
                nurseryId: nurseryId,
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
