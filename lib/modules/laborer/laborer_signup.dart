import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantcare/clodinary_upload.dart';

class LaborerSignupScreen extends StatefulWidget {
  const LaborerSignupScreen({super.key});

  @override
  _LaborerSignupScreenState createState() => _LaborerSignupScreenState();
}

class _LaborerSignupScreenState extends State<LaborerSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pricePerHourController = TextEditingController();

  File? _profileImage;
  bool isLoading = false;
  List<String> selectedDays = [];
  Map<String, TimeOfDay?> startTimes = {};
  Map<String, TimeOfDay?> endTimes = {};

  Future<void> _pickImage(bool isLogo) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _signupHandler() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });

    try {
      // Upload image to Cloudinary
      final imageUrl = await getCloudinaryUrl(_profileImage!.path);

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('laborers')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'location': _locationController.text.trim(),
        'experience': _experienceController.text.trim(),
        'skills': _skillsController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .toList(),
        'availableTime': selectedDays
            .map((day) => {
                  'day': day,
                  'startHour': startTimes[day]?.hour ?? 0,
                  'startMinute': startTimes[day]?.minute ?? 0,
                  'endHour': endTimes[day]?.hour ?? 0,
                  'endMinute': endTimes[day]?.minute ?? 0,
                })
            .toList(),
        'profileImageUrl': imageUrl,
        'pricePerHour':
            double.tryParse(_pricePerHourController.text.trim()) ?? 0.0,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Signup Successful!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      obscureText: isPassword,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildDaySelection() {
    List<String> days = [
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
      children: days
          .map((day) => ChoiceChip(
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
              ))
          .toList(),
    );
  }

  Widget _buildTimePicker(String day, bool isStart) {
    return ListTile(
      title: Text(
        isStart
            ? 'Start Time: ${startTimes[day]?.format(context) ?? "Select"}'
            : 'End Time: ${endTimes[day]?.format(context) ?? "Select"}',
      ),
      trailing: const Icon(Icons.access_time),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: isStart
              ? startTimes[day] ?? TimeOfDay.now()
              : endTimes[day] ?? TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            if (isStart) {
              startTimes[day] = pickedTime;
            } else {
              endTimes[day] = pickedTime;
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Laborer Signup"),
          backgroundColor: Colors.green.shade700),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField(_nameController, "Full Name", Icons.person),
                  const SizedBox(height: 10),
                  _buildTextField(_emailController, "Email", Icons.email),
                  const SizedBox(height: 10),
                  _buildTextField(_passwordController, "Password", Icons.lock,
                      isPassword: true),
                  const SizedBox(height: 10),
                  _buildTextField(_phoneController, "Phone", Icons.phone),
                  const SizedBox(height: 10),
                  _buildTextField(_pricePerHourController, "Price Per Hour",
                      Icons.attach_money),
                  const SizedBox(height: 10),
                  _buildTextField(
                      _locationController, "Location", Icons.location_on),
                  const SizedBox(height: 10),
                  _buildTextField(
                      _experienceController, "Experience", Icons.work),
                  const SizedBox(height: 10),
                  _buildTextField(_skillsController, "Skills (comma separated)",
                      Icons.list),
                  const SizedBox(height: 10),
                  const Text("Select Available Days"),
                  _buildDaySelection(),
                  ...selectedDays.map((day) => Column(children: [
                        _buildTimePicker(day, true),
                        _buildTimePicker(day, false)
                      ])),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _pickImage(true),
                    child: Text(_profileImage == null
                        ? 'Upload Company Logo'
                        : 'Logo Selected'),
                  ),
                  ElevatedButton(
                    onPressed: isLoading ? null : _signupHandler,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Signup"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
