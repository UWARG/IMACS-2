import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';
import 'package:flutter/rendering.dart';
import 'package:imacs/modules/mavlink_communication.dart';
//import 'package:imacs/modules/change_drone_mode.dart';
//import 'package:imacs/modules/get_drone_information.dart';

class SITLController {
  Process? _sitlProcess;

  final MavlinkCommunication comm;
  final String vehicleType;
  final String GPS; //replace with GPS locations

  SITLController(
      {required this.vehicleType, required this.GPS, required this.comm});
  //don't know how to use the changeMode() method properly, if needed at all for this

  Future<void> startSITL() async {
    try {
      _sitlProcess = await Process.start(
        './Tools/autotest/sim_vehicle.py',
        ['-v', vehicleType, '-L', GPS, '--out=tcp:127.0.0.1:14550'],
      ); // passing in info to start SITL, not sure if i did this right

      // outputs/errors from the SITL itself?
      _sitlProcess!.stdout.transform(SystemEncoding().decoder).listen((data) {
        log('SITL Output: $data');
      });

      _sitlProcess!.stderr.transform(SystemEncoding().decoder).listen((data) {
        log('SITL Error: $data');
      });

      await comm.tcpSocketInitializationFlag
          .future; // connects to mavlink communication tcp port

      _sitlProcess!.exitCode.then((exitCode) {
        log('SITL process exited with code: $exitCode');
        _sitlProcess = null;
      });
    } catch (e) {
      log('Failed to start SITL');
    }
  }

  void stopSITL() {
    if (_sitlProcess != null) {
      _sitlProcess!.kill();
      log('Process stopped.');
      _sitlProcess = null;
    } else {
      log('No process is running.');
    }
    // need to close the mavlink socket after stopping, idk how
  }

  void sendHeartbeat() {
    //how to make a heartbeat message to confirm communication w/ SITL?
    //do i even need one?
  }
}
