import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/modules/sitl_logger.dart';
import 'package:dart_mavlink/dialects/common.dart';
import 'package:dart_mavlink/mavlink.dart';

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
        if (line.contains("Ready to take off")) {
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
    // todo: input parameters for heartbeat construction
    var dialect = MavlinkDialectCommon();
    var parser = MavlinkParser(dialect);

    var sequence = 0;
    var systemId = 255;
    var componentId = 1;
    var heartbeat = Heartbeat(
        customMode: 0,
        type: mavTypeGeneric,
        autopilot: mavAutopilotInvalid,
        baseMode: mavModeFlagManualInputEnabled,
        systemStatus: mavStateActive,
        mavlinkVersion: MavlinkDialectCommon.mavlinkVersion);

    bool heartbeatReceived = false;
    try {
      var frm = MavlinkFrame.v2(sequence, systemId, componentId, heartbeat);

      parser.stream.listen((MavlinkFrame frm) {
        if (frm.message is Heartbeat) {
          logs.logger("Heartbeat received: ${frm.message}");
          logs.stdoutlogs(_sitlProcess!);
          heartbeatReceived = true;
        }
      });

      comm.write(frm);
      logs.logger('Heartbeat sent!');

      Future.delayed(const Duration(seconds: 5), () {
        if (!heartbeatReceived) {
          logs.logger(
              'Timeout: Heartbeat not received within the expected time.');
          logs.stderrlogs(_sitlProcess!);
        }
      });
    } catch (e) {
      logs.logger('Failed to connect to MAVLink: ${e.toString()}');
      logs.stderrlogs(_sitlProcess!);
    }
  }
}
