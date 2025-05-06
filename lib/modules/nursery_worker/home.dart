import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';


class NurseryWorkerHomeScreen extends StatefulWidget {
  @override
  _NurseryWorkerHomeScreenState createState() => _NurseryWorkerHomeScreenState();
}

class _NurseryWorkerHomeScreenState extends State<NurseryWorkerHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ProfilePage(),
    ScheduledJobsPage(),
    AiPlantDiseaseDetectionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
          iconSize: 28,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            title: const Text('Profile'),
            backgroundColor: Colors.green,
          ),
          BottomBarItem(
            icon: const Icon(Icons.schedule),
            selectedIcon: const Icon(Icons.schedule_send),
            title: const Text('Jobs'),
            backgroundColor: Colors.green,
          ),
          BottomBarItem(
            icon: const Icon(Icons.science_outlined),
            selectedIcon: const Icon(Icons.science),
            title: const Text('AI Detect'),
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Nursery Profile Page'));
  }
}


class ScheduledJobsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Scheduled Jobs Page'));
  }
}


class AiPlantDiseaseDetectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('AI Plant Disease Detection Page'));
  }
}
