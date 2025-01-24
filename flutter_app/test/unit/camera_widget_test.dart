import 'dart:developer';

import 'package:camera_universal/camera_universal.dart';
import 'package:test/test.dart';

const String moduleName = "Camera Test";

void main() {
  test('Check Camera', () async {
    CameraController cameraController = CameraController();
    await cameraController.initializeCameras();
    await cameraController.activateCamera(setState: (void Function) {
      log("[$moduleName] setState callback");
    }, mounted: () {
      log("[$moduleName] mounted callback");
      return true;
    });
    expect(cameraController.is_camera_init, equals(true));
    expect(cameraController.is_camera_active, equals(true));
  });
}
