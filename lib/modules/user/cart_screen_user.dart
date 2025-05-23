// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CartScreen extends StatefulWidget {
//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   User? user = FirebaseAuth.instance.currentUser;

//   // Function to calculate the total price based on cart items and quantities
//   double getTotalPrice(List<DocumentSnapshot> cartItems) {
//     return cartItems.fold(0, (sum, item) {
//       final data = item.data() as Map<String, dynamic>;
//       final price = double.tryParse(data['price'].toString()) ?? 0.0;
//       final quantity = data['quantity'] ?? 1;
//       return sum + (price * quantity);
//     });
//   }

//   // Increase the quantity of an item in the cart
//   void increaseQuantity(DocumentSnapshot item) {
//     final docRef = item.reference;
//     final data = item.data() as Map<String, dynamic>;
//     docRef.update({'quantity': (data['quantity'] ?? 1) + 1});
//   }

//   // Decrease the quantity of an item in the cart or remove it if quantity is 1
//   void decreaseQuantity(DocumentSnapshot item) {
//     final docRef = item.reference;
//     final data = item.data() as Map<String, dynamic>;
//     if ((data['quantity'] ?? 1) > 1) {
//       docRef.update({'quantity': (data['quantity'] ?? 1) - 1});
//     } else {
//       docRef.delete(); // Remove item if quantity reaches 0
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return Scaffold(
//         body: Center(child: Text('Please log in to view your cart')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Cart"),
//         backgroundColor: Colors.green.shade300,
//         foregroundColor: Colors.white,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('user_cart') // Collection for all users' cart items
//             .where('userId',
//                 isEqualTo: user!.uid) // Filter cart items by current userId
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           final cartItems = snapshot.data!.docs;

//           if (cartItems.isEmpty) {
//             return Center(
//               child: Text(
//                 "Your cart is empty",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             );
//           }

//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: cartItems.length,
//                   itemBuilder: (context, index) {
//                     final item = cartItems[index];
//                     final data = item.data() as Map<String, dynamic>;

//                     return Card(
//                       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                       child: ListTile(
//                         leading: data['imageUrl'] != null
//                             ? Image.network(data['imageUrl'],
//                                 width: 50, height: 50)
//                             : Icon(Icons.image, size: 50),
//                         title: Text(data['name'] ?? ''),
//                         subtitle: Text(
//                           "\₹${(double.tryParse(data['price'].toString()) ?? 0.0).toStringAsFixed(2)}",
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.remove_circle_outline),
//                               onPressed: () => decreaseQuantity(item),
//                             ),
//                             Text((data['quantity'] ?? 1).toString()),
//                             IconButton(
//                               icon: Icon(Icons.add_circle_outline),
//                               onPressed: () => increaseQuantity(item),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Total:",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold)),
//                         Text(
//                           "\₹${getTotalPrice(cartItems).toStringAsFixed(2)}",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           try {
//                             // Fetch user profile details (address & phone)
//                             final userDoc = await FirebaseFirestore.instance
//                                 .collection('users')
//                                 .doc(user!.uid)
//                                 .get();

//                             final userData = userDoc.data();

//                             if (userData == null ||
//                                 userData['address'] == null ||
//                                 userData['phone'] == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                     content: Text(
//                                         'Please update your address and phone number in profile.')),
//                               );
//                               return;
//                             }
//                             final cartSnapshot = await FirebaseFirestore
//                                 .instance
//                                 .collection('user_cart')
//                                 .where('userId', isEqualTo: user!.uid)
//                                 .get();

//                             final cartItems = cartSnapshot.docs;

//                             if (cartItems.isEmpty) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Your cart is empty')),
//                               );
//                               return;
//                             }

//                             double totalAmount = 0;
//                             int totalQuantity = 0;
//                             List<Map<String, dynamic>> products = [];

//                             for (var item in cartItems) {
//                               final data = item.data();
//                               final price =
//                                   double.tryParse(data['price'].toString()) ??
//                                       0.0;
//                               final quantity = (data['quantity'] as int?) ?? 1;

//                               totalAmount += price * quantity;
//                               totalQuantity += quantity;

//                               products.add({
//                                 'productId': item.id,
//                                 'nurseryId': data['nurseryId'],
//                                 'name': data['name'],
//                                 'price': price,
//                                 'quantity': quantity,
//                                 'imageUrl': data['imageUrl'] ?? '',
//                               });
//                             }

//                             String generateOrderId() {
//                               final now = DateTime.now();
//                               return 'ORD${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
//                             }

//                             String orderId = generateOrderId();
//                             // Add new order

//                             await FirebaseFirestore.instance
//                                 .collection('user_order')
//                                 .add({
//                               'orderId': orderId, // <-- New field
//                               'userPhone': userData['phone'],
//                               'userLocation': userData['address'],
//                               'userId': user!.uid,
//                               'products': products,
//                               'totalAmount': totalAmount,
//                               'totalQuantity': totalQuantity,
//                               'orderDate': Timestamp.now(),
//                               'status': 'Pending'
//                             });

//                             // After order success, clear cart
//                             for (var item in cartItems) {
//                               await item.reference.delete();
//                             }

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                   content: Text('Order placed successfully!')),
//                             );

//                             // Optional: Navigate to an order confirmation page
//                             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderConfirmationScreen()));
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                   content: Text('Error during checkout: $e')),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green.shade300,
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: Text(
//                           "Proceed to Checkout",
//                           style: TextStyle(fontSize: 18, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  double getTotalPrice(List<DocumentSnapshot> cartItems) {
    return cartItems.fold(0, (sum, item) {
      final data = item.data() as Map<String, dynamic>;
      final price = double.tryParse(data['price'].toString()) ?? 0.0;
      final quantity = data['quantity'] ?? 1;
      return sum + (price * quantity);
    });
  }

  void increaseQuantity(DocumentSnapshot item) {
    final docRef = item.reference;
    final data = item.data() as Map<String, dynamic>;
    docRef.update({'quantity': (data['quantity'] ?? 1) + 1});
  }

  void decreaseQuantity(DocumentSnapshot item) {
    final docRef = item.reference;
    final data = item.data() as Map<String, dynamic>;
    if ((data['quantity'] ?? 1) > 1) {
      docRef.update({'quantity': (data['quantity'] ?? 1) - 1});
    } else {
      docRef.delete();
    }
  }

  void openRazorpayCheckout(double totalAmount) {
    var options = {
      'key': 'rzp_test_SzQbItYGKXrpzq', // Replace with your Razorpay Key
      'amount': (totalAmount * 100).toInt(), // in paise
      'name': 'Greenify',
      'description': 'Plant Purchase',
      'prefill': {
        'contact': user?.phoneNumber ?? '',
        'email': user?.email ?? '',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _placeOrder();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet Selected")),
    );
  }

  Future<void> _placeOrder() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      final userData = userDoc.data();
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('user_cart')
          .where('userId', isEqualTo: user!.uid)
          .get();
      final cartItems = cartSnapshot.docs;

      if (cartItems.isEmpty) return;

      double totalAmount = 0;
      int totalQuantity = 0;
      List<Map<String, dynamic>> products = [];

      for (var item in cartItems) {
        final data = item.data();
        final price = double.tryParse(data['price'].toString()) ?? 0.0;
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

      String orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';

      await FirebaseFirestore.instance.collection('user_order').add({
        'orderId': orderId,
        'userPhone': userData?['phone'],
        'userLocation': userData?['address'],
        'userId': user!.uid,
        'products': products,
        'totalAmount': totalAmount,
        'totalQuantity': totalQuantity,
        'orderDate': Timestamp.now(),
        'status': 'Pending'
      });

      for (var item in cartItems) {
        await item.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order error: $e')),
      );
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
            .collection('user_cart')
            .where('userId', isEqualTo: user!.uid)
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
                        onPressed: () {
                          openRazorpayCheckout(getTotalPrice(cartItems));
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
