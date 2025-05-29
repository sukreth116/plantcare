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
      backgroundColor: const Color(0xFFe8fcec),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'asset/Animation - 1747637919783.json',
              onLoaded: (composition) {
                setState(() {
                  _showText = true; // Show text with animation
                });
                Future.delayed(composition.duration, () {
                  _navigateToOnboarding();
                });
              },
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: Column(
                children: [
                  Text(
                    'GREENIFY',
                    style: TextStyle(
                      fontSize: 50,
                      color: const Color(0xFF3b8958),
                      fontFamily: 'DugiPundi',
                    ),
                  ),
                  Text(
                    'Every plant has a story. \nLet yours begin with Greenify',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green.shade200,
                    ),
                    textAlign: TextAlign.center,
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
