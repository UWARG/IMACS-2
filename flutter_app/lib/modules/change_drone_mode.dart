import 'package:dart_mavlink/dialects/common.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/command_constructors/set_mode_constructor.dart';
import 'dart:developer';

const String moduleName = "Change Drone Mode";

/// Define the MavMode constants and their string representations.
const Map<int, String> mavModes = {
  mavModePreflight: "Preflight",
  mavModeManualDisarmed: "Manual Disarmed",
  mavModeTestDisarmed: "Test Disarmed",
  mavModeStabilizeDisarmed: "Stabilize Disarmed",
  mavModeGuidedDisarmed: "Guided Disarmed",
  mavModeAutoDisarmed: "Auto Disarmed",
  mavModeManualArmed: "Manual Armed",
  mavModeTestArmed: "Test Armed",
  mavModeStabilizeArmed: "Stabilize Armed",
  mavModeGuidedArmed: "Guided Armed",
  mavModeAutoArmed: "Auto Armed",
};

class ChangeDroneMode {
  final MavlinkCommunication comm;

  ChangeDroneMode({required this.comm});

  void changeMode(int systemID, int componentID, MavMode baseMode) async {
    if (comm.connectionType == MavlinkCommunicationType.tcp) {
      await comm.tcpSocketInitializationFlag.future;
    }

    var frame = setMode(comm.sequence, systemID, componentID, baseMode);
    comm.sequence++;
    comm.write(frame);

    log('[$moduleName]: ${mavModes[baseMode]} mode set.');
  }
}
