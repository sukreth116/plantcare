import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerJobListScreen extends StatelessWidget {
  final String workerId;

  const WorkerJobListScreen({required this.workerId, super.key});

  @override
  Widget build(BuildContext context) {
    final String currentDay = _getCurrentDay();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('work_schedule')
            .where('workerId', isEqualTo: workerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text("No tasks assigned yet."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final String day = data['day'] ?? '';
              final List<dynamic> taskList = data['tasks'] ?? [];

              final bool isToday = day == currentDay;

              return Card(
                color: isToday ? Colors.green[100] : null,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    "$day - ${data['status'] ?? 'Pending'}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.green[700] : Colors.black87,
                    ),
                  ),
                  children: taskList.map((task) {
                    return ListTile(
                      leading: Icon(Icons.check_circle_outline,
                          color: Colors.green[300]),
                      title: Text(task['title'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Description: ${task['description'] ?? ''}"),
                          Text("Time: ${task['time'] ?? ''}"),
                          Text("Date: ${data['date'] ?? ''}"),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getCurrentDay() {
    final DateTime now = DateTime.now();
    return [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ][now.weekday - 1];
  }
}
