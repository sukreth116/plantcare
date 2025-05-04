// import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:plantcare/about_page.dart';
// import 'package:plantcare/modules/farmer/cart_screen_farmer.dart';
// import 'package:plantcare/modules/farmer/farmer_prduct_list.dart';
// import 'package:plantcare/modules/farmer/farmer_product_add_screen.dart';
// import 'package:plantcare/modules/farmer/farmer_book_work.dart';
// import 'package:plantcare/modules/farmer/farmer_profile.dart';
// import 'package:plantcare/modules/farmer/farmer_search_screen.dart';
// import 'package:plantcare/modules/farmer/farmer_wishlist_screen.dart';
// import 'package:plantcare/modules/farmer/orders_screen_farmer.dart';
// import 'package:plantcare/modules/farmer/product_detail_screen.dart';
// import 'package:plantcare/modules/farmer/rental_orders.dart';
// import 'package:plantcare/AI_detection.dart';
// import 'package:plantcare/news.dart';

// class FarmerHomePage extends StatefulWidget {
//   @override
//   _FarmerHomePageState createState() => _FarmerHomePageState();
// }

// class _FarmerHomePageState extends State<FarmerHomePage> {
//   final User? user = FirebaseAuth.instance.currentUser;
//   String selectedCategory = 'All';
//   List<String> categories = [
//     'All',
//     'Machinery',
//     'Plants',
//     'Seeds',
//     'Fertilizers'
//   ];
//   String farmerName = "Loading...";
//   String farmerImage = "";

//   @override
//   void initState() {
//     super.initState();
//     fetchFarmerDetails();
//   }

//   Future<void> fetchFarmerDetails() async {
//     if (user != null) {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('farmers')
//           .doc(user!.uid)
//           .get();
//       if (snapshot.exists) {
//         setState(() {
//           farmerName = snapshot['name'];
//           // farmerImage = snapshot['imageUrl'] ?? "";
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.symmetric(vertical: 10),
//         color: Colors.white,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(onPressed: () {}, icon: Icon(Icons.home_outlined)),
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AddProductScreen()));
//                 },
//                 icon: Icon(
//                   CupertinoIcons.plus_square_on_square,
//                 )),
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AIDetectionScreen()));
//                 },
//                 icon: Icon(
//                   Icons.party_mode_outlined,
//                 )),
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => NewsPage()));
//                 },
//                 icon: Icon(
//                   Icons.newspaper,
//                 )),
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               FarmerProfilePage(farmerId: user!.uid)));
//                 },
//                 icon: Icon(
//                   Icons.person_outline,
//                 )),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         title: Text(
//           "Manage Your\nFarm Products",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: Icon(CupertinoIcons.search),
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => FarmerSearchScreen()));
//             },
//           ),
//           Builder(
//             builder: (context) => IconButton(
//               icon: Icon(Icons.menu),
//               onPressed: () {
//                 Scaffold.of(context).openEndDrawer();
//               },
//             ),
//           ),
//         ],
//       ),
//       endDrawer: Drawer(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               UserAccountsDrawerHeader(
//                 decoration: BoxDecoration(color: Colors.green[200]),
//                 accountName: Text(farmerName),
//                 accountEmail: Text(user?.email ?? ""),
//                 currentAccountPicture: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               FarmerProfilePage(farmerId: user!.uid)),
//                     );
//                   },
//                   child: CircleAvatar(
//                     backgroundImage: farmerImage.isNotEmpty
//                         ? NetworkImage(farmerImage)
//                         : AssetImage('asset/image/profile_placeholder.jpg')
//                             as ImageProvider,
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(CupertinoIcons.person),
//                 title: Text("Profile"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => FarmerProfilePage(
//                               farmerId: user!.uid,
//                             )),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(CupertinoIcons.rectangle_3_offgrid),
//                 title: Text("All Products"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => FarmerSearchScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(CupertinoIcons.heart),
//                 title: Text("Wishlist"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => FarmerWishlistScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(CupertinoIcons.cart),
//                 title: Text("Cart"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => FarmerCartScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(CupertinoIcons.bag),
//                 title: Text("Orders"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => FarmerOrdersScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(CupertinoIcons.bag_badge_plus),
//                 title: Text("Rental Orders"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => RentalOrdersScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.work),
//                 title: Text("Book a Work"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => FarmerWorkAppointmentScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.add_circle_outline_rounded),
//                 title: Text("Add Product"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AddProductScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(CupertinoIcons.rectangle_stack_badge_person_crop),
//                 title: Text("Your Products"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ViewProductsScreen()),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.party_mode_outlined),
//                 title: Text("AI Detection"),
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AIDetectionScreen()));
//                 },
//               ),

//               ListTile(
//                 leading: Icon(Icons.newspaper),
//                 title: Text("News"),
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => NewsPage()));
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.info_outline),
//                 title: Text("About Us"),
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => AboutPage()));
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
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
//                         'Special Offer',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       Text('Sell more, Earn more!'),
//                     ],
//                   ),
//                   Image.asset('asset/image/machinery.png', width: 70),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: categories.map((category) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                     child: ChoiceChip(
//                       label: Text(category),
//                       selected: selectedCategory == category,
//                       onSelected: (selected) {
//                         setState(() {
//                           selectedCategory = category;
//                         });
//                       },
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             SizedBox(height: 5),
//             Expanded(
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 4,
//                 itemBuilder: (context, index) {
//                   return ProductCard();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProductCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//           // Navigate to product details
//         },
//         child: Container(
//           width: 230,
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
//                     Text('Fresh Apples',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     Text('\$15 per kg',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green)),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   FarmerProductDetailScreen()),
//                         );
//                       },
//                       child: Text(
//                         'View Details',
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
import 'package:plantcare/about_page.dart';
import 'package:plantcare/modules/farmer/farmer_cart_screen.dart';
import 'package:plantcare/modules/farmer/farmer_book_work.dart';
import 'package:plantcare/modules/farmer/farmer_prduct_list.dart';
import 'package:plantcare/modules/farmer/farmer_product_add_screen.dart';
import 'package:plantcare/modules/farmer/farmer_profile.dart';
import 'package:plantcare/modules/farmer/farmer_search_screen.dart';
import 'package:plantcare/modules/farmer/machinery_list.dart';
import 'package:plantcare/modules/farmer/farmer_wishlist_screen.dart';
import 'package:plantcare/modules/farmer/farmer_orders_screen_.dart';
import 'package:plantcare/modules/farmer/farmer_product_detail_screen.dart';
import 'package:plantcare/modules/farmer/farmer_rental_orders.dart';
import 'package:plantcare/news.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});
  @override
  State<FarmerHomePage> createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  int selected = 0;
  bool heart = false;
  final controller = PageController();
  String farmerName = "Loading...";
  String farmerImage = "";

  @override
  void initState() {
    super.initState();
    fetchFarmerDetails(); // Move this to initState
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> fetchFarmerDetails() async {
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('farmers')
          .doc(user!.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          farmerName = snapshot['name'];
          // farmerImage = snapshot['imageUrl'] ?? "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Manage Your\nFarm Products',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: 22,
                  ),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => FarmerCartScreen())),
                ),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.search,
                    size: 22,
                  ),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => FarmerSearchScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green[200]),
                accountName: Text(farmerName),
                accountEmail: Text(user?.email ?? ""),
                currentAccountPicture: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FarmerProfilePage(farmerId: user!.uid)),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: farmerImage.isNotEmpty
                        ? NetworkImage(farmerImage)
                        : AssetImage('asset/image/profile_placeholder.jpg')
                            as ImageProvider,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(CupertinoIcons.person),
                title: Text("Profile"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FarmerProfilePage(
                              farmerId: user!.uid,
                            )),
                  );
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.rectangle_3_offgrid),
                title: Text("All Products"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FarmerSearchScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.rectangle_3_offgrid),
                title: Text("Machineries"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FarmerMachineryScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.cart),
                title: Text("Cart"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FarmerCartScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.bag),
                title: Text("Orders"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FarmerOrdersScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.bag_badge_plus),
                title: Text("Rental Orders"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RentalOrdersScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.work_outline),
                title: Text("Book a Work"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FarmerWorkAppointmentScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.add_circle_outline_rounded),
                title: Text("Add Product"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProductScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.rectangle_stack_badge_person_crop),
                title: Text("Your Products"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewProductsScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("About Us"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
              ),
            ],
          ),
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
        currentIndex: selected,
        onTap: (index) {
          if (index != selected) {
            controller.jumpToPage(index);
            setState(() {
              selected = index;
            });
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => PlantChatBot()));
      //   },
      //   backgroundColor: Colors.white,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      //   child: Icon(heart ? Icons.party_mode : Icons.chat,
      //       color: Colors.green.shade300),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _HomePageContent(user: user),
          FarmerWishlistScreen(),
          AIDetectionScreen(),
          NewsPage(),
          FarmerProfilePage(farmerId: user?.uid ?? ''),
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
          .collection('farmer_wishlist')
          .where('productId', isEqualTo: widget.productId)
          .where('farmerId', isEqualTo: user.uid)
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
          FirebaseFirestore.instance.collection('farmer_wishlist');

      if (isWishlisted) {
        // Remove from wishlist
        final snapshot = await wishlistCollection
            .where('productId', isEqualTo: widget.productId)
            .where('farmerId', isEqualTo: user.uid)
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
          'farmerId': user.uid,
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
            builder: (context) => FarmerProductDetailScreen(
                // productId: widget.productId,
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
                                  .collection('farmer_cart')
                                  .where('productId',
                                      isEqualTo: widget.productId)
                                  .where('farmerId', isEqualTo: user.uid)
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
                                    .collection('farmer_cart')
                                    .add({
                                  'productId': widget.productId,
                                  'name': widget.name,
                                  'price': double.tryParse(widget.price) ?? 0.0,
                                  'imageUrl': widget.imageUrl,
                                  'nurseryId': widget.nurseryId,
                                  'quantity': 1,
                                  'timestamp': FieldValue.serverTimestamp(),
                                  'farmerId': user.uid,
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
