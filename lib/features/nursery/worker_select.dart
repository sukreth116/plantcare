// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:plantcare/features/nursery/works_list.dart';
// import 'package:plantcare/features/nursery/work_schedule.dart';

// class SelectWorkerScreen extends StatelessWidget {
//   final String nurseryId;

//   const SelectWorkerScreen({Key? key, required this.nurseryId})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Select Worker"),
//         backgroundColor: Colors.green[300],
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => WorkScheduleManagementScreen(
//                             nurseryId: nurseryId,
//                           )));
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('nursery_workers')
//             .where('nurseryId', isEqualTo: nurseryId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError)
//             return Center(child: Text('Error loading workers'));
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final workers = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: workers.length,
//             itemBuilder: (context, index) {
//               final worker = workers[index];
//               final name = worker['name'];

//               return ListTile(
//                 title: Text(name),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => NurseryWorkScreenByDay(
//                         nurseryId: nurseryId,
//                         workerId: worker.id,
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantcare/features/nursery/works_list.dart';
import 'package:plantcare/features/nursery/work_schedule.dart';

class SelectWorkerScreen extends StatelessWidget {
  final String nurseryId;

  const SelectWorkerScreen({super.key, required this.nurseryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Worker"),
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
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('nursery_workers')
            .where('nurseryId', isEqualTo: nurseryId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading workers'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final workers = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final worker = workers[index];
              final name = worker['name'];
              final imageUrl =
                  worker['profileImageUrl']; // Optional profile image

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  height: 80, // Increase card height
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green[200],
                        backgroundImage: imageUrl != null && imageUrl != ''
                            ? NetworkImage(imageUrl)
                            : AssetImage('assets/images/default_profile.png')
                                as ImageProvider,
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NurseryWorkScreenByDay(
                              nurseryId: nurseryId,
                              workerId: worker.id,
                            ),
                          ),
                        );
                      },
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
