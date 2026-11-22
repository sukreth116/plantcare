import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageNurseries extends StatefulWidget {
  const ManageNurseries({super.key});

  @override
  State<ManageNurseries> createState() => _ManageNurseriesState();
}

class _ManageNurseriesState extends State<ManageNurseries>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Nurseries',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          labelColor: Colors.white,
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNurseryList(false), // Pending nurseries
          _buildNurseryList(true), // Approved nurseries
        ],
      ),
    );
  }

  Widget _buildNurseryList(bool isApproved) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('nurseries')
          .where('isApproved', isEqualTo: isApproved)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              isApproved
                  ? 'No approved nurseries found.'
                  : 'No pending nurseries found.',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          );
        }

        final nurseries = snapshot.data!.docs;
        return ListView.builder(
          itemCount: nurseries.length,
          itemBuilder: (context, index) {
            final nursery = nurseries[index];
            final name = nursery['nurseryName'] ?? 'No Name';
            final email = nursery['email'] ?? 'No Email';
            final phone = nursery['phone'] ?? 'No Phone';
            final location = nursery['address'] ?? 'No Location';
            final companyLicenseUrl = nursery['companyLicenseUrl'] ?? '';
            final companyLogoUrl = nursery['companyLogoUrl'] ?? '';

            return _buildNurseryCard(context, name, email, isApproved, phone,
                location, nursery.id, companyLogoUrl, companyLicenseUrl);
          },
        );
      },
    );
  }

  Widget _buildNurseryCard(
      BuildContext context,
      String name,
      String email,
      bool isApproved,
      String phone,
      String location,
      String id,
      String companyLogoUrl,
      String companyLicenseUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NurseryDetails(
              nurseryId: id,
              name: name,
              email: email,
              isApproved: isApproved,
              phone: phone,
              location: location,
              companyLicenseUrl: companyLicenseUrl,
              companyLogoUrl: companyLogoUrl,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isApproved ? Colors.green.shade100 : Colors.blue.shade100,
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.storefront,
                  color:
                      isApproved ? Colors.green.shade700 : Colors.blue.shade700,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isApproved
                              ? Colors.green.shade700
                              : Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Email: $email',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Location: $location',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isApproved ? Icons.check_circle : Icons.pending,
                  color: isApproved ? Colors.green : Colors.blue,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class NurseryDetails extends StatelessWidget {
  final String nurseryId;
  final String name;
  final String email;
  final bool isApproved;
  final String phone;
  final String location;
  final String companyLicenseUrl;
  final String companyLogoUrl;

  const NurseryDetails({
    super.key,
    required this.nurseryId,
    required this.name,
    required this.email,
    required this.isApproved,
    required this.phone,
    required this.location,
    required this.companyLicenseUrl,
    required this.companyLogoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $email',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: $phone',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: $location',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            if (companyLogoUrl.isNotEmpty)
              Column(
                children: [
                  const Text(
                    'Company Logo:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Image.network(companyLogoUrl, height: 100),
                  const SizedBox(height: 16),
                ],
              ),
            if (companyLicenseUrl.isNotEmpty)
              Column(
                children: [
                  const Text(
                    'Company License:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Image.network(companyLicenseUrl, height: 100),
                  const SizedBox(height: 16),
                ],
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('nurseries')
                    .doc(nurseryId)
                    .update({'isApproved': !isApproved});
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isApproved ? Colors.red : Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text(
                isApproved ? 'Revoke Approval' : 'Approve Nursery',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
