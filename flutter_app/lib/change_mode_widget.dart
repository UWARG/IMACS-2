import 'package:flutter/material.dart';
import 'package:imacs/mavlink_communication.dart';
import 'package:dart_mavlink/dialects/common.dart';

/// Widget that allows the user to change the mode of a drone using MAVLink communication.
class DroneModeChanger extends StatefulWidget {
  final MavlinkCommunication mavlinkCommunication;
  final int systemId;
  final int componentId;

  const DroneModeChanger({
    Key? key,
    required this.mavlinkCommunication,
    required this.systemId,
    required this.componentId,
  }) : super(key: key);

  @override
  DroneModeChangerState createState() => DroneModeChangerState();
}

class DroneModeChangerState extends State<DroneModeChanger> {
  int _sequence = 0;
  MavMode? _selectedMode; /// Holding onto mode selected by the user.

  /// Sends a command to change the drone's mode.
  void _changeMode() {
    if (_selectedMode != null) {
      widget.mavlinkCommunication.changeMode(
        _sequence,
        widget.systemId,
        widget.componentId,
        _selectedMode!,
      );
      setState(() {
        _sequence++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownMenu<MavMode>(
      initialSelection: _selectedMode,
      onSelected: (MavMode? value) {
        // This is called when the user selects an item.
        setState(() {
          _selectedMode = value;
        });
      },
      dropdownMenuEntries: MavMode.values.map<DropdownMenuEntry<MavMode>>((MavMode mode) {
            return DropdownMenuEntry<MavMode>(
              value: mode,
              label: mode.toString().split('.').last,
            );
      }).toList(),
    ),
        ElevatedButton(
          onPressed: _changeMode,
          child: const Text('Change Mode'),
        ),
      ],
    );
  }
}
