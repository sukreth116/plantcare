import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExtraWorkScreen extends StatefulWidget {
  @override
  _ExtraWorkScreenState createState() => _ExtraWorkScreenState();
}

class _ExtraWorkScreenState extends State<ExtraWorkScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentWorkerId;

  @override
  void initState() {
    super.initState();
    currentWorkerId = _auth.currentUser?.uid;
  }

  Future<void> _toggleStatus(DocumentSnapshot taskDoc) async {
    String currentStatus = taskDoc['status'];
    String newStatus = currentStatus == 'Pending' ? 'Completed' : 'Pending';

    await FirebaseFirestore.instance
        .collection('nursery_works')
        .doc(taskDoc.id)
        .update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 2),
          Center(
            child: Image.asset(
              'asset/image/Work life balance-bro.png', // <-- Change this path to match your asset
              height: 130,
              fit: BoxFit.fitHeight,
            ),
          ),
          Text(
            'My Assigned Tasks',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown[400],
                fontFamily: 'Milky'),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('nursery_works')
                  .where('workerId', isEqualTo: currentWorkerId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(child: Text('Error fetching tasks'));
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                final tasks = snapshot.data!.docs;

                if (tasks.isEmpty) {
                  return Center(child: Text('No assigned tasks.'));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final data = task.data() as Map<String, dynamic>;

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ExpansionTile(
                        title: Text(
                          data['task'] ?? 'Untitled Task',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        childrenPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 18),
                              SizedBox(width: 8),
                              Text('Date: ${data['date']}'),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 18),
                              SizedBox(width: 8),
                              Text('Time: ${data['time']}'),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                              'Description: ${data['description'] ?? 'No description'}'),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Status: ${data['status']}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              ElevatedButton(
                                onPressed: () => _toggleStatus(task),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: data['status'] == 'Pending'
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                                child: Text(data['status'] == 'Pending'
                                    ? 'Mark Completed'
                                    : 'Mark Pending'),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
