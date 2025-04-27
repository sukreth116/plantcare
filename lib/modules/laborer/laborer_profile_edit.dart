import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantcare/clodinary_upload.dart';

class LaborerProfileUpdateScreen extends StatefulWidget {
  const LaborerProfileUpdateScreen({super.key, required String laborerId});

  @override
  State<LaborerProfileUpdateScreen> createState() =>
      _LaborerProfileUpdateScreenState();
}

class _LaborerProfileUpdateScreenState
    extends State<LaborerProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  File? _newProfileImage;
  String? _currentProfileImageUrl;
  bool isLoading = false;

  List<String> selectedDays = [];
  Map<String, TimeOfDay?> startTimes = {};
  Map<String, TimeOfDay?> endTimes = {};

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final uid = _auth.currentUser!.uid;
    final doc = await _firestore.collection('laborers').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      _nameController.text = data['name'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _locationController.text = data['location'] ?? '';
      _experienceController.text = data['experience'] ?? '';
      _skillsController.text = (data['skills'] as List).join(', ');
      _currentProfileImageUrl = data['profileImageUrl'];

      for (var entry in data['availableTime']) {
        final day = entry['day'];
        selectedDays.add(day);
        startTimes[day] =
            TimeOfDay(hour: entry['startHour'], minute: entry['startMinute']);
        endTimes[day] =
            TimeOfDay(hour: entry['endHour'], minute: entry['endMinute']);
      }

      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });

    try {
      String? imageUrl = _currentProfileImageUrl ?? '';
      if (_newProfileImage != null) {
        imageUrl = await getCloudinaryUrl(_newProfileImage!.path);
      }

      final uid = _auth.currentUser!.uid;
      await _firestore.collection('laborers').doc(uid).update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'location': _locationController.text.trim(),
        'experience': _experienceController.text.trim(),
        'skills':
            _skillsController.text.split(',').map((e) => e.trim()).toList(),
        'profileImageUrl': imageUrl,
        'availableTime': selectedDays
            .map((day) => {
                  'day': day,
                  'startHour': startTimes[day]?.hour ?? 0,
                  'startMinute': startTimes[day]?.minute ?? 0,
                  'endHour': endTimes[day]?.hour ?? 0,
                  'endMinute': endTimes[day]?.minute ?? 0,
                })
            .toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildDaySelection() {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return Wrap(
      spacing: 8.0,
      children: days.map((day) {
        return ChoiceChip(
          label: Text(day),
          selected: selectedDays.contains(day),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedDays.add(day);
                startTimes[day] = TimeOfDay(hour: 9, minute: 0);
                endTimes[day] = TimeOfDay(hour: 17, minute: 0);
              } else {
                selectedDays.remove(day);
                startTimes.remove(day);
                endTimes.remove(day);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTimePicker(String day, bool isStart) {
    final selectedTime = isStart ? startTimes[day] : endTimes[day];
    return ListTile(
      title: Text(
        '${isStart ? "Start" : "End"} Time: ${selectedTime?.format(context) ?? "Select"}',
      ),
      trailing: const Icon(Icons.access_time),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() {
            if (isStart) {
              startTimes[day] = picked;
            } else {
              endTimes[day] = picked;
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _newProfileImage != null
                            ? FileImage(_newProfileImage!)
                            : (_currentProfileImageUrl != null
                                ? NetworkImage(_currentProfileImageUrl!)
                                : const AssetImage('assets/default_avatar.png')
                                    as ImageProvider),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_nameController, 'Name', Icons.person),
                    const SizedBox(height: 10),
                    _buildTextField(_phoneController, 'Phone', Icons.phone),
                    const SizedBox(height: 10),
                    _buildTextField(
                        _locationController, 'Location', Icons.location_on),
                    const SizedBox(height: 10),
                    _buildTextField(
                        _experienceController, 'Experience', Icons.work),
                    const SizedBox(height: 10),
                    _buildTextField(_skillsController,
                        'Skills (comma-separated)', Icons.build),
                    const SizedBox(height: 20),
                    const Text("Select Available Days"),
                    _buildDaySelection(),
                    const SizedBox(height: 10),
                    ...selectedDays.expand((day) => [
                          _buildTimePicker(day, true),
                          _buildTimePicker(day, false),
                        ]),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: const Text('Update Profile'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
