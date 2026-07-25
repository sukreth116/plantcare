import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantcare/about_page.dart';
import 'package:plantcare/aidetection.dart';
import 'package:plantcare/modules/nursery/add_banner.dart';
import 'package:plantcare/modules/nursery/add_machinery.dart';
import 'package:plantcare/modules/nursery/add_product_nursery.dart';
import 'package:plantcare/modules/nursery/machinery.dart';
import 'package:plantcare/modules/nursery/manage_workers.dart';
import 'package:plantcare/modules/nursery/nursery_book_work.dart';
import 'package:plantcare/modules/nursery/nursery_prducts.dart';
import 'package:plantcare/modules/nursery/orders.dart';
import 'package:plantcare/modules/nursery/profile.dart';
import 'package:plantcare/modules/nursery/rental_orders.dart';
import 'package:plantcare/modules/nursery/sale_report_nursery.dart';
import 'package:plantcare/modules/nursery/work_assign.dart';
import 'package:plantcare/modules/nursery/worker_select.dart';
import 'package:plantcare/modules/nursery/nursery_product_detail.dart';
import 'package:plantcare/modules/user/ai_chatbot.dart';
import 'package:plantcare/news.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NurseryHomeScreen extends StatefulWidget {
  const NurseryHomeScreen({super.key});

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
    final List<Widget> screens = [
      HomeScreen(),
      DiseasePredictorScreen(),
      NewsPage(),
      user != null
          ? NurseryProfilePage(nurseryId: user!.uid)
          : Center(child: CircularProgressIndicator()), // Handle null user case
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green.shade300,
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
                decoration: BoxDecoration(color: Colors.green[300]),
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
                leading: Icon(CupertinoIcons.rectangle_3_offgrid),
                title: Text("Your Machineries"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MachineryList()));
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
                          builder: (context) => RentalOrderScreen()));
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
                          builder: (context) => AddNurseryProduct(
                                nurseryId:
                                    FirebaseAuth.instance.currentUser!.uid,
                              )));
                },
              ),
              ListTile(
                leading: Icon(Icons.add_to_photos_outlined),
                title: Text("Add Machinery"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMachinery(
                                nurseryId:
                                    FirebaseAuth.instance.currentUser!.uid,
                              )));
                },
              ),
              ListTile(
                leading: Icon(Icons.ad_units_outlined),
                title: Text("Add Banner"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPromoBannerScreen()));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.person_3),
                title: Text("Manage Workers"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkerManagementScreen(
                                nurseryId:
                                    FirebaseAuth.instance.currentUser!.uid,
                              )));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.rectangle_stack_badge_person_crop),
                title: Text("Work Schedule"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectWorkerScreen(
                                nurseryId:
                                    FirebaseAuth.instance.currentUser!.uid,
                              )));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.rectangle_stack_badge_person_crop),
                title: Text("Work Assign"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExtraWorkScheduleScreen(
                                nurseryId:
                                    FirebaseAuth.instance.currentUser!.uid,
                              )));
                },
              ),
              ListTile(
                leading: Icon(Icons.work_outline),
                title: Text("Book Work"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NurseryWorkAppointmentScreen()));
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
      body: screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GeminiChatPage()));
        },
        backgroundColor: Colors.green[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Icon(Icons.chat, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
            icon: Icon(Icons.party_mode_outlined),
            title: Text("AI Detection"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.newspaper),
            title: Text("Latest News"),
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('nursery_products').get();

      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID
        return data;
      }).toList();

      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() => _isLoading = false);
    }
  }

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
                    "Where every leaf tells a story of care and growth",
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
                        hintText: "Explore your products",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? Text("No products available")
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return PlantCard(
                            title: product['name'] ?? 'Unknown',
                            description:
                                product['description'] ?? 'No description',
                            imageUrl: product['imageUrl'] ??
                                'asset/image/plant_sample_1.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                      productData: product,
                                      productId: product['id']),
                                ),
                              );
                            },
                          );
                        },
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
  final String imageUrl;
  final VoidCallback onTap;

  const PlantCard({super.key, 
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 100,
                fit: BoxFit.fitHeight,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 40),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
