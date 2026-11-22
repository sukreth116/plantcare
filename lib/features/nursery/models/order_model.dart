import 'package:cloud_firestore/cloud_firestore.dart';

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
