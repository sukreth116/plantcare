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
    if (!mounted) return;
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
        'isApproved': false,
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

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Signup Successful!')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (!mounted) return;
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
        filled: true,
        fillColor: Colors.green.shade100,
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none),
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
      children: days.map((day) {
        final bool isSelected = selectedDays.contains(day);
        return ChoiceChip(
          label: Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          selected: isSelected,
          selectedColor: Colors.green.shade400, // Green when selected
          backgroundColor:
              Colors.green[100], // Light background when not selected
          side: BorderSide.none,
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
          helpText: 'Select ${isStart ? "start" : "end"} time for $day',
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Image.asset(
                    'asset/image/farm tractor-amico.png',
                    height: 200,
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Register As Laborer",
                    style: TextStyle(
                      color: Color.fromARGB(255, 193, 12, 190),
                      fontFamily: 'Milky',
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => _pickImage(true),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green.shade100,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.add_a_photo,
                                size: 40, color: Colors.green.shade700)
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    _profileImage == null
                        ? "Tap to upload profile photo"
                        : "Profile photo selected",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  // const Text("Select Available Days"),
                  // _buildDaySelection(),
                  // ...selectedDays.map((day) => Column(children: [
                  //       _buildTimePicker(day, true),
                  //       _buildTimePicker(day, false)
                  //     ])),
                  const Text(
                    "Select Available Days",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  SizedBox(height: 10),
                  _buildDaySelection(),
                  const SizedBox(height: 20),
                  ...selectedDays.map((day) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            day,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          _buildTimePicker(day, true),
                          _buildTimePicker(day, false),
                        ],
                      )),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : _signupHandler,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green.shade400, // Button background color
                      foregroundColor: Colors.white, // Text (and icon) color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("SIGN UP"),
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
