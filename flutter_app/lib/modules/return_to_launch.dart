import 'package:dart_mavlink/dialects/common.dart';
import 'package:dart_mavlink/mavlink.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'dart:developer';

const String moduleName = "Return To Launch";

class ReturnToLaunch {
  final MavlinkCommunication comm;
  final MissionItem returnToLaunchConstructor;

  ReturnToLaunch({required this.comm, required this.returnToLaunchConstructor});

  void returnNoQueue() async {
    if (comm.connectionType == MavlinkCommunicationType.tcp) {
      await comm.tcpSocketInitializationFlag.future;
    }

    var frame = MavlinkFrame.v2(
        returnToLaunchConstructor.seq,
        returnToLaunchConstructor.targetSystem,
        returnToLaunchConstructor.targetComponent,
        returnToLaunchConstructor);

    comm.sequence++;
    comm.write(frame);

    log('[$moduleName] Returning to Launch');
  }
}
