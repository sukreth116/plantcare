import 'package:flutter/material.dart';
import 'package:plantcare/modules/farmer/product_detail_screen.dart';
import 'package:plantcare/modules/user/product_details.dart';

class FarmerOrdersScreen extends StatefulWidget {
  @override
  _FarmerOrdersScreenState createState() => _FarmerOrdersScreenState();
}

class _FarmerOrdersScreenState extends State<FarmerOrdersScreen> {
  List<Map<String, String>> orders = [
    {"id": "1", "name": "Vazh Kannu", "price": "\$50"},
    {"id": "2", "name": "Fertilizer Pack", "price": "\$50"},
    {"id": "3", "name": "Irrigation Pump", "price": "\$250"},
  ];

  void _cancelOrder(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cancel Order"),
        content: Text("Are you sure you want to cancel this order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                orders.removeAt(index);
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
        title: Text("Farmer Orders"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: orders.isEmpty
          ? Center(child: Text("No orders available"))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FarmerProductDetailScreen(),
                        ),
                      );
                    },
                    title: Text(orders[index]["name"]!),
                    subtitle: Text(orders[index]["price"]!),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () => _cancelOrder(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
