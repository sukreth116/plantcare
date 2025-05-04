import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerOrderEditScreen extends StatefulWidget {
  final DocumentSnapshot orderDoc;

  FarmerOrderEditScreen({required this.orderDoc});

  @override
  _FarmerOrderEditScreenState createState() => _FarmerOrderEditScreenState();
}

class _FarmerOrderEditScreenState extends State<FarmerOrderEditScreen> {
  late TextEditingController _locationController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final data = widget.orderDoc.data() as Map<String, dynamic>;
    _locationController = TextEditingController(text: data['farmerLocation']);
    _phoneController = TextEditingController(text: data['farmerPhone']);
  }

  void updateOrder() async {
    await widget.orderDoc.reference.update({
      'farmerLocation': _locationController.text.trim(),
      'farmerPhone': _phoneController.text.trim(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order updated successfully')),
    );
    Navigator.pop(context);
  }

  void cancelOrder() async {
    await widget.orderDoc.reference.update({
      'status': 'Canceled by farmer',
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order canceled')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Order"),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: "Location"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateOrder,
              child: Text("Update Order"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  foregroundColor: Colors.white),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: cancelOrder,
              child: Text("Cancel Order"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
