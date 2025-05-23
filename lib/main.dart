import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/splash_screen1.dart';
import 'package:plantcare/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Greenify',
        theme: ThemeData(
            fontFamily: 'Montserrat',
            primaryColor: Colors.green,
            useMaterial3: true,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontWeight: FontWeight.w400),
              bodyMedium: TextStyle(fontWeight: FontWeight.w400),
            )),
        home: SplashScreen());
  }
}
