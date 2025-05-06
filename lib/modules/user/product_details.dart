import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isWishlisted = false;
  Map<String, dynamic>? productData;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    checkIfWishlisted();
  }

  Future<void> fetchProductDetails() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('nursery_products')
        .doc(widget.productId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        productData = docSnapshot.data();
      });
    }
  }

  void checkIfWishlisted() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('wishlist')
          .where('productId', isEqualTo: widget.productId)
          .where('userId', isEqualTo: user.uid)
          .get();

      if (mounted) {
        setState(() {
          isWishlisted = snapshot.docs.isNotEmpty;
        });
      }
    }
  }

  void toggleWishlist() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final wishlistCollection =
          FirebaseFirestore.instance.collection('wishlist');

      if (isWishlisted) {
        // Remove from wishlist
        final snapshot = await wishlistCollection
            .where('productId', isEqualTo: widget.productId)
            .where('userId', isEqualTo: user.uid)
            .get();

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        if (mounted) {
          setState(() {
            isWishlisted = false;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from Wishlist')),
        );
      } else {
        // Add to wishlist
        await wishlistCollection.add({
          'productId': widget.productId,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          setState(() {
            isWishlisted = true;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to Wishlist')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to use wishlist')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (productData == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Product Details")),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  productData!['imageUrl'],
                  height: 250,
                ),
              ),
              SizedBox(height: 16),
              Text(
                productData!['name'],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "₹ ${productData!['price']}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(Icons.star, color: Colors.amber);
                    }),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: toggleWishlist,
                    icon: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              if (productData!['subCategory'] != null) ...[
                SizedBox(height: 4),
                Text(
                  'Category: ${productData!['subCategory']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
              SizedBox(height: 8),
              Text(
                productData!['description'] ?? '',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text("AR View", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    try {
                      final cartRef = FirebaseFirestore.instance
                          .collection('user_cart')
                          .where('productId', isEqualTo: widget.productId)
                          .where('userId', isEqualTo: user.uid)
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
                        await FirebaseFirestore.instance
                            .collection('user_cart')
                            .add({
                          'productId': widget.productId,
                          'name': productData?['name'],
                          'price': (productData?['price']),
                          'imageUrl': productData?['imageUrl'],
                          'nurseryId': productData?['nurseryId'],
                          'quantity': 1,
                          'timestamp': FieldValue.serverTimestamp(),
                          'userId': user.uid,
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
                      SnackBar(
                          content:
                              Text('Please log in to add items to your cart')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text("Add to Cart", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
