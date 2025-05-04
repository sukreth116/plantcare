// import 'package:flutter/material.dart';

// class FarmerCartScreen extends StatefulWidget {
//   @override
//   _FarmerCartScreenState createState() => _FarmerCartScreenState();
// }

// class _FarmerCartScreenState extends State<FarmerCartScreen> {
//   List<Map<String, dynamic>> cartItems = [
//     {
//       "name": "Organic Seeds",
//       "price": 29.99,
//       "image": "asset/image/seeds.jpg",
//       "quantity": 2,
//     },
//     {
//       "name": "Fertilizer Pack",
//       "price": 49.99,
//       "image": "asset/image/fertilizer.png",
//       "quantity": 1,
//     },
//     {
//       "name": "Vazha",
//       "price": 49.99,
//       "image": "asset/image/fertilizer.png",
//       "quantity": 1,
//     },
//   ];

//   double getTotalPrice() {
//     return cartItems.fold(
//         0, (sum, item) => sum + (item['price'] * item['quantity']));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Farmer Cart"),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       body: cartItems.isEmpty
//           ? Center(
//               child: Text(
//                 "Your cart is empty",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (context, index) {
//                       final item = cartItems[index];
//                       return Card(
//                         margin:
//                             EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         child: ListTile(
//                           leading:
//                               Image.asset(item['image'], width: 50, height: 50),
//                           title: Text(item['name']),
//                           subtitle:
//                               Text("\$${item['price'].toStringAsFixed(2)}"),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.remove_circle_outline),
//                                 onPressed: () {
//                                   setState(() {
//                                     if (item['quantity'] > 1) {
//                                       item['quantity'] -= 1;
//                                     } else {
//                                       cartItems.removeAt(index);
//                                     }
//                                   });
//                                 },
//                               ),
//                               Text(item['quantity'].toString()),
//                               IconButton(
//                                 icon: Icon(Icons.add_circle_outline),
//                                 onPressed: () {
//                                   setState(() {
//                                     item['quantity'] += 1;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Total:",
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold)),
//                           Text("\$${getTotalPrice().toStringAsFixed(2)}",
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // Navigate to checkout screen (implement later)
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             padding: EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           child: Text("Proceed to Checkout",
//                               style:
//                                   TextStyle(fontSize: 18, color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FarmerCartScreen extends StatefulWidget {
  @override
  _FarmerCartScreenState createState() => _FarmerCartScreenState();
}

class _FarmerCartScreenState extends State<FarmerCartScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  // Function to calculate the total price based on cart items and quantities
  double getTotalPrice(List<DocumentSnapshot> cartItems) {
    return cartItems.fold(0, (sum, item) {
      final data = item.data() as Map<String, dynamic>;
      final price = double.tryParse(data['price'].toString()) ?? 0.0;
      final quantity = data['quantity'] ?? 1;
      return sum + (price * quantity);
    });
  }

  // Increase the quantity of an item in the cart
  void increaseQuantity(DocumentSnapshot item) {
    final docRef = item.reference;
    final data = item.data() as Map<String, dynamic>;
    docRef.update({'quantity': (data['quantity'] ?? 1) + 1});
  }

  // Decrease the quantity of an item in the cart or remove it if quantity is 1
  void decreaseQuantity(DocumentSnapshot item) {
    final docRef = item.reference;
    final data = item.data() as Map<String, dynamic>;
    if ((data['quantity'] ?? 1) > 1) {
      docRef.update({'quantity': (data['quantity'] ?? 1) - 1});
    } else {
      docRef.delete(); // Remove item if quantity reaches 0
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Please log in to view your cart')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('farmer_cart') // Collection for all users' cart items
            .where('farmerId',
                isEqualTo: user!.uid) // Filter cart items by current userId
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!.docs;

          if (cartItems.isEmpty) {
            return Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final data = item.data() as Map<String, dynamic>;

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: data['imageUrl'] != null
                            ? Image.network(data['imageUrl'],
                                width: 50, height: 50)
                            : Icon(Icons.image, size: 50),
                        title: Text(data['name'] ?? ''),
                        subtitle: Text(
                          "\₹${(double.tryParse(data['price'].toString()) ?? 0.0).toStringAsFixed(2)}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () => decreaseQuantity(item),
                            ),
                            Text((data['quantity'] ?? 1).toString()),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () => increaseQuantity(item),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          "\₹${getTotalPrice(cartItems).toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            // Fetch user profile details (address & phone)
                            final userDoc = await FirebaseFirestore.instance
                                .collection('farmers')
                                .doc(user!.uid)
                                .get();

                            final farmerData = userDoc.data();

                            if (farmerData == null ||
                                farmerData['address'] == null ||
                                farmerData['phone'] == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Please update your address and phone number in profile.')),
                              );
                              return;
                            }
                            final cartSnapshot = await FirebaseFirestore
                                .instance
                                .collection('farmer_cart')
                                .where('farmerId', isEqualTo: user!.uid)
                                .get();

                            final cartItems = cartSnapshot.docs;

                            if (cartItems.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Your cart is empty')),
                              );
                              return;
                            }

                            double totalAmount = 0;
                            int totalQuantity = 0;
                            List<Map<String, dynamic>> products = [];

                            for (var item in cartItems) {
                              final data = item.data();
                              final price =
                                  double.tryParse(data['price'].toString()) ??
                                      0.0;
                              final quantity = (data['quantity'] as int?) ?? 1;

                              totalAmount += price * quantity;
                              totalQuantity += quantity;

                              products.add({
                                'productId': item.id,
                                'nurseryId': data['nurseryId'],
                                'name': data['name'],
                                'price': price,
                                'quantity': quantity,
                                'imageUrl': data['imageUrl'] ?? '',
                              });
                            }

                            String generateOrderId() {
                              final now = DateTime.now();
                              return 'ORD${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
                            }

                            String orderId = generateOrderId();
                            // Add new order

                            await FirebaseFirestore.instance
                                .collection('farmer_order')
                                .add({
                              'orderId': orderId, // <-- New field
                              'farmerPhone': farmerData['phone'],
                              'farmerLocation': farmerData['address'],
                              'farmerId': user!.uid,
                              'products': products,
                              'totalAmount': totalAmount,
                              'totalQuantity': totalQuantity,
                              'orderDate': Timestamp.now(),
                              'status': 'Pending'
                            });

                            // After order success, clear cart
                            for (var item in cartItems) {
                              await item.reference.delete();
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Order placed successfully!')),
                            );

                            // Optional: Navigate to an order confirmation page
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderConfirmationScreen()));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Error during checkout: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade300,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Proceed to Checkout",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
