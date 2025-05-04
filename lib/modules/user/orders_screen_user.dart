import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantcare/modules/user/order_edit_screen.dart';

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
        backgroundColor: Colors.green.shade300,
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
                      Text("Status: ${(data['status'])}"),
                      Text("Your Location: ${(data['userLocation'])}"),
                      Text("Your Phone Number: ${(data['userPhone'])}"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  UserOrderEditScreen(orderDoc: order),
                            ),
                          );
                        },
                        child: Text(
                          'Edit Order',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
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
