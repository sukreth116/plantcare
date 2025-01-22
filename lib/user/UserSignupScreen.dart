import 'package:flutter/material.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: Colors.green,
    title: Text('Plant Care'),),
    body: Column(children: [ Text("First Name",style: TextStyle(fontSize: 20),),TextFormField(decoration: InputDecoration(hintText: "Enter Your Name"),)],),);
  }
}