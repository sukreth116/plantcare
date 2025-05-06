import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RentalOrderEditScreen extends StatefulWidget {
  final String rentalOrderId;

  const RentalOrderEditScreen({Key? key, required this.rentalOrderId})
      : super(key: key);

  @override
  State<RentalOrderEditScreen> createState() => _RentalOrderEditScreenState();
}

class _RentalOrderEditScreenState extends State<RentalOrderEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRentalOrder();
  }

  Future<void> _loadRentalOrder() async {
    final doc = await FirebaseFirestore.instance
        .collection('rental_orders')
        .doc(widget.rentalOrderId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _locationController.text = data['farmerLocation'] ?? '';
      _phoneController.text = data['farmerPhone'] ?? '';
    }

    setState(() => isLoading = false);
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('rental_orders')
          .doc(widget.rentalOrderId)
          .update({
        'farmerLocation': _locationController.text.trim(),
        'farmerPhone': _phoneController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rental order updated')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _cancelOrder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cancel Order'),
        content: Text('Are you sure you want to cancel this rental order?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false), child: Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text('Yes')),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance
          .collection('rental_orders')
          .doc(widget.rentalOrderId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rental order cancelled')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Rental Order'),
        backgroundColor: Colors.green.shade300,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(labelText: 'Farmer Location'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter location'
                          : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Farmer Phone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter phone' : null,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade300,
                          foregroundColor: Colors.white),
                      child: Text('Save Changes'),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _cancelOrder,
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white),
                      child: Text('Cancel Order'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
