import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantcare/AI_detection.dart';
import 'package:plantcare/about_page.dart';
import 'package:plantcare/modules/nursery/add_banner.dart';
import 'package:plantcare/modules/nursery/add_machinery.dart';
import 'package:plantcare/modules/nursery/add_product_nursery.dart';
import 'package:plantcare/modules/nursery/nursery_prducts';
import 'package:plantcare/modules/nursery/orders.dart';
import 'package:plantcare/modules/nursery/profile.dart';
import 'package:plantcare/modules/nursery/rental_orders.dart';
import 'package:plantcare/modules/nursery/sale_report_nursery.dart';
import 'package:plantcare/modules/nursery/work_schedule_mangement.dart';
import 'package:plantcare/modules/user/news.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NurseryHomeScreen extends StatefulWidget {
  @override
  _NurseryHomeScreenState createState() => _NurseryHomeScreenState();
}

class _NurseryHomeScreenState extends State<NurseryHomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  int _currentIndex = 0;

  String? nurseryName;
  String? companyLogoUrl;
  String? email;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      fetchNurseryDetails();
    }
  }

  void fetchNurseryDetails() async {
    try {
      DocumentSnapshot nurseryDoc = await FirebaseFirestore.instance
          .collection('nurseries')
          .doc(user!.uid)
          .get();

      if (nurseryDoc.exists) {
        setState(() {
          nurseryName =
              nurseryDoc['nurseryName']; // Ensure field names match Firestore
          companyLogoUrl = nurseryDoc['companyLogoUrl'];
          email = nurseryDoc['email'];
        });
      }
    } catch (e) {
      print("Error fetching nursery details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure user is not null before passing to NurseryProfilePage
    final List<Widget> _screens = [
      HomeScreen(),
      AddNurseryProduct(),
      AddMachinery(),
      user != null
          ? NurseryProfilePage(nurseryId: user!.uid)
          : Center(child: CircularProgressIndicator()), // Handle null user case
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[200],
        title: Text(
          "G R E E N I F Y",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
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
                accountName: Text(nurseryName ?? "Nursery Name"),
                accountEmail: Text(user?.email ?? "Email not available"),
                currentAccountPicture: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NurseryProfilePage(
                                  nurseryId: user!.uid,
                                )));
                  },
                  child: CircleAvatar(
                    backgroundImage: companyLogoUrl != null
                        ? NetworkImage(companyLogoUrl!)
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
                          builder: (context) => NurseryProfilePage(
                                nurseryId: user!.uid,
                              )));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.rectangle_3_offgrid),
                title: Text("Your Products"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NurseryProductsScreen()));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.bag),
                title: Text("Orders"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SaleOrderScreen()));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.bag_badge_plus),
                title: Text("Rental Orders"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NurseryRentalOrderScreen()));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.bag),
                title: Text("Sale Report"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NurserySalesReportScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.add_circle_outline_rounded),
                title: Text("Add Product"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNurseryProduct()));
                },
              ),
              ListTile(
                leading: Icon(Icons.add_circle_outline_rounded),
                title: Text("Add Machinery"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddMachinery()));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.rectangle_stack_badge_person_crop),
                title: Text("Add Banner"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPromoBannerScreen()));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.rectangle_stack_badge_person_crop),
                title: Text("Work Schedule"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkScheduleScreen()));
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
      body: _screens[_currentIndex],
      backgroundColor: Colors.white,
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home_outlined),
            title: Text("Home"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: Icon(CupertinoIcons.plus_square_on_square),
            title: Text("Add Product"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: Icon(CupertinoIcons.wrench),
            title: Text("Add Machinery"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person_outline),
            title: Text("Profile"),
            selectedColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "There's a Plant for Everyone",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Get your 1st plant at 30% off",
                    style: TextStyle(fontSize: 16, color: Colors.green[700]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search plant with name, type, etc...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.filter_list, color: Colors.green[700]),
                ],
              ),
            ),
            SizedBox(height: 20),
            PlantCard(
              title: "Kalanchoe - Orange",
              description:
                  "An evergreen succulent featuring waxy leaves and striking flame-orange flowers.",
              imagePath: 'asset/image/plant_sample_1.png',
            ),
            SizedBox(height: 10),
            PlantCard(
              title: "Ixora - Dark Orange",
              description:
                  "Ixoras are small tropical shrubs with vibrant orange-red flower clusters.",
              imagePath: 'asset/image/plant_sample_1.png',
            ),
          ],
        ),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  PlantCard(
      {required this.title,
      required this.description,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.cover),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
