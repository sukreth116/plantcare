// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class LaborerSignupScreen extends StatefulWidget {
//   const LaborerSignupScreen({super.key});

//   @override
//   _LaborerSignupScreenState createState() => _LaborerSignupScreenState();
// }

// class _LaborerSignupScreenState extends State<LaborerSignupScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _experienceController = TextEditingController();
//     final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final List<String> _skills = [];
//   final TextEditingController _skillController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();
//   File? _profileImage;
//   bool isLoading = false;

//   Future<void> _signupHandler() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match!')),
//       );
//       return;
//     }
//     setState(() { isLoading = true; });

//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       await FirebaseFirestore.instance.collection('laborers').doc(userCredential.user!.uid).set({
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'location': _locationController.text.trim(),
//         'experience': _experienceController.text.trim(),
//         // 'skills': _skillsController.text.split(',').map((s) => s.trim()).toList(),
//         'isApproved': false,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Signup Successful!')),
//       );
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     } finally {
//       setState(() { isLoading = false; });
//     }
//   }

//   List<String> selectedDays = [];
//   Map<String, TimeOfDay?> startTimes = {};
//   Map<String, TimeOfDay?> endTimes = {};

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = File(pickedFile.path);
//       });
//     }
//   }

//   void _addSkill() {
//     if (_skillController.text.isNotEmpty) {
//       setState(() {
//         _skills.add(_skillController.text);
//         _skillController.clear();
//       });
//     }
//   }

//   void _removeSkill(String skill) {
//     setState(() {
//       _skills.remove(skill);
//     });
//   }

//   Widget _buildDaySelection() {
//     List<String> days = [
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Saturday',
//       'Sunday'
//     ];
//     return Wrap(
//       children: days.map((day) {
//         return ChoiceChip(
//           label: Text(day),
//           selected: selectedDays.contains(day),
//           onSelected: (bool selected) {
//             setState(() {
//               if (selected) {
//                 selectedDays.add(day);
//                 startTimes[day] = TimeOfDay(hour: 9, minute: 0);
//                 endTimes[day] = TimeOfDay(hour: 17, minute: 0);
//               } else {
//                 selectedDays.remove(day);
//                 startTimes.remove(day);
//                 endTimes.remove(day);
//               }
//             });
//           },
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildTimePicker(String day, bool isStart) {
//     return ListTile(
//       title: Text(
//         isStart
//             ? "Start Time: ${startTimes[day]?.format(context) ?? 'Select'}"
//             : "End Time: ${endTimes[day]?.format(context) ?? 'Select'}",
//       ),
//       trailing: const Icon(Icons.access_time),
//       onTap: () async {
//         TimeOfDay? pickedTime = await showTimePicker(
//           context: context,
//           initialTime: isStart
//               ? startTimes[day] ?? TimeOfDay.now()
//               : endTimes[day] ?? TimeOfDay.now(),
//         );
//         if (pickedTime != null) {
//           setState(() {
//             if (isStart) {
//               startTimes[day] = pickedTime;
//             } else {
//               endTimes[day] = pickedTime;
//             }
//           });
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Laborer Signup"),
//         backgroundColor: Colors.green.shade700,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildTextField(_nameController, "Full Name", Icons.person),
//                 _buildTextField(_emailController, "Email", Icons.email,
//                     isEmail: true),
//                 _buildTextField(_passwordController, "Password", Icons.lock,
//                     isPassword: true),
//                 _buildTextField(_confirmPasswordController, "Confirm Password", Icons.lock, isPassword: true),
//                 _buildTextField(_phoneController, "Phone Number", Icons.phone),
//                 _buildTextField(
//                     _locationController, "Location", Icons.location_on),
//                 _buildTextField(
//                     _experienceController, "Experience", Icons.work),
//                 _buildSkillSection(),
//                 const SizedBox(height: 16.0),
//                 const Text("Profile Photo"),
//                 _buildImageUploadSection(),
//                 const SizedBox(height: 16.0),
//                 _buildDaySelection(),
//                 const SizedBox(height: 10),
//                 ...selectedDays.map((day) => Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(day,
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold)),
//                         _buildTimePicker(day, true),
//                         _buildTimePicker(day, false),
//                         const Divider(),
//                       ],
//                     )),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : _signupHandler,
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green.shade700),
//                     child: const Text('Signup',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       TextEditingController controller, String label, IconData icon,
//       {bool isEmail = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: Colors.green),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
//         ),
//         keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
//       ),
//     );
//   }

//   Widget _buildImageUploadSection() {
//     return Column(
//       children: [
//         _profileImage != null
//             ? Image.file(_profileImage!,
//                 height: 150, width: 150, fit: BoxFit.cover)
//             : const Text('No image selected'),
//         ElevatedButton.icon(
//           onPressed: _pickImage,
//           icon: const Icon(Icons.image),
//           label: const Text('Upload Profile Photo'),
//           style:
//               ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
//         ),
//       ],
//     );
//   }

//   Widget _buildSkillSection() {
//     return Column(
//       children: [
//         TextFormField(
//           controller: _skillController,
//           decoration: const InputDecoration(labelText: "Enter a skill"),
//         ),
//         ElevatedButton(onPressed: _addSkill, child: const Text("Add Skill")),
//         Wrap(
//           children: _skills
//               .map((skill) => Chip(
//                   label: Text(skill), onDeleted: () => _removeSkill(skill)))
//               .toList(),
//         ),
//       ],
//     );
//   }
// }
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  File? _profileImage;
  bool isLoading = false;
  List<String> selectedDays = [];
  Map<String, TimeOfDay?> startTimes = {};
  Map<String, TimeOfDay?> endTimes = {};

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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
                  _buildTextField(
                      _locationController, "Location", Icons.location_on),
                  const SizedBox(height: 10),
                  _buildTextField(
                      _experienceController, "Experience", Icons.work),
                  const SizedBox(height: 10),
                  _buildTextField(_skillsController, "Skills (comma separated)",
                      Icons.list),
                  const SizedBox(height: 10),
                  _buildDaySelection(),
                  ...selectedDays.map((day) => Column(children: [
                        _buildTimePicker(day, true),
                        _buildTimePicker(day, false)
                      ])),
                  const SizedBox(height: 20),
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
