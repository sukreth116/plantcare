import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MachineryDetailScreen extends StatelessWidget {
  final String machineryId;

  const MachineryDetailScreen({Key? key, required this.machineryId})
      : super(key: key);

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: '1',
                      decoration: InputDecoration(labelText: "Number of Days"),
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
                          child: Row(
                            children: [
                              Text("I agree to the "),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!agreed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please agree to the terms")),
                        );
                        return;
                      }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Item rented successfully")),
                      );
                    }
                  },
                  child: Text("Confirm"),
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
    final machineryRef =
        FirebaseFirestore.instance.collection('machinery').doc(machineryId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Machinery Details"),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: machineryRef.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching details'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return Center(child: Text('Machinery not found'));
          }

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
                Text(
                  data['description'] ?? 'No Description',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Price: ₹${data['price']}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  'Quantity: ${data['quantity']}',
                  style: TextStyle(fontSize: 16),
                ),
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
          onPressed: () {
            _showRentDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            "Rent this Item",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
