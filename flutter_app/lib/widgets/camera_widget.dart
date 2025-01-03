import 'package:flutter/material.dart';
import 'package:camera_universal/camera_universal.dart';

/// Widget to display camera feed
class CameraWidget extends StatefulWidget {
  final CameraController cameraController = CameraController();

  CameraWidget({super.key});
  @override
  State<CameraWidget> createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
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
    ));
  }
}
