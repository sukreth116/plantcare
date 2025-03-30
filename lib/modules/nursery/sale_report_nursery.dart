import 'package:flutter/material.dart';

class Sale {
  final String saleId;
  final String customerName;
  final String productName;
  final int quantity;
  final double totalPrice;
  final String date; // Format: "DD-MM-YYYY"

  Sale({
    required this.saleId,
    required this.customerName,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.date,
  });
}

class NurserySalesReportScreen extends StatelessWidget {
  final List<Sale> sales = [
    Sale(saleId: "#S001", customerName: "John Doe", productName: "Aloe Vera", quantity: 2, totalPrice: 500, date: "28-03-2025"),
    Sale(saleId: "#S002", customerName: "Emma Smith", productName: "Rose Plant", quantity: 1, totalPrice: 300, date: "27-03-2025"),
    Sale(saleId: "#S003", customerName: "David Wilson", productName: "Money Plant", quantity: 3, totalPrice: 750, date: "26-03-2025"),
    Sale(saleId: "#S004", customerName: "Sophia Brown", productName: "Tulsi Plant", quantity: 5, totalPrice: 1200, date: "25-03-2025"),
  ];

  double getTotalRevenue() {
    return sales.fold(0, (sum, sale) => sum + sale.totalPrice);
  }

  int getTotalOrders() {
    return sales.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Report"),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          // Summary Section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Revenue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("₹${getTotalRevenue()}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Orders", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("${getTotalOrders()}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Sales List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final sale = sales[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Icon(Icons.shopping_cart, color: Colors.green),
                    title: Text(sale.productName, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer: ${sale.customerName}"),
                        Text("Quantity: ${sale.quantity}"),
                        Text("Total Price: ₹${sale.totalPrice}"),
                        Text("Date: ${sale.date}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
