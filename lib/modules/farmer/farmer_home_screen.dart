import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/about_page.dart';
import 'package:plantcare/modules/farmer/cart_screen_farmer.dart';
import 'package:plantcare/modules/farmer/farmer_add_prduct_list.dart';
import 'package:plantcare/modules/farmer/farmer_add_product_screen.dart';
import 'package:plantcare/modules/farmer/farmer_profile.dart';
import 'package:plantcare/modules/farmer/farmer_search_screen.dart';
import 'package:plantcare/modules/farmer/farmer_wishlist_screen.dart';
import 'package:plantcare/modules/farmer/orders_screen_farmer.dart';
import 'package:plantcare/modules/farmer/product_detail_screen.dart';
import 'package:plantcare/modules/farmer/rental_orders.dart';
import 'package:plantcare/AI_detection.dart';
import 'package:plantcare/modules/user/news.dart';

class FarmerHomePage extends StatefulWidget {
  @override
  _FarmerHomePageState createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String selectedCategory = 'All';
  List<String> categories = [
    'All',
    'Machinery',
    'Plants',
    'Seeds',
    'Fertilizers'
  ];
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.home_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddProductScreen()));
                },
                icon: Icon(
                  CupertinoIcons.plus_square_on_square,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AIDetectionScreen()));
                },
                icon: Icon(
                  Icons.party_mode_outlined,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewsPage()));
                },
                icon: Icon(
                  Icons.newspaper,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FarmerProfilePage(farmerId: user!.uid)));
                },
                icon: Icon(
                  Icons.person_outline,
                )),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Manage Your\nFarm Products",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FarmerSearchScreen()));
            },
          ),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
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
                leading: Icon(CupertinoIcons.heart),
                title: Text("Wishlist"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FarmerWishlistScreen()),
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
                leading: Icon(Icons.party_mode_outlined),
                title: Text("AI Detection"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AIDetectionScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.newspaper),
                title: Text("News"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewsPage()));
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 5),
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
          width: 230,
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FarmerProductDetailScreen()),
                        );
                      },
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
