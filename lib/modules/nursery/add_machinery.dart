import 'package:flutter/material.dart';

class AddMachinery extends StatefulWidget {
  @override
  _AddMachineryState createState() => _AddMachineryState();
}

class _AddMachineryState extends State<AddMachinery> {
  final _formKey = GlobalKey<FormState>();
  String machineryName = '';
  String machineryDescription = '';
  double machineryPrice = 0.0;
  String? imagePath;
  int machineryQuantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Add Machinery',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Pinkish',
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Add machinery like Tractors, Tools, Irrigation Equipment, etc. for rental',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Machinery Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a machinery name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        machineryName = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Description",
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        machineryDescription = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Price",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        machineryPrice = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Quantity",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        machineryQuantity = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Implement image picker functionality
                      },
                      icon: Icon(Icons.image, color: Colors.white),
                      label: Text("Upload Image"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        foregroundColor: Colors.white,
                        minimumSize: Size(180, 50),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Machinery Added Successfully!")),
                          );
                        }
                      },
                      child: Text("Add Machinery"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[300],
                        foregroundColor: Colors.white,
                        minimumSize: Size(180, 50),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
