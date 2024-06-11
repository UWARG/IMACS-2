import 'package:flutter/material.dart';
import 'package:imacs/drone_information.dart';

import 'package:imacs/mavlink_communication.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WARG IMACS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'WARG IMACS'),
    );
  }
}

// HomePage contains the main app Title and DroneInformation Widget.
// DroneInformation is responsible for showing all the data fetched
// from Mission Planner MAVLink
class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final comm =
      MavlinkCommunication(MavlinkCommunicationType.tcp, '127.0.0.1', 14550);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
      ),
      body: SizedBox(height: 500, child: DroneInformation(comm: comm)),
    );
  }
}
