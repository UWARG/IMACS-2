import 'package:flutter/material.dart';
import 'package:imacs/modules/get_airside_logs.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/modules/get_drone_information.dart';
import 'package:imacs/widgets/drone_information_widget.dart';
import 'package:imacs/widgets/log_display_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final comm =
      MavlinkCommunication(MavlinkCommunicationType.tcp, '127.0.0.1', 14550);
  final String pathToDirectory = "C:\\Users\\emmao\\Documents\\logs";

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
          LogReader(
            getAirsideLogs: GetAirsideLogs(pathToDirectory: pathToDirectory),
          ),
        ],
      ),
    );
  }
}
