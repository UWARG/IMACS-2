import 'dart:io';
import 'dart:async';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/modules/sitl_logger.dart';

class SITLController {
  Process? _sitlProcess;

  final MavlinkCommunication comm;
  final String vehicleType;
  final String GPS; //replace with GPS location, or other format of location
  final SITLLogger logs;

  SITLController(
      {required this.vehicleType,
      required this.GPS,
      required this.comm,
      required this.logs});
  //don't know how to use the changeMode() method properly, if needed at all for this

  Future<void> startSITL() async {
    try {
      _sitlProcess = await Process.start(
        './Tools/autotest/sim_vehicle.py',
        ['-v', vehicleType, '-L', GPS, '--out=tcp:127.0.0.1:14550'],
      ); // passing in info to start SITL, not sure if i did this right

      // outputs/errors from the SITL itself?
      logs.stdoutlogs(_sitlProcess!);

      logs.stderrlogs(_sitlProcess!);

      await comm.tcpSocketInitializationFlag
          .future; // connects to mavlink communication tcp port

      _sitlProcess!.exitCode.then((exitCode) {
        logs.logger('SITL process exited with code: $exitCode');
        _sitlProcess = null;
      });
    } catch (e) {
      logs.logger('Failed to start SITL');
    }
  }

  void stopSITL() {
    if (_sitlProcess != null) {
      _sitlProcess!.kill();
      logs.logger('Process stopped');
      _sitlProcess = null;
    } else {
      logs.logger('No process is running');
    }
    // need to close the mavlink socket after stopping, idk how
  }

  void sendHeartbeat() {
    //how to make a heartbeat message to confirm communication w/ SITL?
    //do i even need one?
  }
}
