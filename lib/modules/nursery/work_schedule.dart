import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WorkScheduleManagementScreen extends StatefulWidget {
  final String nurseryId;

  const WorkScheduleManagementScreen({required this.nurseryId, super.key});

  @override
  _WorkScheduleManagementScreenState createState() =>
      _WorkScheduleManagementScreenState();
}

class _WorkScheduleManagementScreenState
    extends State<WorkScheduleManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController singleTaskTitleController =
      TextEditingController();
  final TextEditingController singleTaskDescController =
      TextEditingController();
  DateTime? selectedDate;

  List<Map<String, String>> tasks = [];
  TimeOfDay? selectedTime;
  String? selectedWorkerId;
  String? selectedWorkerName;
  String? selectedDay;

  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

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

  void _addToTaskList() {
    final title = singleTaskTitleController.text.trim();
    final desc = singleTaskDescController.text.trim();

    if (title.isNotEmpty && desc.isNotEmpty && selectedTime != null) {
      String taskTime = selectedTime!.format(context);

      setState(() {
        tasks.add({
          "title": title,
          "description": desc,
          "time": taskTime,
        });
        singleTaskTitleController.clear();
        singleTaskDescController.clear();
        selectedTime = null; // Reset time after task added
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and pick time")),
      );
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
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
        selectedDay != null &&
        selectedWorkerId != null &&
        selectedWorkerName != null &&
        selectedDate != null &&
        tasks.isNotEmpty) {
      Map<String, dynamic> taskData = {
        "day": selectedDay,
        "worker": selectedWorkerName,
        "workerId": selectedWorkerId,
        "nurseryId": widget.nurseryId,
        "tasks": tasks,
        "status": "Pending",
        "createdAt": Timestamp.now(),
        "date": DateFormat('yyyy-MM-dd')
            .format(selectedDate!), // <--- Add this line
      };

      try {
        await FirebaseFirestore.instance
            .collection('work_schedule')
            .add(taskData);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Task Group Added Successfully")));

        setState(() {
          selectedDay = null;
          selectedWorkerId = null;
          selectedWorkerName = null;
          tasks.clear();
          selectedTime = null;
        });
      } catch (e) {
        print("Error storing grouped tasks: $e");
      }
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text("Assign Fixed Work",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[300])),
                SizedBox(
                  height: 10,
                ),
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
                      onPressed: () => _pickDate(context),
                      icon: Icon(Icons.date_range, color: Colors.white),
                      label: Text("Pick"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[300],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedDay,
                  items: daysOfWeek.map((day) {
                    return DropdownMenuItem<String>(
                      value: day,
                      child: Text(day),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedDay = value),
                  decoration: InputDecoration(
                    labelText: 'Select Day',
                    prefixIcon:
                        Icon(Icons.calendar_today, color: Colors.green[300]),
                  ),
                  validator: (value) =>
                      value == null ? "Please select a day" : null,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedWorkerId,
                  items: workerList.map((worker) {
                    return DropdownMenuItem<String>(
                      value: worker['id'],
                      child: Text(worker['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final selected =
                        workerList.firstWhere((w) => w['id'] == value);
                    setState(() {
                      selectedWorkerId = selected['id'];
                      selectedWorkerName = selected['name'];
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Assigned Worker',
                    prefixIcon: Icon(Icons.person, color: Colors.green[300]),
                  ),
                  validator: (value) =>
                      value == null ? "Please select a worker" : null,
                ),
                SizedBox(height: 20),
                Text("Add Tasks",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 10),
                TextFormField(
                  controller: singleTaskTitleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    prefixIcon: Icon(Icons.title, color: Colors.green[300]),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: singleTaskDescController,
                  decoration: InputDecoration(
                    labelText: 'Task Description',
                    prefixIcon:
                        Icon(Icons.description, color: Colors.green[300]),
                  ),
                ),
                SizedBox(height: 8),
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
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _addToTaskList,
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text("Add Task"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300]),
                ),
                SizedBox(height: 10),
                Column(
                  children: tasks.map((task) {
                    return ListTile(
                      title: Text(task["title"] ?? ''),
                      subtitle: Text(task["description"] ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() => tasks.remove(task)),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: Icon(Icons.check, color: Colors.white),
                  label: Text("Submit Schedule",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
