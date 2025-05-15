// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Sale {
//   final String saleId;
//   final String customerName;
//   final String productName;
//   final int quantity;
//   final double totalPrice;
//   final String date;

//   Sale({
//     required this.saleId,
//     required this.customerName,
//     required this.productName,
//     required this.quantity,
//     required this.totalPrice,
//     required this.date,
//   });
// }

// class NurserySalesReportScreen extends StatefulWidget {
//   @override
//   _NurserySalesReportScreenState createState() =>
//       _NurserySalesReportScreenState();
// }

// class _NurserySalesReportScreenState extends State<NurserySalesReportScreen> {
//   List<Sale> sales = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchSales();
//   }

//   Future<void> fetchSales() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) return;

//     final nurseryId = currentUser.uid;
//     List<Sale> allSales = [];
//     Set<String> customerIds = {};

//     // Fetch user orders
//     final userSnapshot =
//         await FirebaseFirestore.instance.collection('user_order').get();

//     // Fetch farmer orders
//     final farmerSnapshot =
//         await FirebaseFirestore.instance.collection('farmer_order').get();

//     for (var doc in userSnapshot.docs) {
//       final data = doc.data();
//       final products = List<Map<String, dynamic>>.from(data['products'] ?? []);
//       for (var product in products) {
//         if (product['nurseryId'] == nurseryId) {
//           final userId = data['userId'];
//           customerIds.add(userId);
//           allSales.add(Sale(
//             saleId: doc.id,
//             customerName: userId,
//             productName: product['productid'] ?? '',
//             quantity: product['quantity'] ?? 0,
//             totalPrice: (product['price'] ?? 0.0) * (product['quantity'] ?? 0),
//             date: (data['orderDate'] as Timestamp?)
//                     ?.toDate()
//                     .toString()
//                     .split(' ')[0] ??
//                 '',
//           ));
//         }
//       }
//     }

//     for (var doc in farmerSnapshot.docs) {
//       final data = doc.data();
//       final products = List<Map<String, dynamic>>.from(data['products'] ?? []);
//       for (var product in products) {
//         if (product['nurseryId'] == nurseryId) {
//           final farmerId = data['farmerId'];
//           customerIds.add(farmerId);
//           allSales.add(Sale(
//             saleId: doc.id,
//             customerName: farmerId,
//             productName: product['productid'] ?? '',
//             quantity: product['quantity'] ?? 0,
//             totalPrice: (product['price'] ?? 0.0) * (product['quantity'] ?? 0),
//             date: (data['orderDate'] as Timestamp?)
//                     ?.toDate()
//                     .toString()
//                     .split(' ')[0] ??
//                 '',
//           ));
//         }
//       }
//     }

//     Map<String, String> customerNames = {};
//     for (var id in customerIds) {
//       final userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(id).get();
//       if (userDoc.exists) {
//         customerNames[id] = userDoc.data()?['name'] ?? 'Unknown';
//         continue;
//       }
//       final farmerDoc =
//           await FirebaseFirestore.instance.collection('farmers').doc(id).get();
//       if (farmerDoc.exists) {
//         customerNames[id] = farmerDoc.data()?['name'] ?? 'Unknown';
//       }
//     }

//     setState(() {
//       sales = allSales
//           .map((sale) => Sale(
//                 saleId: sale.saleId,
//                 customerName: customerNames[sale.customerName] ?? 'Unknown',
//                 productName: sale.productName,
//                 quantity: sale.quantity,
//                 totalPrice: sale.totalPrice,
//                 date: sale.date,
//               ))
//           .toList();
//       isLoading = false;
//     });
//   }

//   double getTotalRevenue() {
//     return sales.fold(0, (sum, sale) => sum + sale.totalPrice);
//   }

//   int getTotalOrders() {
//     return sales.length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sales Report"),
//         backgroundColor: Colors.green[700],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Total Revenue",
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold)),
//                               Text("₹${getTotalRevenue()}",
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green)),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Total Orders",
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold)),
//                               Text("${getTotalOrders()}",
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.blue)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     padding: EdgeInsets.all(10),
//                     itemCount: sales.length,
//                     itemBuilder: (context, index) {
//                       final sale = sales[index];
//                       return Card(
//                         elevation: 3,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         child: ListTile(
//                           leading:
//                               Icon(Icons.shopping_cart, color: Colors.green),
//                           title: Text(sale.productName,
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Customer: ${sale.customerName}"),
//                               Text("Quantity: ${sale.quantity}"),
//                               Text("Total Price: ₹${sale.totalPrice}"),
//                               Text("Date: ${sale.date}",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.grey)),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Sale {
  final String saleId;
  final String customerName;
  final String productName;
  final int quantity;
  final double totalPrice;
  final String date;
  final String status;

  Sale({
    required this.saleId,
    required this.customerName,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.date,
    required this.status,
  });
}

class NurserySalesReportScreen extends StatefulWidget {
  @override
  _NurserySalesReportScreenState createState() =>
      _NurserySalesReportScreenState();
}

class _NurserySalesReportScreenState extends State<NurserySalesReportScreen> {
  List<Sale> sales = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSales();
  }

  Future<void> fetchSales() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final nurseryId = currentUser.uid;
    List<Sale> allSales = [];
    Set<String> customerIds = {};

    final userSnapshot =
        await FirebaseFirestore.instance.collection('user_order').get();
    final farmerSnapshot =
        await FirebaseFirestore.instance.collection('farmer_order').get();

    for (var doc in userSnapshot.docs) {
      final data = doc.data();
      final products = List<Map<String, dynamic>>.from(data['products'] ?? []);
      for (var product in products) {
        if (product['nurseryId'] == nurseryId) {
          final userId = data['userId'];
          customerIds.add(userId);
          allSales.add(Sale(
            saleId: doc.id,
            customerName: userId,
            productName: product['productid'] ?? '',
            quantity: product['quantity'] ?? 0,
            totalPrice: (product['price'] ?? 0.0) * (product['quantity'] ?? 0),
            date: (data['orderDate'] as Timestamp?)
                    ?.toDate()
                    .toString()
                    .split(' ')[0] ??
                '',
            status: data['status'] ?? 'unknown',
          ));
        }
      }
    }

    for (var doc in farmerSnapshot.docs) {
      final data = doc.data();
      final products = List<Map<String, dynamic>>.from(data['products'] ?? []);
      for (var product in products) {
        if (product['nurseryId'] == nurseryId) {
          final farmerId = data['farmerId'];
          customerIds.add(farmerId);
          allSales.add(Sale(
            saleId: doc.id,
            customerName: farmerId,
            productName: product['productid'] ?? '',
            quantity: product['quantity'] ?? 0,
            totalPrice: (product['price'] ?? 0.0) * (product['quantity'] ?? 0),
            date: (data['orderDate'] as Timestamp?)
                    ?.toDate()
                    .toString()
                    .split(' ')[0] ??
                '',
            status: data['status'] ?? 'unknown',
          ));
        }
      }
    }

    Map<String, String> customerNames = {};
    for (var id in customerIds) {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      if (userDoc.exists) {
        customerNames[id] = userDoc.data()?['name'] ?? 'Unknown';
        continue;
      }
      final farmerDoc =
          await FirebaseFirestore.instance.collection('farmers').doc(id).get();
      if (farmerDoc.exists) {
        customerNames[id] = farmerDoc.data()?['name'] ?? 'Unknown';
      }
    }

    setState(() {
      sales = allSales
          .map((sale) => Sale(
                saleId: sale.saleId,
                customerName: customerNames[sale.customerName] ?? 'Unknown',
                productName: sale.productName,
                quantity: sale.quantity,
                totalPrice: sale.totalPrice,
                date: sale.date,
                status: sale.status,
              ))
          .toList();
      isLoading = false;
    });
  }

  double getTotalRevenue() {
    return sales.fold(0, (sum, sale) => sum + sale.totalPrice);
  }

  double getRevenueByStatus(String status) {
    return sales
        .where((sale) => sale.status.toLowerCase() == status.toLowerCase())
        .fold(0.0, (sum, sale) => sum + sale.totalPrice);
  }

  int getTotalOrders() => sales.length;

  @override
  Widget build(BuildContext context) {
    final pendingRevenue = getRevenueByStatus("Pending");
    final completedRevenue = getRevenueByStatus("Delivered");

    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Report"),
        backgroundColor: Colors.green[700],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Total Summary
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Revenue",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text("₹${getTotalRevenue().toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Orders",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text("${getTotalOrders()}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // NEW CARD: Revenue by status
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pending\nRevenue",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text("₹${pendingRevenue.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Completed\nRevenue",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text("₹${completedRevenue.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Order List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: sales.length,
                    itemBuilder: (context, index) {
                      final sale = sales[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading:
                              Icon(Icons.shopping_cart, color: Colors.green),
                          title: Text(sale.productName,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Customer: ${sale.customerName}"),
                              Text("Quantity: ${sale.quantity}"),
                              Text("Total Price: ₹${sale.totalPrice}"),
                              Text("Date: ${sale.date}",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text("Status: ${sale.status}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: sale.status == 'Delivered'
                                          ? Colors.teal
                                          : Colors.orange)),
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
