import 'package:dart_mavlink/dialects/common.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/command_constructors/set_mode_constructor.dart';
import 'dart:developer';

import 'package:imacs/widgets/change_mode_widget.dart';

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

    log('${mavModes[baseMode]} mode set.');
  }
}
