import 'package:flutter/material.dart';
import 'package:plantcare/modules/user/product_details.dart';

class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> products = [
    {
      'title': 'Aloe Vera',
      'image': 'asset/image/plant_sample_1.png',
      'price': '\$10'
    },
    {
      'title': 'Basil Plant',
      'image': 'asset/image/plant_sample_2.png',
      'price': '\$15'
    },
    {
      'title': 'Fertilizer',
      'image': 'asset/image/plant_sample_1.png',
      'price': '\$20'
    },
    {
      'title': 'Pot',
      'image': 'asset/image/plant_sample_1.png',
      'price': '\$20'
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  void _filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Products'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for plants and supplements...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.green[100],
              ),
              onChanged: _filterProducts,
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      // onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ProductDetailScreen())),
                      child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.asset(
                              filteredProducts[index]['image'],
                              fit: BoxFit.cover,
                              width: 80,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  filteredProducts[index]['title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  filteredProducts[index]['price'],
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 14),
                                ),
                              ]),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.favorite_border),
                                    onPressed: () {
                                      // Add to wishlist functionality
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.shopping_cart),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
