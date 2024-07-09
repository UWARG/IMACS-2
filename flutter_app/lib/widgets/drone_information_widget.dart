import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:imacs/modules/get_drone_information.dart';
import 'package:imacs/widgets/data_field_widget.dart';

/// Widget to arrange multiple data widgets in tabular form.
///
/// This widget selective data made available by MavlinkgetDroneInformationunication.
/// Arranges the data in a grid with two columns and applies a border.
///
class DroneInformation extends StatefulWidget {
  /// @brief Constructs a DroneInformation widget.
  ///
  /// @param getDroneInformation The communication channel (MAVLink) where to get
  /// the data from
  ///
  const DroneInformation({
    super.key,
    required this.getDroneInformation,
  });

  final GetDroneInformation getDroneInformation;

  @override
  State<DroneInformation> createState() => _DroneInformationState();
}

class _DroneInformationState extends State<DroneInformation> {
  @override
  void initState() {
    developer.log('Drone Information Widget rendered completely!');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 500,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: GridView.count(
        crossAxisCount: 2,

        /// describes how many items in one row.
        childAspectRatio: 2,

        /// describes how spaced out things are.
        children: <DataField>[
          DataField<double>(
            name: 'Yaw (deg)',
            value: widget.getDroneInformation.getYawStream(),
            formatter: (double value) =>
                (value / pi * 180.0).toStringAsFixed(2),
          ),
          DataField<double>(
            name: 'Pitch (deg)',
            value: widget.getDroneInformation.getPitchStream(),
            formatter: (double value) =>
                (value / pi * 180.0).toStringAsFixed(2),
          ),
          DataField<double>(
            name: 'Roll (deg)',
            value: widget.getDroneInformation.getRollStream(),
            formatter: (double value) =>
                (value / pi * 180.0).toStringAsFixed(2),
          ),
          // global position
          DataField<int>(
            name: 'Latitude',
            value: widget.getDroneInformation.getLatStream(),
            formatter: (int value) => (value / 1e7).toStringAsFixed(2),
          ),
          DataField<int>(
            name: 'Longitude',
            value: widget.getDroneInformation.getLonStream(),
            formatter: (int value) => (value / 1e7).toStringAsFixed(2),
          ),
          DataField<int>(
            name: 'Altitude (m)',
            value: widget.getDroneInformation.getAltStream(),
            formatter: (int value) => (value / 1e3).toStringAsFixed(2),
          ),
        ],
      ),
    );
  }
}
