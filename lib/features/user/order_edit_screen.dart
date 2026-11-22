import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrderEditScreen extends StatefulWidget {
  final DocumentSnapshot orderDoc;

  const UserOrderEditScreen({super.key, required this.orderDoc});

  @override
  _UserOrderEditScreenState createState() => _UserOrderEditScreenState();
}

class _UserOrderEditScreenState extends State<UserOrderEditScreen> {
  late TextEditingController _locationController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final data = widget.orderDoc.data() as Map<String, dynamic>;
    _locationController = TextEditingController(text: data['userLocation']);
    _phoneController = TextEditingController(text: data['userPhone']);
  }

  void updateOrder() async {
    await widget.orderDoc.reference.update({
      'userLocation': _locationController.text.trim(),
      'userPhone': _phoneController.text.trim(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order updated successfully')),
    );
    Navigator.pop(context);
  }

  void cancelOrder() async {
    await widget.orderDoc.reference.update({
      'status': 'Canceled by user',
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
      backgroundColor: Colors.white,
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  foregroundColor: Colors.white),
              child: Text("Update Order"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: cancelOrder,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: Text("Cancel Order"),
            ),
          ],
        ),
      ),
    );
  }
}
