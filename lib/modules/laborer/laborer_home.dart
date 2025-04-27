import 'package:flutter/material.dart';
import 'package:plantcare/modules/laborer/laborer_appointment.dart';
import 'package:plantcare/modules/laborer/laborer_profile.dart';
import 'package:plantcare/modules/laborer/laborer_work.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantcare/choose_screen.dart';

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
        actions: [
          IconButton(
            onPressed: () async {
              bool confirmLogout = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red[600]),
                        const SizedBox(width: 10),
                        const Text('Confirm Logout'),
                      ],
                    ),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('Logout',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout, color: Colors.green),
          ),
        ],
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
