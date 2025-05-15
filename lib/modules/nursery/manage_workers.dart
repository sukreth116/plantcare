import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkerManagementScreen extends StatelessWidget {
  final String nurseryId;

  const WorkerManagementScreen({super.key, required this.nurseryId});

  Future<void> _toggleApproval(DocumentSnapshot workerDoc) async {
    bool currentApproval = workerDoc['isApproved'] ?? false;
    await FirebaseFirestore.instance
        .collection('nursery_workers')
        .doc(workerDoc.id)
        .update({'isApproved': !currentApproval});
  }

  Future<void> _deleteWorker(
      BuildContext context, DocumentSnapshot workerDoc) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Worker'),
        content: const Text('Are you sure you want to delete this worker?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      await FirebaseFirestore.instance
          .collection('nursery_workers')
          .doc(workerDoc.id)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Workers'),
        backgroundColor: Colors.green[700],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('nursery_workers')
            .where('nurseryId', isEqualTo: nurseryId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final workers = snapshot.data?.docs ?? [];

          if (workers.isEmpty) {
            return const Center(child: Text("No workers found."));
          }

          return ListView.builder(
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final worker = workers[index];
              final data = worker.data() as Map<String, dynamic>;
              final bool isApproved = data['isApproved'] ?? false;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  leading: data['profileImageUrl'] != null &&
                          data['profileImageUrl'].toString().isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(data['profileImageUrl']),
                          radius: 24,
                        )
                      : const CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                  title: Text(data['name'] ?? 'Unnamed'),
                  subtitle:
                      Text('Status: ${isApproved ? 'Approved' : 'Pending'}'),
                  childrenPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    if (data['email'] != null)
                      Row(
                        children: [
                          const Icon(Icons.email, size: 18),
                          const SizedBox(width: 6),
                          Expanded(child: Text(data['email'])),
                        ],
                      ),
                    const SizedBox(height: 6),
                    if (data['phone'] != null)
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 18),
                          const SizedBox(width: 6),
                          Text(data['phone']),
                        ],
                      ),
                    const SizedBox(height: 6),
                    if (data['joinedDate'] != null)
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 6),
                          Text("Joined: ${data['joinedDate']}"),
                        ],
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _toggleApproval(worker),
                          icon: Icon(
                            isApproved
                                ? Icons.undo
                                : Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                          label: Text(
                            isApproved ? 'Set as Pending' : 'Approve',
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => _deleteWorker(context, worker),
                          icon: const Icon(Icons.delete, color: Colors.white),
                          label: const Text('Delete',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
