import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/AI_detection.dart';
import 'package:plantcare/modules/nursery_worker/profile.dart';
import 'package:plantcare/modules/nursery_worker/work_list.dart';
import 'package:plantcare/modules/nursery_worker/extra_work_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NurseryWorkerHomeScreen extends StatefulWidget {
  @override
  _NurseryWorkerHomeScreenState createState() =>
      _NurseryWorkerHomeScreenState();
}

class _NurseryWorkerHomeScreenState extends State<NurseryWorkerHomeScreen> {
  int _selectedIndex = 0;
  String? _workerId;

  @override
  void initState() {
    super.initState();
    fetchWorkerDocId();
  }

  Future<void> fetchWorkerDocId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('nursery_workers')
          .where('uid', isEqualTo: user.uid)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _workerId = snapshot.docs.first.id;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator until workerId is available

    final User? user = FirebaseAuth.instance.currentUser;

    final List<Widget> _pages = [
      WorkerJobListScreen(workerId: user?.uid ?? ''), // Pass workerId here
      ExtraWorkScreen(),
      AIDetectionScreen(),
      WorkerProfilePage(
        workerId: user?.uid ?? '',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('G R E E N I F Y'),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
          iconSize: 28,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.schedule),
            selectedIcon: const Icon(Icons.schedule_send),
            title: const Text('Weak Job List'),
            backgroundColor: Colors.green,
          ),
          BottomBarItem(
            icon: const Icon(Icons.schedule),
            selectedIcon: const Icon(Icons.schedule_send),
            title: const Text('Other Job'),
            backgroundColor: Colors.green,
          ),
          BottomBarItem(
            icon: const Icon(Icons.science_outlined),
            selectedIcon: const Icon(Icons.science),
            title: const Text('AI Detect'),
            backgroundColor: Colors.green,
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            title: const Text('Profile'),
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
