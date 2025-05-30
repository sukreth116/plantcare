// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:plantcare/modules/user/ai_chatbot.dart';

// class PlantChatBot extends StatefulWidget {
//   @override
//   _PlantChatBotState createState() => _PlantChatBotState();
// }

// class _PlantChatBotState extends State<PlantChatBot> {
//   List<ChatMessage> messages = [];

//   String? selectedCategory;
//   String? selectedSubCategory;

//   final List<String> _plantSubcategories = [
//     'Flowering plants',
//     'Non-flowering plants',
//     'Trees',
//     'Shrubs',
//     'Herbs',
//     'Climbers and Creepers',
//     'Succulents',
//     'Aquatic plants',
//     'Indoor plants',
//     'Medicinal plants',
//     'Carnivorous plants',
//     'Ornamental plants',
//   ];

//   final List<String> _priceRanges = [
//     "Below ₹500",
//     "₹500 - ₹1000",
//     "Above ₹1000",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _botIntro();
//   }

//   void _botIntro() {
//     _addMessage("What are you looking for today?", false,
//         options: ["Plants", "Seeds", "Fertilizers", "Pesticides", "Pots"]);
//   }

//   void _addMessage(String text, bool isUser, {List<String>? options}) {
//     setState(() {
//       messages.add(ChatMessage(
//         text: text,
//         isUser: isUser,
//         message: text,
//         options: options,
//       ));
//     });
//   }

//   void _handleOptionSelected(String option) {
//     _addMessage(option, true);
//     _botReply(option);
//   }

//   void _botReply(String userChoice) {
//     if (userChoice == "Plants") {
//       _addMessage("Which type of plant?", false, options: _plantSubcategories);
//     } else if (["Seeds", "Fertilizers", "Pesticides", "Pots"]
//         .contains(userChoice)) {
//       _askPriceRange(userChoice);
//     } else if (_plantSubcategories.contains(userChoice)) {
//       _askPriceRange(userChoice);
//     } else if (_priceRanges.contains(userChoice)) {
//       _fetchProducts(selectedCategory!, selectedSubCategory, userChoice);
//     } else if (userChoice == "Yes") {
//       _botIntro();
//     } else if (userChoice == "No") {
//       _addMessage("Okay! Let me know if you need anything else.", false);
//     }
//   }

//   void _askPriceRange(String categoryOrSubcategory) {
//     if (_plantSubcategories.contains(categoryOrSubcategory)) {
//       selectedCategory = "Plants";
//       selectedSubCategory = categoryOrSubcategory;
//     } else {
//       selectedCategory = categoryOrSubcategory;
//       selectedSubCategory = null;
//     }
//     _addMessage("Select your budget:", false, options: _priceRanges);
//   }

//   void _fetchProducts(
//       String category, String? subcategory, String priceRange) async {
//     _addMessage("Fetching products...", false);

//     try {
//       Query query = FirebaseFirestore.instance
//           .collection('nursery_products')
//           .where('category', isEqualTo: category);

//       if (subcategory != null) {
//         query = query.where('subCategory', isEqualTo: subcategory);
//       }

//       final snapshot = await query.get();

//       final List<QueryDocumentSnapshot> filteredDocs =
//           snapshot.docs.where((doc) {
//         final price = doc['price'] ?? 0;
//         if (priceRange == "Below ₹500") return price < 500;
//         if (priceRange == "₹500 - ₹1000") return price >= 500 && price <= 1000;
//         if (priceRange == "Above ₹1000") return price > 1000;
//         return false;
//       }).toList();

//       if (filteredDocs.isEmpty) {
//         _addMessage("No products found for the selected filters.", false);
//       } else {
//         _addMessage("Here are some products under $priceRange:", false);
//         // for (var doc in filteredDocs) {
//         //   var data = doc.data() as Map<String, dynamic>;
//         //   String productName = data['name'] ?? 'Unnamed';
//         //   double price = data['price'] ?? 0;
//         //   _addMessage("$productName - ₹$price", false);
//         // }
//         // Shuffle and pick 3 random products
//         filteredDocs.shuffle();
//         final sampleDocs = filteredDocs.take(3).toList();

//         for (var doc in sampleDocs) {
//           var data = doc.data() as Map<String, dynamic>;
//           String productName = data['name'] ?? 'Unnamed';

//           final dynamic priceRaw = data['price'];
//           double price = (priceRaw is int)
//               ? priceRaw.toDouble()
//               : (priceRaw is double ? priceRaw : 0.0);

//           _addMessage("$productName - ₹${price.toStringAsFixed(0)}", false);
//         }
//       }

//       _addMessage("Do you want to explore more?", false,
//           options: ["Yes", "No"]);
//     } catch (e) {
//       _addMessage("Something went wrong: ${e.toString()}", false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Plant Shop Assistant"),
//         backgroundColor: Colors.green[300],
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             onPressed: () => Navigator.push(
//                 context, MaterialPageRoute(builder: (_) => GeminiChatPage())),
//             icon: Icon(Icons.chat),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.all(16),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[index];
//                 return Align(
//                   alignment: message.isUser
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 4),
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color:
//                           message.isUser ? Colors.green[200] : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(message.message),
//                         if (message.options != null)
//                           Wrap(
//                             spacing: 8,
//                             children: message.options!.map((option) {
//                               return ElevatedButton(
//                                 onPressed: () => _handleOptionSelected(option),
//                                 child: Text(option),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   foregroundColor: Colors.white,
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatMessage {
//   final String text;
//   final String message;
//   final bool isUser;
//   final List<String>? options;
//   final VoidCallback? onTap;

//   ChatMessage({
//     required this.text,
//     required this.message,
//     required this.isUser,
//     this.options,
//     this.onTap,
//   });
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantcare/modules/user/ai_chatbot.dart'; // your existing Gemini page
import 'package:plantcare/modules/user/product_details.dart';

class PlantChatBot extends StatefulWidget {
  @override
  _PlantChatBotState createState() => _PlantChatBotState();
}

class _PlantChatBotState extends State<PlantChatBot> {
  List<ChatMessage> messages = [];

  String? selectedCategory;
  String? selectedSubCategory;

  final List<String> _plantSubcategories = [
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

  final List<String> _priceRanges = [
    "Below ₹500",
    "₹500 - ₹1000",
    "Above ₹1000",
  ];

  @override
  void initState() {
    super.initState();
    _botIntro();
  }

  void _botIntro() {
    _addMessage("What are you looking for today?", false,
        options: ["Plants", "Seeds", "Fertilizers", "Pesticides", "Pots"]);
  }

  void _addMessage(String text, bool isUser,
      {List<String>? options, VoidCallback? onTap}) {
    setState(() {
      messages.add(ChatMessage(
        text: text,
        message: text,
        isUser: isUser,
        options: options,
        onTap: onTap,
      ));
    });
  }

  void _handleOptionSelected(String option) {
    _addMessage(option, true);
    _botReply(option);
  }

  void _botReply(String userChoice) {
    if (userChoice == "Plants") {
      _addMessage("Which type of plant?", false, options: _plantSubcategories);
    } else if (["Seeds", "Fertilizers", "Pesticides", "Pots"]
        .contains(userChoice)) {
      _askPriceRange(userChoice);
    } else if (_plantSubcategories.contains(userChoice)) {
      _askPriceRange(userChoice);
    } else if (_priceRanges.contains(userChoice)) {
      _fetchProducts(selectedCategory!, selectedSubCategory, userChoice);
    } else if (userChoice == "Yes") {
      _botIntro();
    } else if (userChoice == "No") {
      _addMessage("Okay! Let me know if you need anything else.", false);
    }
  }

  void _askPriceRange(String categoryOrSubcategory) {
    if (_plantSubcategories.contains(categoryOrSubcategory)) {
      selectedCategory = "Plants";
      selectedSubCategory = categoryOrSubcategory;
    } else {
      selectedCategory = categoryOrSubcategory;
      selectedSubCategory = null;
    }
    _addMessage("Select your budget:", false, options: _priceRanges);
  }

  void _fetchProducts(
      String category, String? subcategory, String priceRange) async {
    _addMessage("Fetching products...", false);

    try {
      Query query = FirebaseFirestore.instance
          .collection('nursery_products')
          .where('category', isEqualTo: category);

      if (subcategory != null) {
        query = query.where('subCategory', isEqualTo: subcategory);
      }

      final snapshot = await query.get();

      final List<QueryDocumentSnapshot> filteredDocs =
          snapshot.docs.where((doc) {
        final dynamic priceRaw = doc['price'];
        final double price = (priceRaw is int)
            ? priceRaw.toDouble()
            : (priceRaw is double ? priceRaw : 0.0);
        if (priceRange == "Below ₹500") return price < 500;
        if (priceRange == "₹500 - ₹1000") return price >= 500 && price <= 1000;
        if (priceRange == "Above ₹1000") return price > 1000;
        return false;
      }).toList();

      if (filteredDocs.isEmpty) {
        _addMessage("No products found for the selected filters.", false);
      } else {
        filteredDocs.shuffle();
        final sampleDocs = filteredDocs.take(3).toList();

        _addMessage("Here are some products under $priceRange:", false);

        for (var doc in sampleDocs) {
          var data = doc.data() as Map<String, dynamic>;
          String productName = data['name'] ?? 'Unnamed';
          double price = (data['price'] is int)
              ? (data['price'] as int).toDouble()
              : (data['price'] as double? ?? 0);

          _addMessage("$productName - ₹${price.toStringAsFixed(0)}", false,
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(
                  productId: data['productId'] ?? '',
                ),
              ),
            );
          });
        }
      }

      _addMessage("Do you want to explore more?", false,
          options: ["Yes", "No"]);
    } catch (e) {
      _addMessage("Something went wrong: ${e.toString()}", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plant Shop Assistant"),
        backgroundColor: Colors.green[300],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GeminiChatPage()),
            ),
            icon: Icon(Icons.chat),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: InkWell(
                    onTap: message.onTap,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? Colors.green[200]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(message.message),
                          if (message.options != null)
                            Wrap(
                              spacing: 8,
                              children: message.options!.map((option) {
                                return ElevatedButton(
                                  onPressed: () =>
                                      _handleOptionSelected(option),
                                  child: Text(option),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final String message;
  final bool isUser;
  final List<String>? options;
  final VoidCallback? onTap;

  ChatMessage({
    required this.text,
    required this.message,
    required this.isUser,
    this.options,
    this.onTap,
  });
}
