import 'package:flutter/material.dart';
import 'package:camera_universal/camera_universal.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  final CameraController cameraController = CameraController();
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController cameraController = CameraController();
  @override
  void initState() {
    super.initState();
    task();
  }
  Future<void> task() async {
    await cameraController.initializeCameras();
    await cameraController.initializeCamera(
      setState: setState,
    );
    await cameraController.activateCamera(
      setState: setState,
      mounted: () {
        return mounted;
      },
    );
  }
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Camera(
        cameraController: cameraController,
        onCameraNotInit: (context) {
          return const SizedBox.shrink();
        },
        onCameraNotSelect: (context) {
          return const SizedBox.shrink();
        },
        onCameraNotActive: (context) {
          return const SizedBox.shrink();
        },
        onPlatformNotSupported: (context) {
          return const SizedBox.shrink();
        },
      )
    );
  }
}