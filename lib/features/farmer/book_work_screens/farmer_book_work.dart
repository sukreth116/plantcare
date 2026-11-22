import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantcare/features/farmer/book_work_screens/farmer_book_work_details.dart';
import 'package:plantcare/features/farmer/book_work_screens/farmer_book_work_list.dart';

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
        title: const Text('Book Work Appointment'),
        backgroundColor: Colors.green[400],
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

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(15),
                        shadowColor: Colors.green.shade200,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: farmerId == null
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
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: laborer['profileImageUrl'] !=
                                          null
                                      ? NetworkImage(laborer['profileImageUrl'])
                                      : AssetImage(
                                              'asset/image/profile_placeholder.jpg')
                                          as ImageProvider,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        laborer['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.green[800],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.workspace_premium,
                                              size: 16, color: Colors.green),
                                          const SizedBox(width: 6),
                                          Text(
                                              "Experience: ${laborer['experience']} yrs"),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              size: 16, color: Colors.green),
                                          const SizedBox(width: 6),
                                          Text("${laborer['location']}"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.phone,
                                              size: 16, color: Colors.green),
                                          const SizedBox(width: 6),
                                          Text("Phone: ${laborer['phone']}"),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.handyman,
                                              size: 16, color: Colors.green),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                                "Skills: ${laborer['skills']}"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.green,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
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
