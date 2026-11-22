import 'package:cloud_firestore/cloud_firestore.dart';

class CartUtils {
  /// Calculates the total price of all items in a cart snapshot list.
  static double calculateTotalPrice(List<DocumentSnapshot> cartItems) {
    return cartItems.fold(0.0, (sum, item) {
      final data = item.data() as Map<String, dynamic>;
      final price = double.tryParse(data['price'].toString()) ?? 0.0;
      final quantity = data['quantity'] ?? 1;
      return sum + (price * quantity);
    });
  }

  /// Increments the quantity of an item in the cart.
  static Future<void> increaseQuantity(DocumentSnapshot item) async {
    final docRef = item.reference;
    final data = item.data() as Map<String, dynamic>;
    await docRef.update({'quantity': (data['quantity'] ?? 1) + 1});
  }

  /// Decrements the quantity of an item, or removes it if quantity reaches 0.
  static Future<void> decreaseQuantity(DocumentSnapshot item) async {
    final docRef = item.reference;
    final data = item.data() as Map<String, dynamic>;
    if ((data['quantity'] ?? 1) > 1) {
      await docRef.update({'quantity': (data['quantity'] ?? 1) - 1});
    } else {
      await docRef.delete();
    }
  }
}
