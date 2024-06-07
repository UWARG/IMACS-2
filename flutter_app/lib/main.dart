import 'dart:math';

import 'package:flutter/material.dart';

import 'package:imacs/data_field_widget.dart';
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

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final comm =
      MavlinkCommunication(MavlinkCommunicationType.tcp, '127.0.0.1', 14550);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          // attitude
          DataField<double>(
            name: 'Yaw (deg)',
            value: comm.getYawStream(),
            formatter: (double value) => (value / pi * 180.0).round(),
          ),
          DataField<double>(
            name: 'Pitch (deg)',
            value: comm.getPitchStream(),
            formatter: (double value) => (value / pi * 180.0).round(),
          ),
          DataField<double>(
            name: 'Roll (deg)',
            value: comm.getRollStream(),
            formatter: (double value) => (value / pi * 180.0).round(),
          ),

          // global position
          DataField<int>(
            name: 'Latitude',
            value: comm.getLatStream(),
            formatter: (int value) => (value / 1e7).round(),
          ),
          DataField<int>(
            name: 'Longitude',
            value: comm.getLonStream(),
            formatter: (int value) => (value / 1e7).round(),
          ),
          DataField<int>(
            name: 'Altitude (m)',
            value: comm.getAltStream(),
            formatter: (int value) => (value / 1e3).round(),
          ),
        ],
      ),
    );
  }
}
