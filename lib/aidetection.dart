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
  final String flaskURL = 'http://192.168.1.65:5000/predict';

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
      crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plant Disease Detector')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_image != null) Image.file(_image!, height: 200),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: pickImageAndPredict,
                child: Text("Pick Image & Predict"),
              ),
              SizedBox(height: 16),
              if (isLoading) CircularProgressIndicator(),
              if (!isLoading) _buildResult(),
            ],
          ),
        ),
      ),
    );
  }
}
