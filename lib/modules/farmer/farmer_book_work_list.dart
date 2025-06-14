import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentBookingDetails extends StatelessWidget {
  final String farmerId;
  final String? laborerId; // Optional laborerId

  const AppointmentBookingDetails({super.key, required this.farmerId, this.laborerId});
 
  /// Fetch laborer name using laborerId
  Future<String> getLaborerName(String laborerId) async {
    DocumentSnapshot laborerDoc = await FirebaseFirestore.instance
        .collection('laborers')
        .doc(laborerId)
        .get(); 

    if (laborerDoc.exists) {
      return laborerDoc['name'] ?? "Unknown"; // Return laborer name
    }
    return "Unknown"; // Default value if not found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Appointments")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('farmerId', isEqualTo: farmerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var appointments = snapshot.data!.docs;

          if (appointments.isEmpty) {
            return const Center(child: Text("No appointments found."));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              var appointment = appointments[index];
              String laborerId = appointment['laborerId'];

              return FutureBuilder(
                future: getLaborerName(laborerId),
                builder: (context, laborerSnapshot) {
                  if (!laborerSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  String laborerName = laborerSnapshot.data as String;

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text("Booking with: $laborerName"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date: ${appointment['date']}"),
                          Text("Time: ${appointment['time']}"),
                          Text("Location: ${appointment['location']}"),
                          Text("Status: ${appointment['status']}"),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
