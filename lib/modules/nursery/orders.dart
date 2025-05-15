import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Product {
  final String productId;
  final String name;
  final String imageUrl;
  final String nurseryId;
  final double price;
  final int quantity;

  Product({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.nurseryId,
    required this.price,
    required this.quantity,
  });

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      productId: data['productId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      nurseryId: data['nurseryId'] ?? '',
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
    );
  }
}

enum OrderSource { user, farmer }

class Order {
  final String orderId;
  String status;
  final double totalAmount;
  final int totalQuantity;
  final String customerId;
  final String customerLocation;
  final String customerPhone;
  final DateTime orderDate;
  final List<Product> products;
  final OrderSource source;
  double get totalPrice {
    return products.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  Order({
    required this.orderId,
    required this.status,
    required this.totalAmount,
    required this.totalQuantity,
    required this.customerId,
    required this.customerLocation,
    required this.customerPhone,
    required this.orderDate,
    required this.products,
    required this.source,
  });

  factory Order.fromFirestore(DocumentSnapshot doc, OrderSource source) {
    final data = doc.data() as Map<String, dynamic>;
    final List<Product> productList = (data['products'] as List<dynamic>)
        .map((p) => Product.fromMap(p))
        .toList();

    return Order(
      orderId: data['orderId'] ?? doc.id,
      status: data['status'] ?? 'Pending',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      totalQuantity: data['totalQuantity'] ?? 0,
      customerId: source == OrderSource.user
          ? data['userId'] ?? ''
          : data['farmerId'] ?? '',
      customerLocation: source == OrderSource.user
          ? data['userLocation'] ?? ''
          : data['farmerLocation'] ?? '',
      customerPhone: source == OrderSource.user
          ? data['userPhone'] ?? ''
          : data['farmerPhone'] ?? '',
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      products: productList,
      source: source,
    );
  }
}

class SaleOrderScreen extends StatefulWidget {
  @override
  _SaleOrderScreenState createState() => _SaleOrderScreenState();
}

class _SaleOrderScreenState extends State<SaleOrderScreen> {
  List<Order> orders = [];

  // Future<void> fetchOrders() async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) return;

  //   final userSnapshot = await FirebaseFirestore.instance
  //       .collection('user_order')
  //       .where('nurseryId', isEqualTo: currentUser.uid)
  //       .get();
  //   final farmerSnapshot = await FirebaseFirestore.instance
  //       .collection('farmer_order')
  //       .where('nurseryId', isEqualTo: currentUser.uid)
  //       .get();

  //   final userOrders = userSnapshot.docs
  //       .map((doc) => Order.fromFirestore(doc, OrderSource.user));
  //   final farmerOrders = farmerSnapshot.docs
  //       .map((doc) => Order.fromFirestore(doc, OrderSource.farmer));

  //   setState(() {
  //     orders = [...userOrders, ...farmerOrders];
  //   });
  // }
  Future<void> fetchOrders() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final uid = currentUser.uid;

    final userSnapshot =
        await FirebaseFirestore.instance.collection('user_order').get();
    final farmerSnapshot =
        await FirebaseFirestore.instance.collection('farmer_order').get();

    final userOrders = userSnapshot.docs
        .map((doc) => Order.fromFirestore(doc, OrderSource.user))
        .where((order) =>
            order.products.any((product) => product.nurseryId == uid))
        .toList();

    final farmerOrders = farmerSnapshot.docs
        .map((doc) => Order.fromFirestore(doc, OrderSource.farmer))
        .where((order) =>
            order.products.any((product) => product.nurseryId == uid))
        .toList();

    setState(() {
      orders = [...userOrders, ...farmerOrders];
    });
  }

  void updateStatus(int index, String newStatus) {
    setState(() {
      orders[index] = Order(
        orderId: orders[index].orderId,
        status: newStatus,
        totalAmount: orders[index].totalAmount,
        totalQuantity: orders[index].totalQuantity,
        customerId: orders[index].customerId,
        customerLocation: orders[index].customerLocation,
        customerPhone: orders[index].customerPhone,
        orderDate: orders[index].orderDate,
        products: orders[index].products,
        source: orders[index].source,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
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
            onPressed: fetchOrders,
          ),
        ],
      ),
      body: orders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection(order.source == OrderSource.user
                          ? 'users'
                          : 'farmers')
                      .doc(order.customerId)
                      .get(),
                  builder: (context, snapshot) {
                    String name = 'Loading...';
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData &&
                        snapshot.data!.data() != null) {
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      name = data['name'] ?? 'Unknown';
                    }

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                        title: Text("Order ID: ${order.orderId}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "From: ${order.source == OrderSource.user ? "User" : "Farmer"}"),
                            Text("Name: $name"),
                            Text("Phone: ${order.customerPhone}"),
                            Text("Location: ${order.customerLocation}"),
                            Text(
                                "Total: \$${order.totalPrice.toStringAsFixed(2)}"),
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
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (newStatus) =>
                              updateStatus(index, newStatus),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: "Pending", child: Text("Pending")),
                            PopupMenuItem(
                                value: "Shipped", child: Text("Shipped")),
                            PopupMenuItem(
                                value: "Delivered", child: Text("Delivered")),
                          ],
                          icon: Icon(Icons.more_vert),
                        ),
                        children: order.products.map((product) {
                          return ListTile(
                            leading: Image.network(
                              product.imageUrl,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text("Product Name: ${product.name}"),
                            subtitle: Text(
                                "Qty: ${product.quantity} | Price: \$${product.price}"),
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
