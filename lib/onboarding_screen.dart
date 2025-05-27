import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:plantcare/choose_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              // const SizedBox(height: 20),
              const Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'TClip',
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'GREENIFY',
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'Risperd Marfiel Display',
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Lottie.asset(
                  'asset/Animation seed - 1742537287919.json',
                  repeat: true,
                  reverse: false,
                  animate: true,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to home or login screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => ChooseScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Get Started',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
