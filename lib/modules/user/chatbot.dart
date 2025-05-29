import 'package:flutter/material.dart';
import 'package:plantcare/modules/user/ai_chatbot.dart';

class PlantChatBot extends StatefulWidget {
  @override
  _PlantChatBotState createState() => _PlantChatBotState();
}

class _PlantChatBotState extends State<PlantChatBot> {
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    _botIntro();
  }

  void _botIntro() {
    _addMessage("What are you looking for today?", false,
        options: ["Plants", "Seeds", "Fertilizers", "Pesticides", "Pots"]);
  }

  void _addMessage(String text, bool isUser, {List<String>? options}) {
    setState(() {
      messages.add(ChatMessage(
          text: text, isUser: isUser, options: options, message: text));
    });
  }

  void _handleOptionSelected(String option) {
    _addMessage(option, true);
    _botReply(option);
  }

  void _botReply(String userChoice) {
    if (userChoice == "Plants") {
      _addMessage("Which type of plant?", false, options: [
        "Flowering plants",
        "Indoor plants",
        "Succulents",
        "Trees",
        "Shrubs",
        "Herbs"
      ]);
    } else if (userChoice == "Seeds" ||
        userChoice == "Fertilizers" ||
        userChoice == "Pesticides" ||
        userChoice == "Pots") {
      _askPriceRange(userChoice);
    } else if (_plantSubcategories.contains(userChoice)) {
      _askPriceRange(userChoice);
    } else if (_priceRanges.contains(userChoice)) {
      _fetchProducts(selectedCategory!, selectedSubCategory, userChoice);
    }
  }

  String? selectedCategory;
  String? selectedSubCategory;

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
    // Mock Firestore Fetch (You should replace this with your Firestore query)
    List<String> dummyProducts = [
      "$subcategory Plant 1",
      "$subcategory Plant 2",
      "$subcategory Plant 3"
    ];

    await Future.delayed(Duration(seconds: 1));

    _addMessage(
        "Here are some $subcategory products under $priceRange:", false);
    for (var product in dummyProducts) {
      _addMessage(product, false);
    }
    _addMessage("Do you want to explore more?", false, options: ["Yes", "No"]);
  }

  final List<String> _plantSubcategories = [
    "Flowering plants",
    "Indoor plants",
    "Succulents",
    "Trees",
    "Shrubs",
    "Herbs"
  ];

  final List<String> _priceRanges = [
    "Below ₹500",
    "₹500 - ₹1000",
    "Above ₹1000",
  ];

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
                  context, MaterialPageRoute(builder: (_) => GeminiChatPage())),
              icon: Icon(Icons.chat))
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
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          message.isUser ? Colors.green[200] : Colors.grey[300],
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
                                onPressed: () => _handleOptionSelected(option),
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

  ChatMessage(
      {required this.text,
      required this.message,
      required this.isUser,
      this.options});
}
