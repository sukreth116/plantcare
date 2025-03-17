import 'package:flutter/material.dart';
import 'package:plantcare/modules/user/product_details.dart';


class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, String>> orders = [
    {"id": "1", "name": "Aloe Vera", "price": "\$15.99"},
    {"id": "2", "name": "Bonsai Tree", "price": "\$45.00"},
    {"id": "3", "name": "Cactus", "price": "\$10.50"},
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
        title: Text("My Orders"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(),
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
