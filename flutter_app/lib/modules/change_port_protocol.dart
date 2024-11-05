import 'dart:developer';

import 'package:imacs/modules/mavlink_communication.dart';

const String moduleName = "Change Port/Protocol";

class ChangePortProtocol {
  final MavlinkCommunication comm;

  ChangePortProtocol({required this.comm});

  void updateCommParams(MavlinkCommunicationType connectionType,
      String connectionAddress, int tcpPort) {
    comm.updateConnectionParams(connectionType, connectionAddress, tcpPort);
    
    log('[$moduleName] Communication params updated to: $connectionType, $connectionAddress, $tcpPort');
  }
}