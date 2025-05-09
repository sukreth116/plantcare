import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WorkScheduleScreen extends StatefulWidget {
  final String nurseryId;

  const WorkScheduleScreen({required this.nurseryId, super.key});

  @override
  _WorkScheduleScreenState createState() => _WorkScheduleScreenState();
}

class _WorkScheduleScreenState extends State<WorkScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedWorkerId;
  String? selectedWorkerName;

  List<Map<String, dynamic>> workerList = [];

  @override
  void initState() {
    super.initState();
    fetchWorkers();
  }

  Future<void> fetchWorkers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('nursery_workers')
          .where('nurseryId', isEqualTo: widget.nurseryId)
          .get();

      List<Map<String, dynamic>> workers = snapshot.docs.map((doc) {
        return {'name': doc['name'], 'id': doc.id};
      }).toList();

      setState(() => workerList = workers);
    } catch (e) {
      print('Error fetching workers: $e');
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => selectedDate = pickedDate);
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() => selectedTime = pickedTime);
    }
  }

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null &&
        selectedWorkerId != null &&
        selectedWorkerName != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      String formattedTime = selectedTime!.format(context);

      Map<String, dynamic> taskData = {
        "task": taskController.text,
        "worker": selectedWorkerName,
        "workerId": selectedWorkerId,
        "description": descriptionController.text,
        "date": formattedDate,
        "time": formattedTime,
        "status": "Pending",
        "nurseryId": widget.nurseryId,
        "createdAt": Timestamp.now(),
      };

      try {
        await FirebaseFirestore.instance
            .collection('work_schedule')
            .add(taskData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task Assigned Successfully")),
        );

        // Reset form
        setState(() {
          taskController.clear();
          descriptionController.clear();
          selectedDate = null;
          selectedTime = null;
          selectedWorkerId = null;
          selectedWorkerName = null;
        });
      } catch (e) {
        print('Error adding task: $e');
      }
    }
  }

  Future<void> _updateStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('work_schedule')
          .doc(docId)
          .update({'status': newStatus});
    } catch (e) {
      print('Error updating status: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Work Schedule & Management"),
        backgroundColor: Colors.green[300],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("Assign New Task",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[300])),
              SizedBox(height: 10),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: taskController,
                        validator: (value) =>
                            value!.isEmpty ? "Enter task title" : null,
                        decoration: InputDecoration(
                          labelText: 'Task Title',
                          prefixIcon:
                              Icon(Icons.task_alt, color: Colors.green[300]),
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedWorkerId,
                        items: workerList.map((worker) {
                          final workerName = worker['name']?.toString() ?? '';
                          final workerId = worker['id']?.toString() ?? '';
                          return DropdownMenuItem<String>(
                            value: workerId,
                            child: Text(workerName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          final selected = workerList
                              .firstWhere((worker) => worker['id'] == value);
                          setState(() {
                            selectedWorkerId = selected['id'];
                            selectedWorkerName = selected['name'];
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Assigned Worker',
                          prefixIcon:
                              Icon(Icons.person, color: Colors.green[300]),
                        ),
                        validator: (value) =>
                            value == null ? "Please select a worker" : null,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: descriptionController,
                        validator: (value) =>
                            value!.isEmpty ? "Enter task details" : null,
                        decoration: InputDecoration(
                          labelText: 'Task Description',
                          prefixIcon:
                              Icon(Icons.description, color: Colors.green[300]),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedDate == null
                                  ? "Select Date"
                                  : "Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _pickDate,
                            icon:
                                Icon(Icons.calendar_today, color: Colors.white),
                            label: Text("Pick"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[300]),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedTime == null
                                  ? "Select Time"
                                  : "Time: ${selectedTime!.format(context)}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _pickTime,
                            icon: Icon(Icons.access_time, color: Colors.white),
                            label: Text("Pick"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[300]),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: _addTask,
                        icon: Icon(Icons.add, color: Colors.white),
                        label: Text("Assign Task",
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(thickness: 1.5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Scheduled Tasks",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[300])),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 400,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('work_schedule')
                      .where('nurseryId', isEqualTo: widget.nurseryId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final tasks = snapshot.data?.docs ?? [];

                    if (tasks.isEmpty) {
                      return Center(child: Text("No tasks scheduled yet."));
                    }

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final doc = tasks[index];
                        final task = doc.data() as Map<String, dynamic>;
                        final docId = doc.id;

                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green[300],
                              child:
                                  Icon(Icons.assignment, color: Colors.white),
                            ),
                            title: Text(task["task"] ?? "",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Worker: ${task["worker"] ?? ''}"),
                                Text("Date: ${task["date"] ?? ''}"),
                                Text("Time: ${task["time"] ?? ''}"),
                                _buildStatusChip(task["status"] ?? "Pending"),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (newValue) =>
                                  _updateStatus(docId, newValue),
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                    value: "Pending", child: Text("Pending")),
                                PopupMenuItem(
                                    value: "In Progress",
                                    child: Text("In Progress")),
                                PopupMenuItem(
                                    value: "Completed",
                                    child: Text("Completed")),
                              ],
                              icon: Icon(Icons.more_vert),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
