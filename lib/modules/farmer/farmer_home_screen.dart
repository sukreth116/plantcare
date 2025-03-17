// // import 'package:flutter/cupertino.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:plantcare/modules/farmer/farmer_profile.dart';
// // import 'package:plantcare/modules/user/news.dart';

// // class FarmerHomePage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final User? user = FirebaseAuth.instance.currentUser;
// //     return Scaffold(
// //       bottomNavigationBar: Container(
// //         padding: EdgeInsets.symmetric(vertical: 10),
// //         color: Colors.white,
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceAround,
// //           children: [
// //             IconButton(
// //                 onPressed: () {},
// //                 icon: Icon(Icons.home_outlined, color: Colors.black)),
// //             IconButton(
// //                 onPressed: () {
// //                   // Navigator.push(
// //                   //     context,
// //                   //     MaterialPageRoute(
// //                   //         builder: (context) => FarmerOrdersScreen()));
// //                 },
// //                 icon: Icon(CupertinoIcons.heart, color: Colors.black)),
// //             IconButton(
// //                 onPressed: () {
// //                   // Navigator.push(
// //                   //     context,
// //                   //     MaterialPageRoute(
// //                   //         builder: (context) => FarmerAddProduct()));
// //                 },
// //                 icon: Icon(Icons.add_box_outlined, color: Colors.black)),
// //             IconButton(
// //                 onPressed: () {
// //                   Navigator.push(context,
// //                       MaterialPageRoute(builder: (context) => NewsPage()));
// //                 },
// //                 icon: Icon(Icons.newspaper, color: Colors.black)),
// //             IconButton(
// //                 onPressed: () {
// //                   Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                           builder: (context) =>
// //                               FarmerProfilePage(farmerId: user!.uid)));
// //                 },
// //                 icon: Icon(Icons.person_outline, color: Colors.black)),
// //           ],
// //         ),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             SizedBox(height: 20),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Text(
// //                   'Manage Your \nFarm Products',
// //                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //                 ),
// //                 IconButton(
// //                   onPressed: () {},
// //                   icon: Icon(CupertinoIcons.shopping_cart),
// //                 ),
// //                 IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.bag)),
// //                 IconButton(
// //                   onPressed: () {
// //                     // Navigator.push(
// //                     //     context,
// //                     //     MaterialPageRoute(
// //                     //         builder: (context) => FarmerProductsScreen()));
// //                   },
// //                   icon: Icon(
// //                     CupertinoIcons.search,
// //                     size: 22,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 20),
// //             Container(
// //               padding: EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: Colors.green.shade100,
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         'Special Offer',
// //                         style: TextStyle(
// //                             fontSize: 20, fontWeight: FontWeight.bold),
// //                       ),
// //                       Text('Sell more, Earn more!'),
// //                     ],
// //                   ),
// //                   Image.asset('asset/image/machinery.png', width: 70),
// //                 ],
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             Expanded(
// //               child: ListView.builder(
// //                 scrollDirection: Axis.horizontal,
// //                 itemCount: 4,
// //                 itemBuilder: (context, index) {
// //                   return ProductCard();
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// class ProductCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//           // Navigate to product details
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
//                     Text('Fresh Apples',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     Text('\$15 per kg',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green)),
//                     ElevatedButton(
//                       onPressed: () {},
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
//         )
//       );
//   }
// }
// import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:plantcare/modules/farmer/farmer_profile.dart';
// import 'package:plantcare/modules/user/news.dart';

// class FarmerHomePage extends StatefulWidget {
//   @override
//   _FarmerHomePageState createState() => _FarmerHomePageState();
// }

// class _FarmerHomePageState extends State<FarmerHomePage> {
//   final User? user = FirebaseAuth.instance.currentUser;
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
//       drawer: Drawer(
//         child: Column(
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text(farmerName),
//               accountEmail: Text(user?.email ?? ""),
//               currentAccountPicture: CircleAvatar(
//                 backgroundImage: farmerImage.isNotEmpty
//                     ? NetworkImage(farmerImage)
//                     : AssetImage('asset/image/profile_placeholder.jpg')
//                         as ImageProvider,
//               ),
//             ),
//             ListTile(
//               leading: Icon(CupertinoIcons.heart),
//               title: Text("Wishlist"),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(CupertinoIcons.cart),
//               title: Text("Cart"),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(CupertinoIcons.bag),
//               title: Text("Orders"),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.car_rental),
//               title: Text("Rental Orders"),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.add_box_outlined),
//               title: Text("Add Product"),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.camera_alt),
//               title: Text("Camera"),
//               onTap: () {},
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         title: Text("Manage Your Farm Products"),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: Icon(CupertinoIcons.search),
//           ),
//         ],
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
//                   'Manage Your \nFarm Products',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(CupertinoIcons.shopping_cart),
//                 ),
//                 IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.bag)),
//                 IconButton(
//                   onPressed: () {
//                     // Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (context) => FarmerProductsScreen()));
//                   },
//                   icon: Icon(
//                     CupertinoIcons.search,
//                     size: 22,
//                   ),
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
//             SizedBox(height: 10),
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
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/modules/farmer/farmer_profile.dart';
import 'package:plantcare/modules/user/news.dart';

class FarmerHomePage extends StatefulWidget {
  @override
  _FarmerHomePageState createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String farmerName = "Loading...";
  String farmerImage = "";

  @override
  void initState() {
    super.initState();
    fetchFarmerDetails();
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
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(farmerName),
              accountEmail: Text(user?.email ?? ""),
              currentAccountPicture: CircleAvatar(
                backgroundImage: farmerImage.isNotEmpty
                    ? NetworkImage(farmerImage)
                    : AssetImage('assets/image/default_profile.png')
                        as ImageProvider,
              ),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.heart),
              title: Text("Wishlist"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(CupertinoIcons.cart),
              title: Text("Cart"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(CupertinoIcons.bag),
              title: Text("Orders"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.car_rental),
              title: Text("Rental Orders"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.add_box_outlined),
              title: Text("Add Product"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Camera"),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Manage Your Farm Products"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.search),
          ),
        ],
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
                  'Manage Your \nFarm Products',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.shopping_cart),
                ),
                IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.bag)),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.search,
                    size: 22,
                  ),
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
                        'Special Offer',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('Sell more, Earn more!'),
                    ],
                  ),
                  Image.asset('asset/image/machinery.png', width: 70),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ProductCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Navigate to product details
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
                  child: Image.asset(
                    'asset/image/plant_sample_1.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Fresh Apples',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$15 per kg',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'View Details',
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
