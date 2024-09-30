import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/modules/get_drone_information.dart';
import 'package:imacs/widgets/change_port_protocol_widget.dart';
import 'package:imacs/widgets/drone_information_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  final defaultCommunicationType = MavlinkCommunicationType.tcp;
  final defaultCommunicationAddress = '127.0.0.1';
  final defaultTcpPort = 14550;

  late var comm =
      MavlinkCommunication(defaultCommunicationType, defaultCommunicationAddress, defaultTcpPort);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          DroneInformation(
            getDroneInformation: GetDroneInformation(comm: comm),
          ),
        ],
      ),
    );
  }

  void updateCommunicationParams(MavlinkCommunicationType connectionType, String connectionAddress, int tcpPort) {
    log('[Change Port/Protocol] Updating communication params: $connectionType, $connectionAddress, $tcpPort');
    comm = MavlinkCommunication(connectionType, connectionAddress, tcpPort);
  }
}
