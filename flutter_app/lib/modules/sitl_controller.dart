import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/modules/sitl_logger.dart';
import 'package:dart_mavlink/dialects/common.dart';

class SITLController {
  Process? _sitlProcess;

  final MavlinkCommunication comm;
  final String vehicleType;
  late SITLLogger logs;

  SITLController(
      {required this.vehicleType, required this.comm, required this.logs});

  Future<void> startSITL() async {
    try {
      _sitlProcess = await Process.start(
          'sim_vehicle.py', ['-v', vehicleType, '-w', '--no-mavproxy'],
          mode: ProcessStartMode.normal);

      logs.stdoutlogs(_sitlProcess!);

      //check if SITL is correctly initialized
      await for (String line in _sitlProcess!.stdout
          .transform(const SystemEncoding().decoder)
          .transform(const LineSplitter())) {
        logs.logger(line);
        if (line.contains("SITL Ready")) {
          break;
        }
      }

      await comm.tcpSocketInitializationFlag
          .future; // connects to mavlink communication tcp port
    } catch (e) {
      logs.logger('Failed to start SITL: ${e.toString()}');
    }
  }

  void stopSITL() {
    try {
      if (_sitlProcess != null) {
        _sitlProcess!.kill();
        logs.logger('Process stopped');
        _sitlProcess = null;
      } else {
        logs.logger('No process is running');
      }
    } catch (e) {
      logs.logger('Failed to stop SITL: ${e.toString()}');
    }
  }

  void sendHeartbeat() {
    //this is a sample heartbeat message
    try {
      var heartbeat = Heartbeat(
          customMode: mavTypeGeneric,
          type: mavTypeGeneric,
          autopilot: mavAutopilotInvalid,
          baseMode: mavModeFlagManualInputEnabled,
          systemStatus: mavStateActive,
          mavlinkVersion: MavlinkDialectCommon.mavlinkVersion);

      // need a way to check if the heartbeat is valid and working

      logs.logger('Connection to MAVLink is successful!');
      logs.stdoutlogs(_sitlProcess!);
    } catch (e) {
      logs.logger('Failed to connect to MAVLink: ${e.toString()}');
      logs.stderrlogs(_sitlProcess!);
    }
  }
}
