// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class AIDetectionScreen extends StatefulWidget {
//   @override
//   _AIDetectionScreenState createState() => _AIDetectionScreenState();
// }

// class _AIDetectionScreenState extends State<AIDetectionScreen> {
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();

//   // Function to open the camera
//   // Future<void> _openCamera() async {
//   //   final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _selectedImage = File(pickedFile.path);
//   //     });
//   //   }
//   // }

//   // Function to open the gallery
//   // Future<void> _openGallery() async {
//   //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _selectedImage = File(pickedFile.path);
//   //     });
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("AI Species & Disease Detection"),
//         backgroundColor: Colors.teal,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Open Camera Button
//             ElevatedButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.camera_alt),
//               label: Text("Open Camera"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//               ),
//             ),
//             SizedBox(height: 10),
//             // Open Gallery Button
//             ElevatedButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.photo_library),
//               label: Text("Open Gallery"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//               ),
//             ),
//             // Display selected image
//             _selectedImage != null
//                 ? Image.file(
//                     _selectedImage!,
//                     height: 250,
//                     fit: BoxFit.cover,
//                   )
//                 : Container(
//                     height: 250,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(
//                       Icons.image,
//                       size: 100,
//                       color: Colors.grey,
//                     ),
//                   ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AIDetectionScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      // Process the selected image for AI detection
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Detection"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'asset/image/Anxiety-pana1.png',
              height: 200,
            ),
            Text(
              "Detect Plant Species & Diseases",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Curious about a plant? Worried about its health? Simply snap a photo or upload one from your gallery, and let our AI analyze the species and detect any signs of disease. Get instant insights to keep your plants thriving!",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              label: Text("Open Camera"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: Icon(
                Icons.image,
                color: Colors.white,
              ),
              label: Text("Open Gallery"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
