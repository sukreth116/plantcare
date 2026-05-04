import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class DiseasePredictorScreen extends StatefulWidget {
  @override
  _DiseasePredictorScreenState createState() => _DiseasePredictorScreenState();
}

class _DiseasePredictorScreenState extends State<DiseasePredictorScreen> {
  File? _image;
  Map<String, dynamic>? result;
  bool isLoading = false;

  final picker = ImagePicker();
  // final String flaskURL = 'http://192.168.1.65:5000/predict';
  // final String flaskURL = 'http://192.168.20.9:5000/predict';
  final String flaskURL = 'http://192.168.20.32:5000/predict';

  Future<void> pickImageAndPredict() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      isLoading = true;
      result = null;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(flaskURL));
      request.files
          .add(await http.MultipartFile.fromPath('file', pickedFile.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        try {
          setState(() {
            result = json.decode(response.body);
          });
        } catch (e) {
          setState(() {
            result = {'error': 'Invalid response format from server.'};
          });
        }
      } else {
        setState(() {
          result = {
            'error': 'Prediction failed with status ${response.statusCode}'
          };
        });
      }
    } catch (e) {
      setState(() {
        result = {'error': e.toString()};
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildResult() {
    if (result == null) return SizedBox.shrink();
    if (result!.containsKey('error')) {
      return Text(result!['error'], style: TextStyle(color: Colors.red));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Disease: ${result!['disease_name']}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text("Description: ${result!['description']}"),
        SizedBox(height: 8),
        Text("Steps: ${result!['possible_steps']}"),
        SizedBox(height: 8),
        Text("Supplement: ${result!['supplement_name']}"),
        SizedBox(height: 8),
        Image.network(result!['supplement_image_url'], height: 150),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            launchUrl(Uri.parse(result!['buy_url']));
          },
          child: Text("Buy Supplement"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade300,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Curious about a plant? Worried about its health? Simply snap a photo or upload one from your gallery, and let our AI analyze the species and detect any signs of disease. Get instant insights to keep your plants thriving!",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                if (_image != null) Image.file(_image!, height: 200),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: pickImageAndPredict,
                  icon: Icon(Icons.image_search,
                      color: Colors.white), // You can change this icon
                  label: Text("Pick Image & Predict"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    backgroundColor: Colors.green.shade300,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                if (isLoading) CircularProgressIndicator(),
                if (!isLoading) _buildResult(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
