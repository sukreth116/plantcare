import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentBookingDetails extends StatelessWidget {
  final String farmerId;
  final String? laborerId;

  const AppointmentBookingDetails({
    super.key,
    required this.farmerId,
    this.laborerId,
  });

  Future<String> getLaborerName(String laborerId) async {
    DocumentSnapshot laborerDoc = await FirebaseFirestore.instance
        .collection('laborers')
        .doc(laborerId)
        .get();

    if (laborerDoc.exists) {
      return laborerDoc['name'] ?? "Unknown";
    }
    return "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Appointments"),
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
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
            return const Center(
              child: Text(
                "No appointments found.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              var appointment = appointments[index];
              String laborerId = appointment['laborerId'];

              return FutureBuilder<String>(
                future: getLaborerName(laborerId),
                builder: (context, laborerSnapshot) {
                  if (!laborerSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  String laborerName = laborerSnapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(15),
                      shadowColor: Colors.green.shade100,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Booking with: $laborerName",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 18, color: Colors.green),
                                const SizedBox(width: 8),
                                Text("Date: ${appointment['date']}"),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 18, color: Colors.green),
                                const SizedBox(width: 8),
                                Text("Time: ${appointment['time']}"),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 18, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(
                                        "Location: ${appointment['location']}")),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.verified,
                                    size: 18, color: Colors.green),
                                const SizedBox(width: 8),
                                Text("Status: ${appointment['status']}"),
                              ],
                            ),
                          ],
                        ),
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
