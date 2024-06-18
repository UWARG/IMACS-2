import 'dart:math';
import 'package:flutter/material.dart';
import 'package:imacs/mavlink_communication.dart';

import 'data_field_widget.dart';

/// Widget to arrange multiple data widgets in tabular form.
///
/// This widget  displays all the data fetched from
/// Mission Planner MAVLink. It automatically sets the data in a two
/// column layout.
///
class DroneInformation extends StatelessWidget {
  /// @brief Constructs a DroneInformation widget.
  ///
  /// @param comm The communication channel (MAVLink) where to get
  /// the data from
  ///
  const DroneInformation({
    super.key,
    required this.comm,
  });

  final MavlinkCommunication comm;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: GridView.count(
        crossAxisCount: 2, /// describes how many items in one row.
        childAspectRatio: 2, /// describes how spaced out things are. 
        children: <DataField>[
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
    );
  }
}
