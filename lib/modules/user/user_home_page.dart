// import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:plantcare/AI_detection.dart';
// import 'package:plantcare/modules/user/cart_screen_user.dart';
// import 'package:plantcare/modules/user/news.dart';
// import 'package:plantcare/modules/user/orders_screen_user.dart';
// import 'package:plantcare/modules/user/product_details.dart';
// import 'package:plantcare/modules/user/search_screen.dart';
// import 'package:plantcare/modules/user/user_profile.dart';
// import 'package:plantcare/modules/user/wishlist.dart';

// class UserHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final User? user = FirebaseAuth.instance.currentUser; // Get current user
//     return Scaffold(
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.symmetric(vertical: 10),
//         color: Colors.white,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//                 onPressed: () {},
//                 icon: Icon(Icons.home_outlined, color: Colors.black)),
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => WishlistScreen()));
//                 },
//                 icon: Icon(Icons.favorite_border, color: Colors.black)),
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AIDetectionScreen()));
//                 },
//                 icon: Icon(Icons.party_mode_outlined,
//                     color: Colors.black)), // Camera
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => NewsPage()));
//                 },
//                 icon: Icon(Icons.newspaper, color: Colors.black)),
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               UserProfilePage(userId: user!.uid)));
//                 },
//                 icon:
//                     Icon(Icons.person_outline, color: Colors.black)), // Profile
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Find your\nfavorite plants',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => CartScreen()));
//                       },
//                       icon: Icon(
//                         Icons.shopping_cart_outlined,
//                         size: 22,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => OrdersScreen()));
//                       },
//                       icon: Icon(
//                         CupertinoIcons.bag,
//                         size: 22,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => UserSearchScreen()));
//                       },
//                       icon: Icon(
//                         CupertinoIcons.search,
//                         size: 22,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade100,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '30% OFF',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       Text('02 - 23 July'),
//                     ],
//                   ),
//                   Image.asset('asset/image/plant_sample_2.png', width: 60),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 FilterChip(
//                   label: Text('All'),
//                   onSelected: (_) {},
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(50), // Maximum border radius
//                   ),
//                 ),
//                 FilterChip(
//                   label: Text('Indoor'),
//                   onSelected: (_) {},
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(50), // Maximum border radius
//                   ),
//                 ),
//                 FilterChip(
//                   label: Text('Outdoor'),
//                   onSelected: (_) {},
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(50), // Maximum border radius
//                   ),
//                 ),
//                 FilterChip(
//                   label: Text('Popular'),
//                   onSelected: (_) {},
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(50), // Maximum border radius
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 4,
//                 itemBuilder: (context, index) {
//                   return PlantCard();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PlantCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProductDetailScreen(),
//             ),
//           );
//         },
//         child: Container(
//           width: 200,
//           margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//           decoration: BoxDecoration(
//             color: Colors.grey[300],
//             borderRadius: BorderRadius.circular(25),
//           ),
//           child: Column(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//                   child: Image.asset(
//                     'asset/image/plant_sample_1.png',
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(width: 2),
//                         Text('Monstera',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold)),
//                         Text('\$39',
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.green)),
//                         SizedBox(
//                           width: 2,
//                         )
//                       ],
//                     ),
//                     SizedBox(height: 2),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(width: 1),
//                         ElevatedButton(
//                           onPressed: () {},
//                           child: Text(
//                             'Add to Cart',
//                             style: TextStyle(color: Colors.black, fontSize: 12),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             // Navigate to Wishlist page or add to wishlist functionality
//                           },
//                           icon: Icon(Icons.favorite_border),
//                         ),
//                         SizedBox(width: 1),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
// import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:plantcare/AI_detection.dart';
// import 'package:plantcare/modules/user/cart_screen_user.dart';
// import 'package:plantcare/modules/user/news.dart';
// import 'package:plantcare/modules/user/orders_screen_user.dart';
// import 'package:plantcare/modules/user/product_details.dart';
// import 'package:plantcare/modules/user/search_screen.dart';
// import 'package:plantcare/modules/user/user_profile.dart';
// import 'package:plantcare/modules/user/wishlist.dart';
// import 'package:rxdart/rxdart.dart';

// class UserHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final User? user = FirebaseAuth.instance.currentUser; // Get current user
//     return Scaffold(
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.symmetric(vertical: 10),
//         color: Colors.white,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//                 onPressed: () {},
//                 icon: Icon(Icons.home_outlined, color: Colors.black)),
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => WishlistScreen()));
//                 },
//                 icon: Icon(Icons.favorite_border, color: Colors.black)),
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AIDetectionScreen()));
//                 },
//                 icon: Icon(Icons.party_mode_outlined,
//                     color: Colors.black)), // Camera
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => NewsPage()));
//                 },
//                 icon: Icon(Icons.newspaper, color: Colors.black)),
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               UserProfilePage(userId: user!.uid)));
//                 },
//                 icon: Icon(Icons.person_outline, color: Colors.black)),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Find your\nfavorite plants',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => CartScreen()));
//                       },
//                       icon: Icon(
//                         Icons.shopping_cart_outlined,
//                         size: 22,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => OrdersScreen()));
//                       },
//                       icon: Icon(
//                         CupertinoIcons.bag,
//                         size: 22,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => UserSearchScreen()));
//                       },
//                       icon: Icon(
//                         CupertinoIcons.search,
//                         size: 22,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade100,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '30% OFF',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       Text('02 - 23 July'),
//                     ],
//                   ),
//                   Image.asset('asset/image/plant_sample_2.png', width: 60),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 FilterChip(
//                   label: Text('All'),
//                   onSelected: (_) {},
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 FilterChip(
//                   label: Text('Indoor'),
//                   onSelected: (_) {},
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 FilterChip(
//                   label: Text('Outdoor'),
//                   onSelected: (_) {},
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 FilterChip(
//                   label: Text('Popular'),
//                   onSelected: (_) {},
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collectionGroup('farmer_products')
//                     .snapshots(), // Fetches from all 'products' subcollections
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return Center(child: Text('No Products Found'));
//                   }

//                   final products = snapshot.data!.docs;

//                   return ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: products.length,
//                     itemBuilder: (context, index) {
//                       var product = products[index];
//                       return PlantCard(
//                         name: product['name'] ?? 'Unknown',
//                         price: product['price']?.toString() ?? '0',
//                         imageUrl: product['imageUrl'] ??
//                             'https://via.placeholder.com/150', // default image
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PlantCard extends StatelessWidget {
//   final String name;
//   final String price;
//   final String imageUrl;

//   PlantCard({required this.name, required this.price, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProductDetailScreen(),
//             ),
//           );
//         },
//         child: Container(
//           width: 200,
//           margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//           decoration: BoxDecoration(
//             color: Colors.grey[300],
//             borderRadius: BorderRadius.circular(25),
//           ),
//           child: Column(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Image.asset(
//                         'asset/image/plant_sample_1.png',
//                         fit: BoxFit.cover,
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       name,
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       '\$$price',
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green),
//                     ),
//                     SizedBox(height: 8),
//                     ElevatedButton(
//                       onPressed: () {},
//                       child: Text(
//                         'Add to Cart',
//                         style: TextStyle(color: Colors.black, fontSize: 12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantcare/AI_detection.dart';
import 'package:plantcare/modules/user/cart_screen_user.dart';
import 'package:plantcare/modules/user/news.dart';
import 'package:plantcare/modules/user/orders_screen_user.dart';
import 'package:plantcare/modules/user/product_details.dart';
import 'package:plantcare/modules/user/search_screen.dart';
import 'package:plantcare/modules/user/user_profile.dart';
import 'package:plantcare/modules/user/wishlist.dart';
import 'package:rxdart/rxdart.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.home_outlined, color: Colors.black)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WishlistScreen()));
                },
                icon: Icon(Icons.favorite_border, color: Colors.black)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AIDetectionScreen()));
                },
                icon: Icon(Icons.party_mode_outlined, color: Colors.black)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewsPage()));
                },
                icon: Icon(Icons.newspaper, color: Colors.black)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserProfilePage(userId: user!.uid)));
                },
                icon: Icon(Icons.person_outline, color: Colors.black)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Find your\nfavorite plants',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen()));
                      },
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        size: 22,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrdersScreen()));
                      },
                      icon: Icon(
                        CupertinoIcons.bag,
                        size: 22,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserSearchScreen()));
                      },
                      icon: Icon(
                        CupertinoIcons.search,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '30% OFF',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('02 - 23 July'),
                    ],
                  ),
                  Image.asset('asset/image/plant_sample_2.png', width: 60),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterChip(
                  label: Text('All'),
                  onSelected: (_) {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                FilterChip(
                  label: Text('Indoor'),
                  onSelected: (_) {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                FilterChip(
                  label: Text('Outdoor'),
                  onSelected: (_) {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                FilterChip(
                  label: Text('Popular'),
                  onSelected: (_) {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<QuerySnapshot>>(
                stream: CombineLatestStream.list([
                  FirebaseFirestore.instance
                      .collectionGroup('farmer_products')
                      .snapshots(),
                  FirebaseFirestore.instance
                      .collectionGroup('nursery_products')
                      .snapshots(),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData ||
                      snapshot.data!.every((snap) => snap.docs.isEmpty)) {
                    return Center(child: Text('No Products Found'));
                  }

                  // Merge both collections
                  final allProducts = snapshot.data!
                      .expand((querySnap) => querySnap.docs)
                      .toList();

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allProducts.length,
                    itemBuilder: (context, index) {
                      var product = allProducts[index];
                      return PlantCard(
                        name: product['name'] ?? 'Unknown',
                        price: product['price']?.toString() ?? '0',
                        imageUrl: product['imageUrl'] ??
                            'https://via.placeholder.com/150',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;

  PlantCard({required this.name, required this.price, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(),
            ),
          );
        },
        child: Container(
          width: 200,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'asset/image/plant_sample_1.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$$price',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('cart')
                              .add({
                            'name': name,
                            'price': price,
                            'imageUrl': imageUrl,
                            'quantity': 1, // starting with 1
                            'addedAt': FieldValue.serverTimestamp(),
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added to cart!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please log in to add to cart.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
