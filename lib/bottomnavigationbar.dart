// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

// class AnimatedBarExample extends StatefulWidget {
//   const AnimatedBarExample({super.key});

//   @override
//   State<AnimatedBarExample> createState() => _AnimatedBarExampleState();
// }

// class _AnimatedBarExampleState extends State<AnimatedBarExample> {
//   int selected = 0;
//   bool heart = false;
//   final controller = PageController();

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true, //to make floating action button notch transparent

//       //to avoid the floating action button overlapping behavior,
//       // when a soft keyboard is displayed
//       // resizeToAvoidBottomInset: false,

//       bottomNavigationBar: StylishBottomBar(
//         option: AnimatedBarOptions(
//           // iconSize: 32,
//           // barAnimation: BarAnimation.liquid,
//           iconStyle: IconStyle.animated,

//           // opacity: 0.3,
//         ),
//         items: [
//           BottomBarItem(
//             icon: const Icon(Icons.house_outlined),
//             selectedIcon: const Icon(Icons.house_rounded),
//             selectedColor: Colors.green,
//             unSelectedColor: Colors.grey,
//             title: const Text('Home'),
//           ),
//           BottomBarItem(
//             icon: const Icon(CupertinoIcons.heart),
//             selectedIcon: const Icon(CupertinoIcons.heart_circle_fill),
//             selectedColor: Colors.green,
//             backgroundColor: Colors.green,
//             title: const Text('Whislist'),
//           ),
//           BottomBarItem(
//               icon: const Icon(
//                 Icons.person_outline,
//               ),
//               selectedIcon: const Icon(
//                 Icons.newspaper,
//               ),
//               selectedColor: Colors.green,
//               backgroundColor: Colors.green,
//               title: const Text('News')),
//           BottomBarItem(
//               icon: const Icon(
//                 Icons.person_outline,
//               ),
//               selectedIcon: const Icon(
//                 Icons.person,
//               ),
//               selectedColor: Colors.green,
//               title: const Text('Profile')),
//         ],
//         hasNotch: true,
//         fabLocation: StylishBarFabLocation.center,
//         currentIndex: selected,
//         notchStyle: NotchStyle.circle,
//         onTap: (index) {
//           if (index == selected) return;
//           controller.jumpToPage(index);
//           setState(() {
//             selected = index;
//           });
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             heart = !heart;
//           });
//         },
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         child: Icon(
//           heart ? Icons.party_mode : Icons.party_mode_outlined,
//           color: Colors.green,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       body: SafeArea(
//         child: PageView(
//           controller: controller,
//           children: const [
//             Center(child: Text('Home')),
//             Center(child: Text('Star')),
//             Center(child: Text('Style')),
//             Center(child: Text('News')),
//             Center(child: Text('Profile')),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/AI_detection.dart';
import 'package:plantcare/modules/user/user_home_page.dart';
import 'package:plantcare/modules/user/user_profile.dart';
import 'package:plantcare/modules/user/wishlist.dart';
import 'package:plantcare/news.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

// Import your actual page widgets here

class AnimatedBarExample extends StatefulWidget {
  const AnimatedBarExample({super.key});

  @override
  State<AnimatedBarExample> createState() => _AnimatedBarExampleState();
}

class _AnimatedBarExampleState extends State<AnimatedBarExample> {
  int selected = 0;
  bool heart = false;
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          iconStyle: IconStyle.animated,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.house_outlined),
            selectedIcon: const Icon(Icons.house_rounded),
            selectedColor: Colors.green,
            unSelectedColor: Colors.grey,
            title: const Text('Home'),
          ),
          BottomBarItem(
            icon: const Icon(CupertinoIcons.heart),
            selectedIcon: const Icon(CupertinoIcons.heart_circle_fill),
            selectedColor: Colors.green,
            backgroundColor: Colors.green,
            title: const Text('Wishlist'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.newspaper_outlined),
            selectedIcon: const Icon(Icons.newspaper),
            selectedColor: Colors.green,
            backgroundColor: Colors.green,
            title: const Text('News'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            selectedColor: Colors.green,
            title: const Text('Profile'),
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: selected,
        notchStyle: NotchStyle.circle,
        onTap: (index) {
          if (index == selected) return;
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            heart = !heart;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AIDetectionScreen()));
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(
          heart ? Icons.party_mode : Icons.party_mode_outlined,
          color: Colors.green,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            UserHomePage(),
            WishlistScreen(),
            AIDetectionScreen(),
            NewsPage(),
            UserProfilePage(userId: user!.uid),
          ],
        ),
      ),
    );
  }
}
