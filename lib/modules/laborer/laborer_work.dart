import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LaborerWorkScreen extends StatelessWidget {
  const LaborerWorkScreen({super.key});

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
            .where('status', isEqualTo: 'Pending') // Show only pending jobs
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No work opportunities available'));
          }

          var jobList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobList.length,
            itemBuilder: (context, index) {
              var job = jobList[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job['title'] ?? 'Unknown Job',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text('Location: ${job['location'] ?? 'Unknown'}'),
                            Text('Date: ${job['date'] ?? 'Not specified'}'),
                            Text('Time: ${job['time'] ?? 'Not specified'}'),
                            Text('Wage: ${job['wage'] ?? 'Not specified'}'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _updateJobStatus(jobList[index].id, 'Accepted');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text('Accept'),
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: () {
                                _updateJobStatus(jobList[index].id, 'Rejected');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                      ),
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

  void _updateJobStatus(String jobId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(jobId)
          .update({'status': status});
      print("Job $status successfully!");
    } catch (e) {
      print("Error updating job status: $e");
    }
  }
}
