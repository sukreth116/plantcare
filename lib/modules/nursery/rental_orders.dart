import 'package:flutter/material.dart';

class RentalOrder {
  final String orderId;
  final String customerName;
  final String machineName;
  final int quantity;
  final double rentalPrice;
  final String rentalPeriod; // Example: "2 Days"
  String status; // Pending, Ongoing, Completed

  RentalOrder({
    required this.orderId,
    required this.customerName,
    required this.machineName,
    required this.quantity,
    required this.rentalPrice,
    required this.rentalPeriod,
    required this.status,
  });
}

class NurseryRentalOrderScreen extends StatefulWidget {
  @override
  _NurseryRentalOrderScreenState createState() => _NurseryRentalOrderScreenState();
}

class _NurseryRentalOrderScreenState extends State<NurseryRentalOrderScreen> {
  List<RentalOrder> rentalOrders = [
    RentalOrder(
      orderId: "#F001",
      customerName: "John Doe",
      machineName: "Tractor",
      quantity: 1,
      rentalPrice: 1500.0,
      rentalPeriod: "3 Days",
      status: "Pending",
    ),
    RentalOrder(
      orderId: "#F002",
      customerName: "Emma Smith",
      machineName: "Rotavator",
      quantity: 1,
      rentalPrice: 800.0,
      rentalPeriod: "2 Days",
      status: "Ongoing",
    ),
    RentalOrder(
      orderId: "#F003",
      customerName: "David Wilson",
      machineName: "Seeder Machine",
      quantity: 2,
      rentalPrice: 2500.0,
      rentalPeriod: "5 Days",
      status: "Completed",
    ),
  ];

  void updateStatus(int index, String newStatus) {
    setState(() {
      rentalOrders[index].status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farm Machinery Rentals"),
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
        itemCount: rentalOrders.length,
        itemBuilder: (context, index) {
          final order = rentalOrders[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(Icons.agriculture, color: Colors.brown),
              title: Text(order.machineName, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customer: ${order.customerName}"),
                  Text("Rental Period: ${order.rentalPeriod}"),
                  Text("Quantity: ${order.quantity}"),
                  Text("Price: ₹${order.rentalPrice}"),
                ],
              ),
              trailing: DropdownButton<String>(
                value: order.status,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (String? newValue) {
                  if (newValue != null) updateStatus(index, newValue);
                },
                items: ["Pending", "Ongoing", "Completed"]
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
