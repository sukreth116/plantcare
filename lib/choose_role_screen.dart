import 'package:flutter/material.dart';
import 'package:plantcare/modules/farmer/farmer_login_screen.dart';
import 'package:plantcare/modules/nursery/nursery_login.dart';
import 'package:plantcare/modules/user/user_login.dart';

class ChooseRoleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Opacity(
          //     opacity: 0.3, // Adjust the opacity as needed
          //     child: Image.asset(
          //       'asset/image/cute cactus-bro.png', // Ensure this image is added in pubspec.yaml
          //       height: 200, // Reduced size
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.3, // Adjust the opacity as needed
                child: Image.asset(
                  'asset/image/cute cactus-bro.png', // Ensure this image is added in pubspec.yaml
                  height: 500, // Adjust size as needed
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // ClipPath for top-left curved design
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7CDEAD), Color(0xFF3ca372)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Text('Welcome To Greenify',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 8),
                Text(
                  'Select Your Role',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildCategoryCard(
                          Icons.person, 'User', Colors.white, context),
                      _buildCategoryCard(Icons.admin_panel_settings, 'Admin',
                          Colors.white, context),
                      _buildCategoryCard(
                          Icons.agriculture, 'Farmers', Colors.white, context),
                      _buildCategoryCard(
                          Icons.build, 'Laborers', Colors.white, context),
                      _buildCategoryCard(Icons.local_florist, 'Nursery',
                          Colors.white, context),
                      _buildCategoryCard(
                        Icons.nature_people,
                        'Worker',
                        Colors.white,
                        context,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      IconData icon, String title, Color color, BuildContext context) {
    return Card(
      color: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: InkWell(
        onTap: () {
          switch (title) {
            case 'User':
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserLoginScreen()));
              break;
            case 'Farmers':
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FarmerLoginScreen()));
              break;
            case 'Nursery':
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NurseryLoginScreen()));
              break;
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for the top-left curved shape
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width * 0.5, size.height - 100, size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
