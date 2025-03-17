import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Milky',
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              'asset/image/personal growth-bro.png',
              height: 250,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Colors.greenAccent),
                hintText: 'Email',
                filled: true,
                fillColor: Colors.green[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.teal),
                suffixIcon: Icon(Icons.visibility, color: Colors.grey),
                hintText: 'Password',
                filled: true,
                fillColor: Colors.green[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Don’t have an account? Sign Up',
              style: TextStyle(
                  color: Colors.greenAccent, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.facebook, color: Colors.greenAccent, size: 30),
                SizedBox(width: 20),
                // Icon(Icons.twitter, color: Colors.purple, size: 30),
                SizedBox(width: 20),
                Icon(Icons.g_translate, color: Colors.greenAccent, size: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
