import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MachineryDetailScreen extends StatefulWidget {
  final String machineryId;

  const MachineryDetailScreen({Key? key, required this.machineryId})
      : super(key: key);

  @override
  State<MachineryDetailScreen> createState() => _MachineryDetailScreenState();
}

class _MachineryDetailScreenState extends State<MachineryDetailScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  void _startPayment(int totalPrice) {
    var options = {
      'key': 'rzp_test_SzQbItYGKXrpzq', // Replace with your Razorpay Test Key
      'amount': (totalPrice * 100).toInt(), // Razorpay uses paise
      'name': 'Greenify Rentals',
      'description': 'Machinery Rental Payment',
      'prefill': {
        'contact': '7510821802',
        'email': 'test@greenify.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Error: $e');
    }
  }

  void _showRentDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    int days = 1;
    int quantity = 1;
    bool agreed = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Rent Machinery"),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: '1',
                        decoration:
                            InputDecoration(labelText: "Number of Days"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              int.tryParse(value) == null ||
                              int.parse(value) < 1) {
                            return "Enter a valid number of days";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          days = int.tryParse(value) ?? 1;
                        },
                      ),
                      TextFormField(
                        initialValue: '1',
                        decoration: InputDecoration(labelText: "Quantity"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              int.tryParse(value) == null ||
                              int.parse(value) < 1) {
                            return "Enter a valid quantity";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          quantity = int.tryParse(value) ?? 1;
                        },
                      ),
                      TextButton(
                        onPressed: () => _showAgreementDialog(context),
                        child: Text("View Agreement"),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: agreed,
                            onChanged: (val) {
                              setState(() {
                                agreed = val ?? false;
                              });
                            },
                          ),
                          Flexible(
                            child: Text("I agree to the terms"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (!agreed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please agree to the terms")),
                        );
                        return;
                      }

                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      final docSnapshot = await FirebaseFirestore.instance
                          .collection('machinery')
                          .doc(widget.machineryId)
                          .get();

                      final farmerSnapshot = await FirebaseFirestore.instance
                          .collection('farmers')
                          .doc(user.uid)
                          .get();
                      final farmerData = farmerSnapshot.data()!;
                      final farmerPhone = farmerData['phone'];
                      final farmerLocation = farmerData['address'];

                      final data = docSnapshot.data()!;
                      // final price = data['price'];
                      final price = (data['price'] as num).toInt();

                      final nurseryId = data['nurseryId'];

                      // final rentalCharge = days * 100;
                      final rentalCharge = days > 1 ? days * 100 : 0;
                      final itemTotal = quantity * price;
                      final totalPrice = rentalCharge + itemTotal;

                      // Add rental order to Firestore
                      await FirebaseFirestore.instance
                          .collection('rental_orders')
                          .add({
                        'machineryId': widget.machineryId,
                        'farmerId': user.uid,
                        'nurseryId': nurseryId,
                        'price': price,
                        'quantity': quantity,
                        'days': days,
                        'rentalCharge': rentalCharge,
                        'itemTotal': itemTotal,
                        'totalPrice': totalPrice,
                        'status': 'pending',
                        'farmerPhone':farmerPhone,
                        'farmerLocation':farmerLocation,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      await FirebaseFirestore.instance
                          .collection('machinery')
                          .doc(widget.machineryId)
                          .update({
                        'quantity': FieldValue.increment(-quantity),
                      });

                      Navigator.pop(context);

                      _startPayment(totalPrice);
                    }
                  },
                  child: Text("Confirm & Pay"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAgreementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Rental Agreement"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• The item must be returned in good condition."),
              Text("• Any damage will incur additional charges."),
              Text("• Rental charges are non-refundable."),
              Text("• Rented item must be returned on or before due date."),
              Text("• Contact support for issues during rental period."),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final machineryRef = FirebaseFirestore.instance
        .collection('machinery')
        .doc(widget.machineryId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Machinery Details"),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: machineryRef.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('Error fetching details'));
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (!snapshot.data!.exists)
            return Center(child: Text('Machinery not found'));

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data['imageUrl'] != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        data['imageUrl'],
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                Text(
                  data['name'] ?? 'No Name',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                SizedBox(height: 10),
                Text(data['description'] ?? 'No Description'),
                SizedBox(height: 10),
                Text('Price: ₹${data['price']}'),
                SizedBox(height: 5),
                Text('Quantity: ${data['quantity']}'),
                SizedBox(height: 5),
                Text(
                  'Availability: ${data['availability']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: data['availability'] == 'Available'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _showRentDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text("Rent this Item",
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}
