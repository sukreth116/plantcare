import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantcare/modules/farmer/farmer_book_work_details.dart';
import 'package:plantcare/modules/farmer/farmer_book_work_list.dart';

class FarmerWorkAppointmentScreen extends StatefulWidget {
  const FarmerWorkAppointmentScreen({super.key});

  @override
  _FarmerWorkAppointmentScreenState createState() =>
      _FarmerWorkAppointmentScreenState();
}

class _FarmerWorkAppointmentScreenState
    extends State<FarmerWorkAppointmentScreen> {
  String? farmerId;

  @override
  void initState() {
    super.initState();
    _fetchFarmerId();
  }

  /// Fetch farmer ID from Firestore
  Future<void> _fetchFarmerId() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var farmerDoc = await FirebaseFirestore.instance
          .collection('farmers')
          .doc(userId)
          .get();
      if (farmerDoc.exists) {
        setState(() {
          farmerId = farmerDoc.id;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Book Work Appointment'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_history), // Manage Appointments Icon
            tooltip: "Manage Appointments",
            onPressed: () {
              if (farmerId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AppointmentBookingDetails(farmerId: farmerId!),
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
      body: farmerId == null
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
                          onPressed: farmerId == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AppointmentDetailsScreen(
                                        laborerName: laborer['name'],
                                        laborerId: laborer.id,
                                        farmerId: farmerId!,
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
