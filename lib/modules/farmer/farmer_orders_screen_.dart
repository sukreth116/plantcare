import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantcare/modules/farmer/farmer_order_edit_screen.dart';

class FarmerOrdersScreen extends StatefulWidget {
  @override
  _FarmerOrdersScreenState createState() => _FarmerOrdersScreenState();
}

class _FarmerOrdersScreenState extends State<FarmerOrdersScreen> {
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
            .collection('farmer_order')
            .where('farmerId', isEqualTo: user!.uid)
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
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
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
                        Text("Your Location: ${(data['farmerLocation'])}"),
                        Text("Your Phone Number: ${(data['farmerPhone'])}"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    FarmerOrderEditScreen(orderDoc: order),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
