import 'package:cloud_firestore/cloud_firestore.dart';

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
