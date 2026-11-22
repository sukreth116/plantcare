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
