// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class WorkerJobListScreen extends StatelessWidget {
//   final String workerId;

//   const WorkerJobListScreen({required this.workerId, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final String currentDay = _getCurrentDay();

//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('work_schedule')
//             .where('workerId', isEqualTo: workerId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final docs = snapshot.data?.docs ?? [];

//           if (docs.isEmpty) {
//             return const Center(child: Text("No tasks assigned yet."));
//           }

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final doc = docs[index];
//               final data = doc.data() as Map<String, dynamic>;
//               final String day = data['day'] ?? '';
//               final List<dynamic> taskList = data['tasks'] ?? [];
//               final String status = data['status'] ?? 'Pending';

//               final bool isToday = day == currentDay;
//               final bool isCompleted = status == "Completed";

//               // Check if it is past midnight (12:00 AM)
//               if (isCompleted && _isPastMidnight()) {
//                 // Automatically update status to "Pending"
//                 FirebaseFirestore.instance.collection('work_schedule').doc(doc.id).update({
//                   'status': 'Pending',
//                 });
//               }

//               return Card(
//                 color: isToday ? Colors.green[100] : null,
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ExpansionTile(
//                   title: Text(
//                     "$day - $status",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: isToday ? Colors.green[700] : Colors.black87,
//                     ),
//                   ),
//                   children: taskList.map((task) {
//                     return ListTile(
//                       leading: Icon(Icons.check_circle_outline,
//                           color: Colors.green[300]),
//                       title: Text(task['title'] ?? ''),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Description: ${task['description'] ?? ''}"),
//                           Text("Time: ${task['time'] ?? ''}"),
//                           Text("Date: ${data['date'] ?? ''}"),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   String _getCurrentDay() {
//     final DateTime now = DateTime.now();
//     return [
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Saturday',
//       'Sunday',
//     ][now.weekday - 1];
//   }

//   // Check if it's past midnight (12:00 AM)
//   bool _isPastMidnight() {
//     final DateTime currentTime = DateTime.now();
//     final int currentHour = currentTime.hour;
//     return currentHour == 0; // This will return true if it's 12:00 AM
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
              final String status = data['status'] ?? 'Pending';

              final bool isToday = day == currentDay;
              final bool isCompleted = status == "Completed";

              // Check if it is past midnight (12:00 AM) and automatically set status to Pending
              if (isCompleted && _isPastMidnight()) {
                FirebaseFirestore.instance
                    .collection('work_schedule')
                    .doc(doc.id)
                    .update({
                  'status': 'Pending',
                });
              }

              return Card(
                color: isToday ? Colors.green[100] : null,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    "$day - $status",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.green[700] : Colors.black87,
                    ),
                  ),
                  children: [
                    ...taskList.map((task) {
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Toggle the status between 'Completed' and 'Pending'
                          String newStatus =
                              status == 'Completed' ? 'Pending' : 'Completed';
                          FirebaseFirestore.instance
                              .collection('work_schedule')
                              .doc(doc.id)
                              .update({
                            'status': newStatus,
                          });
                        },
                        icon: Icon(
                          status == 'Completed'
                              ? Icons.undo
                              : Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                        label: Text(
                          status == 'Completed'
                              ? 'Mark as Pending'
                              : 'Mark as Completed',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
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

  // Check if it's past midnight (12:00 AM)
  bool _isPastMidnight() {
    final DateTime currentTime = DateTime.now();
    final int currentHour = currentTime.hour;
    return currentHour == 0; // This will return true if it's 12:00 AM
  }
}
