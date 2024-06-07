import 'dart:math';
import 'package:flutter/material.dart';
import 'package:imacs/mavlink_communication.dart';

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
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: <DataField>[
        DataField<double>(
          name: 'Yaw (deg)',
          value: comm.getYawStream(),
          formatter: (double value) => (value / pi * 180.0).toStringAsFixed(2),
        ),
        DataField<double>(
          name: 'Pitch (deg)',
          value: comm.getPitchStream(),
          formatter: (double value) => (value / pi * 180.0).toStringAsFixed(2),
        ),
        DataField<double>(
          name: 'Roll (deg)',
          value: comm.getRollStream(),
          formatter: (double value) => (value / pi * 180.0).toStringAsFixed(2),
        ),
        // global position
        DataField<int>(
          name: 'Latitude',
          value: comm.getLatStream(),
          formatter: (int value) => (value / 1e7).toStringAsFixed(2),
        ),
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
    return Column(
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
    );
  }
}
