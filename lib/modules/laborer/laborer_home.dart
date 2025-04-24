import 'package:flutter/material.dart';
import 'package:plantcare/modules/laborer/laborer_appointment.dart';
import 'package:plantcare/modules/laborer/laborer_profile.dart';
import 'package:plantcare/modules/laborer/laborer_work.dart';

class LaborerHomeScreen extends StatefulWidget {
  const LaborerHomeScreen({super.key});

  @override
  _LaborerHomeScreenState createState() => _LaborerHomeScreenState();
}

class _LaborerHomeScreenState extends State<LaborerHomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    LaborerWorkScreen(),
    WorkAppointmentScreen(),
    LaborerProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 245, 247, 245),
        automaticallyImplyLeading: false,
        title: Text(
          'Greenify',
          style: TextStyle(
            fontSize: 25,
            color: Color.fromRGBO(4, 75, 4, 0.961),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.work, color: Colors.blue, size: 30)
                : const Icon(Icons.work_outline, color: Colors.grey, size: 25),
            label: 'Work',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? const Icon(Icons.calendar_today, color: Colors.blue, size: 30)
                : const Icon(Icons.calendar_today_outlined,
                    color: Colors.grey, size: 25),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? const Icon(Icons.person, color: Colors.blue, size: 30)
                : const Icon(Icons.person_outline,
                    color: Colors.grey, size: 25),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
