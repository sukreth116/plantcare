// import 'package:flutter/material.dart';

// class WishlistScreen extends StatefulWidget {
//   @override
//   _WishlistScreenState createState() => _WishlistScreenState();
// }

// class _WishlistScreenState extends State<WishlistScreen> {
//   List<Map<String, dynamic>> wishlistItems = [
//     {
//       'image': 'asset/image/plant_sample_1.png',
//       'name': 'Aloe Vera',
//       'price': 29.99,
//     },
//     {
//       'image': 'asset/image/plant_sample_1.png',
//       'name': 'Bonsai Tree',
//       'price': 49.99,
//     },
//   ];

//   void removeFromWishlist(int index) {
//     setState(() {
//       wishlistItems.removeAt(index);
//     });
//   }

//   void moveToCart(int index) {
//     // Implement logic to add item to cart
//     setState(() {
//       wishlistItems.removeAt(index);
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Moved to cart')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//       wishlistItems.isEmpty
//           ? Center(child: Text("Your wishlist is empty"))
//           : ListView.builder(
//               padding: EdgeInsets.all(16),

//               itemCount: wishlistItems.length,
//               itemBuilder: (context, index) {
//                 final item = wishlistItems[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   child: ListTile(
//                     leading: Image.asset(item['image'], width: 50, height: 50),
//                     title: Text(item['name'], style: TextStyle(fontSize: 18)),
//                     subtitle: Text("\$${item['price']}",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.shopping_cart, color: Colors.green),
//                           onPressed: () => moveToCart(index),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => removeFromWishlist(index),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> wishlistItems = [];
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final wishlistSnapshot = await _firestore
        .collection('wishlist')
        .where('userId', isEqualTo: user.uid)
        .get();

    List<Map<String, dynamic>> loadedItems = [];

    for (var doc in wishlistSnapshot.docs) {
      final productId = doc['productId'];

      final productSnap =
          await _firestore.collection('nursery_products').doc(productId).get();

      if (productSnap.exists) {
        final productData = productSnap.data()!;
        loadedItems.add({
          'wishlistId': doc.id,
          'productId': productId,
          'name': productData['name'],
          'image': productData['imageUrl'], // image URL
          'nurseryId': productData['nurseryId'],
          'price': productData['price'],
        });
      }
    }

    setState(() {
      wishlistItems = loadedItems;
      isLoading = false;
    });
  }

  Future<void> removeFromWishlist(String wishlistId) async {
    await _firestore.collection('wishlist').doc(wishlistId).delete();
    fetchWishlist();
  }

  Future<void> moveToCart(Map<String, dynamic> item) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('user_cart').add({
        'userId': user.uid,
        'productId': item['productId'],
        'name': item['name'],
        'imageUrl': item['image'], // image URL
        'price': item['price'],
        'nurseryId': item['nurseryId'], // make sure this is fetched earlier
        'quantity': 1, // default to 1, or modify as needed
        'timestamp': Timestamp.now(),
      });

      await removeFromWishlist(item['wishlistId']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Moved to cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to move to cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : wishlistItems.isEmpty
              ? Center(child: Text("Your wishlist is empty"))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: wishlistItems.length,
                  itemBuilder: (context, index) {
                    final item = wishlistItems[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Image.network(
                          item['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title:
                            Text(item['name'], style: TextStyle(fontSize: 18)),
                        subtitle: Text(
                          "\$${item['price']}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.shopping_cart,
                                  color: Colors.green),
                              onPressed: () => moveToCart(item),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  removeFromWishlist(item['wishlistId']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
