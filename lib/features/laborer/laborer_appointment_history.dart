import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  _AppointmentHistoryScreenState createState() =>
      _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final String? laborerId = FirebaseAuth.instance.currentUser?.uid;

    if (laborerId == null) {
      return const Scaffold(
        body: Center(child: Text("Error: User not signed in")),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('laborerId', isEqualTo: laborerId)
            .where('status',
                isEqualTo: 'Completed') // Fetch completed appointments
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No completed appointments'));
          }

          var jobList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobList.length,
            itemBuilder: (context, index) {
              var job = jobList[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(job['title'] ?? 'Unknown Job',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: ${job['date'] ?? 'Not specified'}",
                          style: const TextStyle(color: Colors.grey)),
                      Text("Time: ${job['time'] ?? 'Not specified'}",
                          style: const TextStyle(color: Colors.grey)),
                      Text("Location: ${job['location'] ?? 'Not specified'}",
                          style: const TextStyle(color: Colors.grey)),
                      Text("Status: ${job['status'] ?? 'Unknown'}",
                          style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
