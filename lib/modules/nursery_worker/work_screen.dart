import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WorkerJobsScreen extends StatefulWidget {
  final String workerId;

  const WorkerJobsScreen({required this.workerId, super.key});

  @override
  State<WorkerJobsScreen> createState() => _WorkerJobsScreenState();
}

class _WorkerJobsScreenState extends State<WorkerJobsScreen> {
  late String currentDay;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    currentDay = _getDayFromDate(DateTime.now());
  }

  String _getDayFromDate(DateTime date) {
    return DateFormat('EEEE').format(date); // returns Monday, Tuesday, etc.
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: now,
      lastDate: now.add(Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        currentDay = _getDayFromDate(picked);
      });
    }
  }

  Future<void> _toggleStatus(
      DocumentReference docRef, String currentStatus) async {
    final newStatus = currentStatus == "Completed" ? "Pending" : "Completed";
    await docRef.update({"status": newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Jobs"),
        backgroundColor: Colors.green[300],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _pickDate(context),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('work_schedule')
            .where('workerId', isEqualTo: widget.workerId)
            .where('day', isEqualTo: currentDay)
            // .where('date',
            //     isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text("No tasks for selected day."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final String status = data['status'] ?? 'Pending';
              final List<dynamic> taskList = data['tasks'] ?? [];

              final bool isToday =
                  _getDayFromDate(DateTime.now()) == currentDay;

              return Card(
                color: isToday ? Colors.green[100] : null,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    "$currentDay - $status",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.green[700] : Colors.black87,
                    ),
                  ),
                  children: [
                    ...taskList.map((task) {
                      return ListTile(
                        leading: Icon(Icons.task, color: Colors.green[300]),
                        title: Text(task['title'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description: ${task['description'] ?? ''}"),
                            Text("Time: ${task['time'] ?? ''}"),
                          ],
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton.icon(
                        onPressed: () => _toggleStatus(doc.reference, status),
                        icon: Icon(
                          status == "Completed"
                              ? Icons.undo
                              : Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                        label: Text(
                          status == "Completed"
                              ? "Mark Pending"
                              : "Mark Completed",
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
}
