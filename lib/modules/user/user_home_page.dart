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

import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantcare/AI_detection.dart';
import 'package:plantcare/modules/user/cart_screen_user.dart';
import 'package:plantcare/modules/user/chatbot.dart';
import 'package:plantcare/news.dart';
import 'package:plantcare/modules/user/orders_screen_user.dart';
import 'package:plantcare/modules/user/product_details.dart';
import 'package:plantcare/modules/user/search_screen.dart';
import 'package:plantcare/modules/user/user_profile.dart';
import 'package:plantcare/modules/user/wishlist.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});
  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int selected = 0;
  bool heart = false;
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Find your\nfavorite plants',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined,
                      size: 22, color: Colors.black),
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => CartScreen())),
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.bag, size: 22, color: Colors.black),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => UserOrderScreen())),
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.search,
                      size: 22, color: Colors.black),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => UserSearchScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(iconStyle: IconStyle.animated),
        items: [
          BottomBarItem(
            icon: Icon(Icons.house_outlined),
            selectedIcon: Icon(Icons.house_rounded),
            selectedColor: Colors.green.shade300,
            title: Text('Home'),
          ),
          BottomBarItem(
            icon: Icon(CupertinoIcons.heart),
            selectedIcon: Icon(CupertinoIcons.heart_circle_fill),
            selectedColor: Colors.green.shade300,
            title: Text('Wishlist'),
          ),
          BottomBarItem(
            icon: Icon(Icons.party_mode_outlined),
            selectedIcon: Icon(Icons.party_mode),
            selectedColor: Colors.green.shade300,
            title: Text('AI Detection'),
          ),
          BottomBarItem(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper),
            selectedColor: Colors.green.shade300,
            title: Text('News'),
          ),
          BottomBarItem(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            selectedColor: Colors.green.shade300,
            title: Text('Profile'),
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: selected,
        notchStyle: NotchStyle.circle,
        onTap: (index) {
          if (index != selected) {
            controller.jumpToPage(index);
            setState(() {
              selected = index;
            });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PlantChatBot()));
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(heart ? Icons.party_mode : Icons.chat,
            color: Colors.green.shade300),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _HomePageContent(user: user),
          WishlistScreen(),
          AIDetectionScreen(),
          NewsPage(),
          UserProfilePage(userId: user?.uid ?? ''),
        ],
      ),
    );
  }
}

class _HomePageContent extends StatefulWidget {
  final User? user;

  const _HomePageContent({required this.user});
  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  String selectedCategory = '';

  final categories = [
    'Flowering plants',
    'Non-flowering plants',
    'Trees',
    'Shrubs',
    'Herbs',
    'Climbers and Creepers',
    'Succulents',
    'Aquatic plants',
    'Indoor plants',
    'Medicinal plants',
    'Carnivorous plants',
    'Ornamental plants',
  ];
  Set<String> selectedCategories = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      // Added SingleChildScrollView here
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
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
                          Text('30% OFF',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('02 - 23 July'),
                        ],
                      ),
                      Image.asset('asset/image/plant_sample_2.png', width: 60),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Popular Plants",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((label) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: FilterChip(
                          label: Text(label),
                          selected: selectedCategory == label,
                          onSelected: (bool value) {
                            setState(() {
                              selectedCategory = value ? label : '';
                            });
                          },
                          selectedColor: Colors.green.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            // Added SizedBox to provide some spacing
            height: 450, // Adjust height as needed
            child: StreamBuilder<QuerySnapshot>(
              stream: selectedCategory.isEmpty
                  ? FirebaseFirestore.instance
                      .collection('nursery_products')
                      .where('category', isEqualTo: 'Plants')
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('nursery_products')
                      .where('subCategory', isEqualTo: selectedCategory)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No Products Found'));
                }

                final products = snapshot.data!.docs;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 10),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return PlantCard(
                      productId: product.id,
                      nurseryId: product['nurseryId'],
                      name: product['name'] ?? 'Unknown',
                      price: product['price'].toString(),
                      imageUrl: product['imageUrl'] ?? '',
                      description: product['description'] ?? '',
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("Pots",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            // Added SizedBox to provide some spacing
            height: 400, // Adjust height as needed
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('nursery_products')
                  .where('category', isEqualTo: 'Pots')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No Products Found'));
                }

                final products = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.only(left: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return PlantCard(
                      productId: product.id,
                      nurseryId: product['nurseryId'],
                      name: product['name'] ?? 'Unknown',
                      price: product['price'].toString(),
                      imageUrl: product['imageUrl'] ?? '',
                      description: product['description'] ?? '',
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("Fertilizers",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            // Added SizedBox to provide some spacing
            height: 400, // Adjust height as needed
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('nursery_products')
                  .where('category', isEqualTo: 'Pots')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No Products Found'));
                }

                final products = snapshot.data!.docs;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 10),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return PlantCard(
                      productId: product.id,
                      nurseryId: product['nurseryId'],
                      name: product['name'] ?? 'Unknown',
                      price: product['price'].toString(),
                      imageUrl: product['imageUrl'] ?? '',
                      description: product['description'] ?? '',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlantCard extends StatefulWidget {
  final String name;
  final String price;
  final String imageUrl;
  final String productId;
  final String nurseryId;
  final String description;

  PlantCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.productId,
    required this.nurseryId,
    required this.description,
  });

  @override
  _PlantCardState createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    checkIfWishlisted();
  }

  void checkIfWishlisted() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final wishlistRef = FirebaseFirestore.instance
          .collection('wishlist')
          .where('productId', isEqualTo: widget.productId)
          .where('userId', isEqualTo: user.uid)
          .limit(1);

      final snapshot = await wishlistRef.get();

      if (mounted) {
        // <--- ADD THIS
        setState(() {
          isWishlisted = snapshot.docs.isNotEmpty;
        });
      }
    }
  }

  void toggleWishlist() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final wishlistCollection =
          FirebaseFirestore.instance.collection('wishlist');

      if (isWishlisted) {
        // Remove from wishlist
        final snapshot = await wishlistCollection
            .where('productId', isEqualTo: widget.productId)
            .where('userId', isEqualTo: user.uid)
            .get();

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        if (mounted) {
          setState(() {
            isWishlisted = false;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from Wishlist')),
        );
      } else {
        // Add to wishlist
        await wishlistCollection.add({
          'productId': widget.productId,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          setState(() {
            isWishlisted = true;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to Wishlist')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to use wishlist')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productId: widget.productId,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.all(10.0),
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
                  widget.imageUrl,
                  fit: BoxFit.fill,
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\₹${widget.price}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final User? user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            try {
                              final cartRef = FirebaseFirestore.instance
                                  .collection('user_cart')
                                  .where('productId',
                                      isEqualTo: widget.productId)
                                  .where('userId', isEqualTo: user.uid)
                                  .limit(1);

                              final cartSnapshot = await cartRef.get();

                              if (cartSnapshot.docs.isNotEmpty) {
                                final cartItem = cartSnapshot.docs.first;
                                final currentQuantity = cartItem['quantity'];
                                final updatedQuantity = currentQuantity + 1;

                                await cartItem.reference.update({
                                  'quantity': updatedQuantity,
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Item Again Added to Cart')),
                                );
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('user_cart')
                                    .add({
                                  'productId': widget.productId,
                                  'name': widget.name,
                                  'price': double.tryParse(widget.price) ?? 0.0,
                                  'imageUrl': widget.imageUrl,
                                  'nurseryId': widget.nurseryId,
                                  'quantity': 1,
                                  'timestamp': FieldValue.serverTimestamp(),
                                  'userId': user.uid,
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                    'Added to Cart',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to add to cart: $e')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please log in to add items to your cart')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      IconButton(
                        onPressed: toggleWishlist,
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? Colors.black : Colors.black,
                        ),
                      ),
                      SizedBox(width: 1),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
