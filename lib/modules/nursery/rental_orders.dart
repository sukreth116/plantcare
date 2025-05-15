import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RentalOrder {
  final String farmerId;
  final String farmerLocation;
  final String farmerPhone;
  final int days;
  final int quantity;
  final double rentalCharge;
  final double itemTotal;
  final double totalPrice;
  final String status;
  final String machineryId;
  final DateTime timestamp;
  final String nurseryId;

  RentalOrder({
    required this.farmerId,
    required this.farmerLocation,
    required this.farmerPhone,
    required this.days,
    required this.quantity,
    required this.rentalCharge,
    required this.itemTotal,
    required this.totalPrice,
    required this.status,
    required this.machineryId,
    required this.timestamp,
    required this.nurseryId,
  });

  factory RentalOrder.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RentalOrder(
      farmerId: data['farmerId'] ?? '',
      farmerLocation: data['farmerLocation'] ?? '',
      farmerPhone: data['farmerPhone'] ?? '',
      days: data['days'] ?? 0,
      quantity: data['quantity'] ?? 0,
      rentalCharge: (data['rentalCharge'] ?? 0).toDouble(),
      itemTotal: (data['itemTotal'] ?? 0).toDouble(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'Pending',
      machineryId: data['machineryId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      nurseryId: data['nurseryId'] ?? '',
    );
  }
}

class RentalOrderScreen extends StatefulWidget {
  @override
  _RentalOrderScreenState createState() => _RentalOrderScreenState();
}

class _RentalOrderScreenState extends State<RentalOrderScreen> {
  List<RentalOrder> rentalOrders = [];
  Map<String, String> machineryNames = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRentalOrders();
  }

  Future<void> fetchRentalOrders() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('rental_orders')
        .where('nurseryId', isEqualTo: currentUser.uid)
        .get();

    final machinerySnapshot =
        await FirebaseFirestore.instance.collection('machinery').get();

    final machineryMap = {
      for (var doc in machinerySnapshot.docs)
        doc.id: (doc.data()['name'] ?? 'Unnamed').toString()
    };

    setState(() {
      rentalOrders =
          snapshot.docs.map((doc) => RentalOrder.fromFirestore(doc)).toList();
      machineryNames = machineryMap;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rental Orders'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchRentalOrders,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : rentalOrders.isEmpty
              ? Center(child: Text('No rental orders found'))
              : ListView.builder(
                  itemCount: rentalOrders.length,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final order = rentalOrders[index];
                    final machineryName =
                        machineryNames[order.machineryId] ?? 'Unknown';

                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Machinery: $machineryName',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text('Farmer Phone: ${order.farmerPhone}'),
                            Text('Location: ${order.farmerLocation}'),
                            Text('Days: ${order.days}'),
                            Text('Quantity: ${order.quantity}'),
                            Text(
                                'Rental Charge: \$${order.rentalCharge.toStringAsFixed(2)}'),
                            Text(
                                'Total Price: \$${order.totalPrice.toStringAsFixed(2)}'),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Status: ${order.status}',
                                  style: TextStyle(
                                    color: order.status == "Delivered"
                                        ? Colors.green
                                        : (order.status == "Shipped"
                                            ? Colors.orange
                                            : Colors.red),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${order.timestamp.toLocal().toString().split(' ')[0]}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
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
