import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:camera_universal/camera_universal.dart';

const String moduleName = "Camera";

/// Widget to display a live feed from a connected camera.
///
/// This widget interfaces with the camera hardware to capture and siplay
/// a real-time video freed on the screen.
class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});
  @override
  State<CameraWidget> createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  CameraController cameraController = CameraController();
  @override
  void initState() {
    super.initState();
    initCameraController();
  }

  Future<void> initCameraController() async {
    /// Initializes and activates the camera controller.
    ///
    /// This function initializes the available cameras, configures the camera
    /// controller, and activates the camera feed.
    ///
    /// @returns A `Future<void>` indicating completion of the setup.

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
        log('[$moduleName] Camera not initialized');
        return const SizedBox.shrink();
      },
      onCameraNotSelect: (context) {
        log('[$moduleName] Camera not selected');
        return const SizedBox.shrink();
      },
      onCameraNotActive: (context) {
        log('[$moduleName] Camera not active');
        return const SizedBox.shrink();
      },
      onPlatformNotSupported: (context) {
        log('[$moduleName] Unsupported platform');
        return const SizedBox.shrink();
      },
    ));
  }
}
