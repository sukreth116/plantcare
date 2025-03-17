import 'package:flutter/material.dart';

class FarmerCartScreen extends StatefulWidget {
  @override
  _FarmerCartScreenState createState() => _FarmerCartScreenState();
}

class _FarmerCartScreenState extends State<FarmerCartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "Organic Seeds",
      "price": 29.99,
      "image": "asset/image/seeds.jpg",
      "quantity": 2,
    },
    {
      "name": "Fertilizer Pack",
      "price": 49.99,
      "image": "asset/image/fertilizer.png",
      "quantity": 1,
    },
    {
      "name": "Vazha",
      "price": 49.99,
      "image": "asset/image/fertilizer.png",
      "quantity": 1,
    },
  ];

  double getTotalPrice() {
    return cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farmer Cart"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading:
                              Image.asset(item['image'], width: 50, height: 50),
                          title: Text(item['name']),
                          subtitle:
                              Text("\$${item['price'].toStringAsFixed(2)}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    if (item['quantity'] > 1) {
                                      item['quantity'] -= 1;
                                    } else {
                                      cartItems.removeAt(index);
                                    }
                                  });
                                },
                              ),
                              Text(item['quantity'].toString()),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    item['quantity'] += 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("\$${getTotalPrice().toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to checkout screen (implement later)
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text("Proceed to Checkout",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
