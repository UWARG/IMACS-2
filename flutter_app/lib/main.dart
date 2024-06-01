import 'dart:math';

import 'package:flutter/material.dart';

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
      body: DroneInformation(comm: comm),
    );
  }
}

// DroneInformation is a widget that displays all the data fetched from
// Mission Planner MAVLink. It automatically sets the data in a two
// column layout.
class DroneInformation extends StatelessWidget {
  const DroneInformation({
    super.key,
    required this.comm,
  });

  final MavlinkCommunication comm;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                DataField<double>(
                  name: 'Yaw (deg)',
                  value: comm.getYawStream(),
                  formatter: (double value) =>
                      (value / pi * 180.0).toStringAsFixed(2),
                ),
                DataField<double>(
                  name: 'Pitch (deg)',
                  value: comm.getPitchStream(),
                  formatter: (double value) =>
                      (value / pi * 180.0).toStringAsFixed(2),
                ),
              ],
            ),
            Row(
              children: [
                DataField<double>(
                  name: 'Roll (deg)',
                  value: comm.getRollStream(),
                  formatter: (double value) =>
                      (value / pi * 180.0).toStringAsFixed(2),
                ),
                // global position
                DataField<int>(
                  name: 'Latitude',
                  value: comm.getLatStream(),
                  formatter: (int value) => (value / 1e7).toStringAsFixed(2),
                ),
              ],
            ),
            Row(
              children: [
                // attitude
                DataField<int>(
                  name: 'Longitude',
                  value: comm.getLonStream(),
                  formatter: (int value) => (value / 1e7).toStringAsFixed(2),
                ),
                DataField<int>(
                  name: 'Altitude (m)',
                  value: comm.getAltStream(),
                  formatter: (int value) => (value / 1e3).toStringAsFixed(2),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// Used to show a single instance of data from Mission Planner MAVLink.
// Makes a column, shows the name of the data field on the first row,
// and a formatted value on the second row.
class DataField<T> extends StatelessWidget {
  const DataField(
      {Key? key,
      required this.name,
      required this.value,
      required this.formatter})
      : super(key: key);

  final String name;
  final Stream<T> value;
  final Function(T) formatter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "$name ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          StreamBuilder<T>(
            stream: value,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Text(
                  formatter(snapshot.data as T).toString(),
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              } else {
                return const Text('No data');
              }
            },
          ),
        ],
      ),
    );
  }
}
