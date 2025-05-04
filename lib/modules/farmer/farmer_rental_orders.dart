import 'package:flutter/material.dart';

class RentalOrdersScreen extends StatefulWidget {
  @override
  _RentalOrdersScreenState createState() => _RentalOrdersScreenState();
}

class _RentalOrdersScreenState extends State<RentalOrdersScreen> {
  List<Map<String, String>> rentalOrders = [
    {"id": "1", "name": "Tractor", "price": "\$150/day", "status": "Ongoing"},
    {
      "id": "2",
      "name": "Water Pumping Machine",
      "price": "\$50/day",
      "status": "Completed"
    },
    {
      "id": "3",
      "name": "Plowing Machine",
      "price": "\$120/day",
      "status": "Pending"
    },
  ];

  void _cancelOrder(int index) {
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
            onPressed: () {
              setState(() {
                rentalOrders.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rental Orders"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: rentalOrders.isEmpty
          ? Center(
              child: Text("No rental orders found",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          : ListView.builder(
              itemCount: rentalOrders.length,
              itemBuilder: (context, index) {
                final order = rentalOrders[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(order["name"]!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Price: ${order["price"]}"),
                        Text("Status: ${order["status"]}",
                            style: TextStyle(
                                color: order["status"] == "Ongoing"
                                    ? Colors.green
                                    : order["status"] == "Pending"
                                        ? Colors.orange
                                        : Colors.grey)),
                      ],
                    ),
                    trailing: order["status"] == "Pending"
                        ? IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => _cancelOrder(index),
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
