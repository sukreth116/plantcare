import 'package:augmented_reality_plugin/augmented_reality_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ARViewScreen extends StatelessWidget {
  final String imageUrl;

  const ARViewScreen({super.key, required this.imageUrl});

  bool _isMobile() {
    return (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMobile()) {
      // Render Web AR Viewer
      return Scaffold(
        appBar: AppBar(title: const Text('Web AR View')),
        body: ModelViewer(
          src: imageUrl,
          alt: "AR Model",
          ar: true,
          autoRotate: true,
          cameraControls: true,
        ),
      );
    }

    // Render native AR on Android/iOS
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile AR View')),
      body: AugmentedRealityPlugin(imageUrl),
    );
  }
}
