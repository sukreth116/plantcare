import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, dynamic>> wishlistItems = [
    {
      'image': 'asset/image/plant_sample_1.png',
      'name': 'Aloe Vera',
      'price': 29.99,
    },
    {
      'image': 'asset/image/plant_sample_1.png',
      'name': 'Bonsai Tree',
      'price': 49.99,
    },
  ];

  void removeFromWishlist(int index) {
    setState(() {
      wishlistItems.removeAt(index);
    });
  }

  void moveToCart(int index) {
    // Implement logic to add item to cart
    setState(() {
      wishlistItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Moved to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Wishlist"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: wishlistItems.isEmpty
          ? Center(child: Text("Your wishlist is empty"))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset(item['image'], width: 50, height: 50),
                    title: Text(item['name'], style: TextStyle(fontSize: 18)),
                    subtitle: Text("\$${item['price']}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.shopping_cart, color: Colors.green),
                          onPressed: () => moveToCart(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeFromWishlist(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
