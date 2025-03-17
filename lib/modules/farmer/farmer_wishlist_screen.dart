// import 'package:flutter/material.dart';

// class FarmerWishlistScreen extends StatefulWidget {
//   @override
//   _FarmerWishlistScreenState createState() => _FarmerWishlistScreenState();
// }

// class _FarmerWishlistScreenState extends State<FarmerWishlistScreen> {
//   List<Map<String, String>> wishlistItems = [
//     {'name': 'Tractor', 'image': 'asset/image/machinery.png'},
//     {'name': 'Organic Seeds', 'image': 'asset/image/seeds.jpg'},
//     {'name': 'Fertilizer Pack', 'image': 'asset/image/fertilizer.png'},
//     {'name': 'Irrigation Pump', 'image': 'asset/image/plant_sample_1.png'},
//   ];

//   void removeFromWishlist(int index) {
//     setState(() {
//       wishlistItems.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Wishlist'),
//         centerTitle: true,
//       ),
//       body: wishlistItems.isEmpty
//           ? Center(
//               child: Text('No items in wishlist!',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             )
//           : ListView.builder(
//               itemCount: wishlistItems.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     leading: Image.asset(
//                       wishlistItems[index]['image']!,
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                     ),
//                     title: Text(wishlistItems[index]['name']!),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => removeFromWishlist(index),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class FarmerWishlistScreen extends StatefulWidget {
  @override
  _FarmerWishlistScreenState createState() => _FarmerWishlistScreenState();
}

class _FarmerWishlistScreenState extends State<FarmerWishlistScreen> {
  List<Map<String, dynamic>> wishlistItems = [
    {
      'image': 'asset/image/machinery.png',
      'name': 'Tractor',
      'price': 5000.00,
    },
    {
      'image': 'asset/image/plant_sample_1.png',
      'name': 'Organic Seeds',
      'price': 25.99,
    },
    {
      'image': 'asset/image/fertilizer.png',
      'name': 'Fertilizer Pack',
      'price': 15.50,
    },
    {
      'image': 'asset/image/seeds.jpg',
      'name': 'Fertilizer Pack',
      'price': 15.50,
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
        title: Text("Farmer Wishlist"),
        backgroundColor: Colors.green,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(item['image'], width: 50, height: 50),
                    ),
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
