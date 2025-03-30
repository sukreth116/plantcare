import 'package:flutter/material.dart';

class Order {
  final String orderId;
  final String customerName;
  final String productName;
  final int quantity;
  final double totalPrice;
  String status; // Pending, Shipped, Delivered

  Order({
    required this.orderId,
    required this.customerName,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.status,
  });
}

class SaleOrderScreen extends StatefulWidget {
  @override
  _SaleOrderScreenState createState() => _SaleOrderScreenState();
}

class _SaleOrderScreenState extends State<SaleOrderScreen> {
  List<Order> orders = [
    Order(
      orderId: "#001",
      customerName: "John Doe",
      productName: "Aloe Vera",
      quantity: 2,
      totalPrice: 20.0,
      status: "Pending",
    ),
    Order(
      orderId: "#002",
      customerName: "Emma Smith",
      productName: "Rose Plant",
      quantity: 1,
      totalPrice: 15.5,
      status: "Shipped",
    ),
    Order(
      orderId: "#003",
      customerName: "David Wilson",
      productName: "Tulsi Plant",
      quantity: 3,
      totalPrice: 24.0,
      status: "Delivered",
    ),
  ];

  void updateStatus(int index, String newStatus) {
    setState(() {
      orders[index].status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sale Orders"),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Logic to refresh orders from database (if connected)
              setState(() {}); // Refresh UI
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order ID: ${order.orderId}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text("Customer: ${order.customerName}"),
                  Text("Product: ${order.productName}"),
                  Text("Quantity: ${order.quantity}"),
                  Text("Total Price: \$${order.totalPrice.toStringAsFixed(2)}"),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status: ${order.status}",
                        style: TextStyle(
                          color: order.status == "Delivered"
                              ? Colors.green
                              : (order.status == "Shipped"
                                  ? Colors.orange
                                  : Colors.red),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (newStatus) => updateStatus(index, newStatus),
                        itemBuilder: (context) => [
                          PopupMenuItem(value: "Pending", child: Text("Pending")),
                          PopupMenuItem(value: "Shipped", child: Text("Shipped")),
                          PopupMenuItem(value: "Delivered", child: Text("Delivered")),
                        ],
                        child: Icon(Icons.more_vert),
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
