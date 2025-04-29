// // import 'package:flutter/material.dart';

// // class ProductDetailScreen extends StatelessWidget {
// //   final String name;
// //   final String imageUrl;
// //   final String price;
// //   final String description;

// //   const ProductDetailScreen({
// //     Key? key,
// //     required this.name,
// //     required this.imageUrl,
// //     required this.price,
// //     required this.description,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Product Details"),
// //         backgroundColor: Colors.teal,
// //         foregroundColor: Colors.white,
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Center(
// //               child: Image.network(
// //                 imageUrl,
// //                 height: 250,
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //             Text(
// //               name,
// //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 2),
// //             Text(
// //               price,
// //               style: TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.green),
// //             ),
// //             SizedBox(height: 2),
// //             Row(
// //               children: [
// //                 Row(
// //                   children: List.generate(5, (index) {
// //                     return Icon(Icons.star, color: Colors.amber);
// //                   }),
// //                 ),
// //                 SizedBox(width: 10),
// //                 IconButton(
// //                   icon: Icon(Icons.favorite_border, color: Colors.black),
// //                   onPressed: () {
// //                     // Add favorite functionality here
// //                   },
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               description,
// //               style: TextStyle(fontSize: 16),
// //             ),
// //             Spacer(),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton(
// //                 onPressed: () {},
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.teal,
// //                   padding: EdgeInsets.symmetric(vertical: 12),
// //                 ),
// //                 child: Text("AR View",
// //                     style: TextStyle(fontSize: 18, color: Colors.white)),
// //               ),
// //             ),
// //             SizedBox(
// //               height: 20,
// //             ),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton(
// //                 onPressed: () {},
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.teal,
// //                   padding: EdgeInsets.symmetric(vertical: 12),
// //                 ),
// //                 child: Text("Add to Cart",
// //                     style: TextStyle(fontSize: 18, color: Colors.white)),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String price;
  final String description;
  final String productId;

  const ProductDetailScreen(
      {Key? key,
      required this.name,
      required this.imageUrl,
      required this.price,
      required this.description,
      required this.productId})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isWishlisted = false; // Track if product is wishlisted

  @override
  void initState() {
    super.initState();
    checkIfWishlisted();
  }

  void checkIfWishlisted() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final wishlistRef = FirebaseFirestore.instance
          .collection('wishlist')
          .where('productId', isEqualTo: widget.productId)
          .where('userId', isEqualTo: user.uid)
          .limit(1);

      final snapshot = await wishlistRef.get();

      setState(() {
        isWishlisted = snapshot.docs.isNotEmpty;
      });
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

        setState(() {
          isWishlisted = false;
        });

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

        setState(() {
          isWishlisted = true;
        });

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
              child: Image.network(
                widget.imageUrl,
                height: 250,
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              widget.price,
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
                  onPressed: toggleWishlist,
                  icon: Icon(
                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                    color: isWishlisted ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              widget.description,
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add AR View functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text("AR View",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add to Cart functionality
                },
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
