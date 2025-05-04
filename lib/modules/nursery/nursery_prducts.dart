// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:plantcare/modules/nursery/add_product_nursery.dart';

// class NurseryProductsScreen extends StatelessWidget {
//   // Sample product data
//   final List<Map<String, dynamic>> products = [
//     {
//       'name': 'Rose Plant',
//       'price': 250,
//       'image': 'asset/image/plant_sample_1.png',
//       'stock': 10,
//     },
//     {
//       'name': 'Tulsi Plant',
//       'price': 100,
//       'image': 'asset/image/plant_sample_1.png',
//       'stock': 5,
//     },
//     {
//       'name': 'Money Plant',
//       'price': 180,
//       'image': 'asset/image/plant_sample_1.png',
//       'stock': 15,
//     },
//     {
//       'name': 'Bamboo Plant',
//       'price': 300,
//       'image': 'asset/image/plant_sample_1.png',
//       'stock': 8,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Nursery Products'),
//       ),
//       body: ListView.builder(
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           final product = products[index];

//           return Card(
//             margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             child: ListTile(
//               leading: Image.asset(
//                 product['image'],
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//               ),
//               title: Text(product['name'],
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: Text('₹${product['price']}'),
//               trailing: Text(
//                 'Stock: ${product['stock']}',
//                 style:
//                     TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//               ),
//               onTap: () {
//                 // Handle product click (e.g., edit or view details)
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => AddNurseryProduct(
//                         nurseryId: FirebaseAuth.instance.currentUser!.uid,
//                       )));

//           // Handle adding a new product
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/modules/nursery/add_product_nursery.dart';
import 'package:plantcare/modules/nursery/nursery_product_detail.dart';

class NurseryProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String nurseryId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Nursery Products'),
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
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
