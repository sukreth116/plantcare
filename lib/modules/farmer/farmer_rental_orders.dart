import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/modules/farmer/edit_rental_orders.dart';

class RentalOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Rental Orders"),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rental_orders')
            .where('farmerId', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Text("No rental orders found",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              final docId = orders[index].id;
              final machineryId = data['machineryId'];

              // Inside itemBuilder for each rental order
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('machinery')
                    .doc(machineryId)
                    .get(),
                builder: (context, machinerySnapshot) {
                  if (!machinerySnapshot.hasData) {
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(title: Text("Loading machinery...")),
                    );
                  }

                  final machineryData =
                      machinerySnapshot.data!.data() as Map<String, dynamic>?;
                  final machineryName = machineryData != null
                      ? machineryData['name'] ?? 'Unknown'
                      : 'Unknown';
                  final nurseryId = machineryData?['nurseryId'] ?? '';

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('nurseries')
                        .doc(nurseryId)
                        .get(),
                    builder: (context, nurserySnapshot) {
                      final nurseryData =
                          nurserySnapshot.data?.data() as Map<String, dynamic>?;
                      final nurseryName = nurseryData != null
                          ? nurseryData['nurseryName'] ?? 'Unknown Nursery'
                          : 'Loading...';

                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text("Machinery: $machineryName",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nursery: $nurseryName",
                              ),
                              Text("Total Price: ₹${data['totalPrice']}"),
                              Text("Days: ${data['days']}"),
                              Text("Status: ${data['status']}",
                                  style: TextStyle(
                                    color: data['status'] == 'ongoing'
                                        ? Colors.green
                                        : data['status'] == 'pending'
                                            ? Colors.orange
                                            : Colors.grey,
                                  )),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RentalOrderEditScreen(
                                        rentalOrderId: docId,
                                      ),
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
                          trailing: data['status'] == 'pending'
                              ? IconButton(
                                  icon: Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () {
                                    _cancelOrder(context, docId);
                                  },
                                )
                              : null,
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _cancelOrder(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cancel Rental Order"),
        content: Text("Are you sure you want to cancel this rental order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('rental_orders')
                  .doc(docId)
                  .delete();

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Order cancelled")),
              );
            },
            child: Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
