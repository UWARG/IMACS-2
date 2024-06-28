import 'dart:async';
import 'package:imacs/modules/mavlink_communication.dart';

class GetDroneInformation {
  final MavlinkCommunication comm;

  GetDroneInformation({required this.comm});

  Stream<double> getYawStream() {
    return comm.yawStreamController.stream;
  }

  Stream<double> getPitchStream() {
    return comm.pitchStreamController.stream;
  }

  Stream<double> getRollStream() {
    return comm.rollStreamController.stream;
  }

  Stream<double> getRollSpeedStream() {
    return comm.rollSpeedController.stream;
  }

  Stream<double> getPitchSpeedStream() {
    return comm.pitchSpeedController.stream;
  }

  Stream<double> getYawSpeedStream() {
    return comm.yawSpeedController.stream;
  }

  Stream<int> getTimeBootMsPitchStream() {
    return comm.timeBootMsPitchController.stream;
  }

  Stream<int> getLatStream() {
    return comm.latStreamController.stream;
  }

  Stream<int> getLonStream() {
    return comm.lonStreamController.stream;
  }

  Stream<int> getAltStream() {
    return comm.altStreamController.stream;
  }
}