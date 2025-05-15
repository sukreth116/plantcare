import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantcare/modules/nursery/work_schedule.dart';

class NurseryWorkScreenByDay extends StatelessWidget {
  final String nurseryId;

  const NurseryWorkScreenByDay({Key? key, required this.nurseryId})
      : super(key: key);

  void _editTask(BuildContext context, String docId, Map task, int index) {
    final titleController = TextEditingController(text: task['title']);
    final descController = TextEditingController(text: task['description']);
    final timeController = TextEditingController(text: task['time']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time')),
            TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title')),
            TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updatedTask = {
                'time': timeController.text,
                'title': titleController.text,
                'description': descController.text,
              };
              final docRef = FirebaseFirestore.instance
                  .collection('work_schedule')
                  .doc(docId);
              final docSnap = await docRef.get();
              final List tasks = List.from(docSnap['tasks']);
              tasks[index] = updatedTask;
              await docRef.update({'tasks': tasks});
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ],
      ),
    );
  }

  void _deleteTask(BuildContext context, String docId, int index) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final docRef = FirebaseFirestore.instance
                  .collection('work_schedule')
                  .doc(docId);
              final docSnap = await docRef.get();
              final List tasks = List.from(docSnap['tasks']);
              tasks.removeAt(index);
              await docRef.update({'tasks': tasks});
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Schedule by Day'),
        backgroundColor: Colors.green[300],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WorkScheduleManagementScreen(
                            nurseryId: nurseryId,
                          )));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('work_schedule')
            .where('nurseryId', isEqualTo: nurseryId)
            // Sort alphabetically by day
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('Error loading work'));
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return Center(child: Text('No work assigned.'));

          Map<String, List<MapEntry<DocumentSnapshot, Map>>> groupedByDay = {};

          for (var doc in docs) {
            final day = doc['day'];
            final taskList = List.from(doc['tasks']);
            groupedByDay.putIfAbsent(day, () => []);

            for (int i = 0; i < taskList.length; i++) {
              groupedByDay[day]!
                  .add(MapEntry(doc, {"tasks": taskList[i], "index": i}));
            }
          }

          return ListView(
            children: groupedByDay.entries.map((entry) {
              final day = entry.key;
              final tasks = entry.value;

              return ExpansionTile(
                title: Text(day.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                children: tasks.map((entry) {
                  final doc = entry.key;
                  final task = entry.value['tasks'];
                  final index = entry.value['index'];

                  return ListTile(
                    title: Text('${task['time']} - ${task['title']}'),
                    subtitle: Text(task['description']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () =>
                                _editTask(context, doc.id, task, index)),
                        IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteTask(context, doc.id, index)),
                      ],
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
