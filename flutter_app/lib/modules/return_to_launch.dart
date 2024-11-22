import 'package:imacs/command_constructors/return_to_launch_constructor.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'dart:developer';

const String moduleName = "Return To Launch";

class ReturnToLaunch {
  final MavlinkCommunication comm;

  // Requires both the constructor (Mission Item) and comm
  ReturnToLaunch({required this.comm});

  // Skips the queues and forces the drone to return
  Future returnNoQueue(int systemID, int componentID) async {
    try {
      if (comm.connectionType == MavlinkCommunicationType.tcp) {
        await comm.tcpSocketInitializationFlag.future;
      }
      var frame = returnToLaunch(comm.sequence, systemID, componentID);
      comm.sequence++;
      comm.write(frame);

      log('[$moduleName] Returning to Launch');
      return true;
    } catch (e) {
      log('[$moduleName] Error occurred: $e');
      return false;
    }
  }
}
