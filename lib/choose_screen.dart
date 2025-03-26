import 'package:flutter/material.dart';
import 'package:plantcare/modules/farmer/farmer_login_screen.dart';
import 'package:plantcare/modules/nursery/login_nursery.dart';
import 'package:plantcare/modules/user/user_login.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cardData = [
      {"title": "User", "icon": Icons.person, "route": const UserLoginScreen()},
      {
        "title": "Admin",
        "icon": Icons.admin_panel_settings,
        "route": const FarmerLoginScreen()
      },
      {
        "title": "Farmer",
        "icon": Icons.agriculture,
        "route": const FarmerLoginScreen()
      },
      {
        "title": "Laborer",
        "icon": Icons.construction,
        "route": const FarmerLoginScreen()
      },
      {
        "title": "Nursery",
        "icon": Icons.local_florist,
        "route": const NurseryLoginScreen()
      },
      {
        "title": "Worker",
        "icon": Icons.work,
        "route": const FarmerLoginScreen()
      },
    ];

    //
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/image/bg1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.green
                  .withOpacity(0.3), // Adjust opacity here (0.0 - 1.0)
            ),
          ),
          // Title and Grid
          Column(
            children: [
              const SizedBox(height: 60), // Space from top
              Text(
                "GREENIFY",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[100],
                  fontFamily: 'Delicious',
                ),
              ),
              const SizedBox(height: 20), // Space between title and grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1,
                  ),
                  itemCount: cardData.length,
                  itemBuilder: (context, index) {
                    return _buildCard(
                      icon: cardData[index]["icon"],
                      title: cardData[index]["title"],
                      context: context,
                      route: cardData[index]["route"],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      {required IconData icon,
      required String title,
      required BuildContext context,
      required Widget route}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // Semi-transparent effect
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
