// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   bool _showText = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Lottie.asset(
//               'asset/Animation cactus - 1742537329188 .json',
//               onLoaded: (composition) {
//                 Future.delayed(composition.duration, () {
//                   setState(() {
//                     _showText = true;
//                   });
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             AnimatedOpacity(
//               opacity: _showText ? 1.0 : 0.0,
//               duration: const Duration(seconds: 1),
//               child: const Text(
//                 'GREENIFY',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'onboarding_screen.dart'; // Make sure this path is correct

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _showText = false;

  void _navigateToOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'asset/Animation cactus - 1742537329188 .json',
              onLoaded: (composition) {
                Future.delayed(composition.duration, () {
                  setState(() {
                    _showText = true;
                  });

                  // Navigate after showing GREENIFY for 1 second
                  Future.delayed(composition.duration, () {
                    _navigateToOnboarding();
                  });
                });
              },
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: const Text(
                'GREENIFY',
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.green,
                  fontFamily: 'Smile Family',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
