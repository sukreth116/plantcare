import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FarmerWishlistScreen extends StatefulWidget {
  @override
  _FarmerWishlistScreenState createState() => _FarmerWishlistScreenState();
}

class _FarmerWishlistScreenState extends State<FarmerWishlistScreen> {
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
        .collection('farmer_wishlist')
        .where('farmerId', isEqualTo: user.uid)
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
    await _firestore.collection('farmer_wishlist').doc(wishlistId).delete();
    fetchWishlist();
  }

  Future<void> moveToCart(Map<String, dynamic> item) async {

    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final cartRef = FirebaseFirestore.instance
            .collection('farmer_cart')
            .where('productId', isEqualTo: item['productId'])
            .where('farmerId', isEqualTo: user.uid)
            .limit(1);

        final cartSnapshot = await cartRef.get();

        if (cartSnapshot.docs.isNotEmpty) {
          final cartItem = cartSnapshot.docs.first;
          final currentQuantity = cartItem['quantity'];
          final updatedQuantity = currentQuantity + 1;

          await cartItem.reference.update({
            'quantity': updatedQuantity,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item Again Added to Cart')),
          );
        } else {
          await FirebaseFirestore.instance.collection('farmer_cart').add({
            'productId': item['productId'],
            'name': item['name'],
            'price': double.tryParse(item['price']) ?? 0.0,
            'imageUrl': item['imageUrl'],
            'nurseryId': item['nurseryId'],
            'quantity': 1,
            'timestamp': FieldValue.serverTimestamp(),
            'farmerId': user.uid,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
              'Added to Cart',
              style: TextStyle(color: Colors.white),
            )),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to cart: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to add items to your cart')),
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
