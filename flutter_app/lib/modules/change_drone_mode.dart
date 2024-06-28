import 'package:dart_mavlink/dialects/common.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/command_constructors/set_mode_constructor.dart';

extension ChangeDroneMode on MavlinkCommunication {

  void changeMode(int systemID, int componentID, MavMode baseMode) async {
    if (connectionType == MavlinkCommunicationType.tcp) {
      await tcpSocketInitializationFlag.future;
    }

    var frame = setMode(sequence, systemID, componentID, baseMode);
    sequence++;
    write(frame);
  }
}
