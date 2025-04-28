// import 'package:flutter/material.dart';
// import 'package:plantcare/modules/user/product_details.dart';

// class OrdersScreen extends StatefulWidget {
//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   List<Map<String, String>> orders = [
//     {"id": "1", "name": "Aloe Vera", "price": "\$15.99"},
//     {"id": "2", "name": "Bonsai Tree", "price": "\$45.00"},
//     {"id": "3", "name": "Cactus", "price": "\$10.50"},
//   ];

//   void _cancelOrder(int index) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Cancel Order"),
//         content: Text("Are you sure you want to cancel this order?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("No"),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 orders.removeAt(index);
//               });
//               Navigator.pop(context);
//             },
//             child: Text("Yes", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Orders"),
//         backgroundColor: Colors.teal,
//         foregroundColor: Colors.white,
//       ),
//       body: ListView.builder(
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductDetailScreen(),
//                   ),
//                 );
//               },
//               title: Text(orders[index]["name"]!),
//               subtitle: Text(orders[index]["price"]!),
//               trailing: IconButton(
//                 icon: Icon(Icons.cancel, color: Colors.red),
//                 onPressed: () => _cancelOrder(index),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserOrderScreen extends StatefulWidget {
  @override
  _UserOrderScreenState createState() => _UserOrderScreenState();
}

class _UserOrderScreenState extends State<UserOrderScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Please log in to view your orders')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user_order')
            .where('userId', isEqualTo: user!.uid)
            // latest orders first
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return Center(
              child: Text(
                "You have no orders yet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              final products =
                  List<Map<String, dynamic>>.from(data['products'] ?? []);

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ExpansionTile(
                  title: Text(
                    "Order ID: ${(data['orderId'])}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Total Amount: ₹${(data['totalAmount'] ?? 0).toStringAsFixed(2)}"),
                      Text(
                          "Total Quantity: ${data['totalQuantity'] ?? 0} items"),
                      Text("Status: ${(data['status'])}")
                    ],
                  ),
                  children: products.map((product) {
                    return ListTile(
                      leading: product['imageUrl'] != null
                          ? Image.network(product['imageUrl'],
                              width: 50, height: 50, fit: BoxFit.cover)
                          : Icon(Icons.image, size: 50),
                      title: Text(product['name'] ?? ''),
                      subtitle: Text(
                        "₹${(product['price'] ?? 0).toStringAsFixed(2)} x ${product['quantity']} pcs",
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
