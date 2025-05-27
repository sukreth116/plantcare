import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantcare/modules/nursery/nursery_book_work_details.dart';
import 'package:plantcare/modules/nursery/nursery_book_work_list.dart';

class NurseryWorkAppointmentScreen extends StatefulWidget {
  const NurseryWorkAppointmentScreen({super.key});

  @override
  _NurseryWorkAppointmentScreenState createState() =>
      _NurseryWorkAppointmentScreenState();
}

class _NurseryWorkAppointmentScreenState
    extends State<NurseryWorkAppointmentScreen> {
  String? nurseryId;

  @override
  void initState() {
    super.initState();
    _fetchFarmerId();
  }

  /// Fetch farmer ID from Firestore
  Future<void> _fetchFarmerId() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var nurseryDoc = await FirebaseFirestore.instance
          .collection('nurseries')
          .doc(userId)
          .get();
      if (nurseryDoc.exists) {
        setState(() {
          nurseryId = nurseryDoc.id;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Work Appointment'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_history), // Manage Appointments Icon
            tooltip: "Manage Appointments",
            onPressed: () {
              if (nurseryId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NurseryAppointmentBookingDetails(nurseryId: nurseryId!),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Farmer ID not found")),
                );
              }
            },
          ),
        ],
      ),
      body: nurseryId == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('laborers').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var laborers = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: laborers.length,
                  itemBuilder: (context, index) {
                    var laborer = laborers[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(laborer['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Experience: ${laborer['experience']} years'),
                            Text('Location: ${laborer['location']}'),
                            Text('Skills: ${laborer['skills']}'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: nurseryId == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NurseryAppointmentDetailsScreen(
                                        laborerName: laborer['name'],
                                        laborerId: laborer.id,
                                        nurseryId: nurseryId!,
                                      ),
                                    ),
                                  );
                                },
                          child: const Text('Book'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
