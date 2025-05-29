import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:plantcare/choose_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe8fcec),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 100,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Lottie.asset(
                'asset/Animation seed - 1742537287919.json',
                repeat: true,
                reverse: false,
                animate: true,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'W E L C O M E    T O',
              style: TextStyle(
                fontSize: 15,
                // fontFamily: 'Libre Baskerville',
                color: Color(0xFF3b8958),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'GREENIFY',
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'Callido',
                color: Color(0xFF3b8958),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Water your dreams like \nYou water your plants\nLets Begin with Greenify.',
              style: TextStyle(
                fontSize: 16,
                // fontFamily: 'Libre Baskerville',
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
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
                    backgroundColor: Color(0xFF3b8958), // Green color
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
    );
  }
}
