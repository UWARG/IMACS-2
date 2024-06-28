import 'dart:async';
import 'package:imacs/modules/mavlink_communication.dart';

extension GetDroneInformation on MavlinkCommunication {
  Stream<double> getYawStream() {
    return yawStreamController.stream;
  }

  Stream<double> getPitchStream() {
    return pitchStreamController.stream;
  }

  Stream<double> getRollStream() {
    return rollStreamController.stream;
  }

  Stream<double> getRollSpeedStream() {
    return rollSpeedController.stream;
  }

  Stream<double> getPitchSpeedStream() {
    return pitchSpeedController.stream;
  }

  Stream<double> getYawSpeedStream() {
    return yawSpeedController.stream;
  }

  Stream<int> getTimeBootMsPitchStream() {
    return timeBootMsPitchController.stream;
  }

  Stream<int> getLatStream() {
    return latStreamController.stream;
  }

  Stream<int> getLonStream() {
    return lonStreamController.stream;
  }

  Stream<int> getAltStream() {
    return altStreamController.stream;
  }
}
