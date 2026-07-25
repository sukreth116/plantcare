import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloudinary/cloudinary.dart';

class GlbUploadScreen extends StatefulWidget {
  const GlbUploadScreen({super.key});

  @override
  State<GlbUploadScreen> createState() => _GlbUploadScreenState();
}

class _GlbUploadScreenState extends State<GlbUploadScreen> {
  bool isUploading = false;
  String? uploadedUrl;

  Future<void> pickAndUploadGlbSigned() async {
    setState(() {
      isUploading = true;
      uploadedUrl = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['glb'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;

        final cloudinary = Cloudinary.signedConfig(
          cloudName: 'ds0psaxoc', // 🔁 Your cloud name
          apiKey: '467315474851437', // 🔁 Your API key
          apiSecret: 'DuxlsUbu1oahxHDkQkzXmggBb7Q', // 🔁 Your API secret
        );

        final response = await cloudinary.upload(
          file: filePath,
          resourceType: CloudinaryResourceType.raw, // GLB = raw
        );

        if (response.isSuccessful && response.secureUrl != null) {
          setState(() {
            uploadedUrl = response.secureUrl;
          });
        } else {
          _showError('Upload failed: ${response.error ?? 'Unknown error'}');

        }
      } else {
        _showError('No file selected.');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signed Upload .glb File')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isUploading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Pick & Upload .glb File'),
                      onPressed: pickAndUploadGlbSigned,
                    ),
                    const SizedBox(height: 20),
                    if (uploadedUrl != null) ...[
                      const Text('Upload successful:'),
                      const SizedBox(height: 10),
                      SelectableText(
                        uploadedUrl!,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
