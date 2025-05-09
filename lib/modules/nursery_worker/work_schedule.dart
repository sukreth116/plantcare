import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerJobsScreen extends StatelessWidget {
  final String workerId;

  const WorkerJobsScreen({required this.workerId, super.key});

  @override
  Widget build(BuildContext context) {
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

          final jobs = snapshot.data?.docs ?? [];

          if (jobs.isEmpty) {
            return const Center(child: Text("No jobs assigned yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[300],
                    child: const Icon(Icons.work, color: Colors.white),
                  ),
                  title: Text(job['task'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description: ${job['description'] ?? ''}"),
                      Text("Date: ${job['date'] ?? ''}"),
                      Text("Time: ${job['time'] ?? ''}"),
                      const SizedBox(height: 4),
                      _buildStatusChip(job['status'] ?? "Pending"),
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

  Widget _buildStatusChip(String status) {
    Color color = status == "Pending"
        ? Colors.orange
        : status == "In Progress"
            ? Colors.blue
            : Colors.green;

    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }
}
