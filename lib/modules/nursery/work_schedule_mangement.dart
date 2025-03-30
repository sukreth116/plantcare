import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkScheduleScreen extends StatefulWidget {
  @override
  _WorkScheduleScreenState createState() => _WorkScheduleScreenState();
}

class _WorkScheduleScreenState extends State<WorkScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController taskController = TextEditingController();
  TextEditingController workerController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  List<Map<String, dynamic>> workTasks = [];

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _addTask() {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      setState(() {
        workTasks.add({
          "task": taskController.text,
          "worker": workerController.text,
          "description": descriptionController.text,
          "date": DateFormat('yyyy-MM-dd').format(selectedDate!),
          "status": "Pending",
        });
      });

      // Clear fields after adding
      taskController.clear();
      workerController.clear();
      descriptionController.clear();
      selectedDate = null;
    }
  }

  void _updateStatus(int index, String status) {
    setState(() {
      workTasks[index]["status"] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Work Schedule & Management"),
        backgroundColor: Colors.green[700],
        elevation: 3,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: taskController,
                    validator: (value) => value!.isEmpty ? "Enter task title" : null,
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.task, color: Colors.green),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: workerController,
                    validator: (value) => value!.isEmpty ? "Enter worker name" : null,
                    decoration: InputDecoration(
                      labelText: 'Assigned Worker',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: Colors.green),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    validator: (value) => value!.isEmpty ? "Enter task details" : null,
                    decoration: InputDecoration(
                      labelText: 'Task Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description, color: Colors.green),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate == null ? "Select Date" : "Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _pickDate,
                        child: Text("Pick Date"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: _addTask,
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text("Assign Task"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: workTasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        workTasks[index]["task"],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Worker: ${workTasks[index]["worker"]}"),
                          Text("Date: ${workTasks[index]["date"]}"),
                          Text("Status: ${workTasks[index]["status"]}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: workTasks[index]["status"] == "Pending"
                                      ? Colors.orange
                                      : workTasks[index]["status"] == "In Progress"
                                          ? Colors.blue
                                          : Colors.green)),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String newValue) {
                          _updateStatus(index, newValue);
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(value: "Pending", child: Text("Pending")),
                          PopupMenuItem(value: "In Progress", child: Text("In Progress")),
                          PopupMenuItem(value: "Completed", child: Text("Completed")),
                        ],
                        icon: Icon(Icons.more_vert),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
