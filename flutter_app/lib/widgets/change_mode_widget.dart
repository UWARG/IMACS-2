import 'package:flutter/material.dart';
import 'package:dart_mavlink/dialects/common.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/modules/change_drone_mode.dart';

/// Define the MavMode constants and their string representations.
const Map<int, String> mavModes = {
  mavModePreflight: "Preflight",
  mavModeManualDisarmed: "Manual Disarmed",
  mavModeTestDisarmed: "Test Disarmed",
  mavModeStabilizeDisarmed: "Stabilize Disarmed",
  mavModeGuidedDisarmed: "Guided Disarmed",
  mavModeAutoDisarmed: "Auto Disarmed",
  mavModeManualArmed: "Manual Armed",
  mavModeTestArmed: "Test Armed",
  mavModeStabilizeArmed: "Stabilize Armed",
  mavModeGuidedArmed: "Guided Armed",
  mavModeAutoArmed: "Auto Armed",
};

/// Widget to change the mode of a drone using MAVLink communication.
///
/// This widget provides a dropdown menu to select a drone mode and a button
/// to change the mode of the drone. It takes MAVLink communication details
/// and a sequence number as inputs. The selected mode is sent to the drone
/// when the button is pressed.
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

/// State for the DroneModeChanger widget.
class DroneModeChangerState extends State<DroneModeChanger> {
  MavMode? _selectedMode;
  MavMode? _confirmedMode;
  late final ChangeDroneMode _changeDroneMode;

  @override
  void initState() {
    super.initState();
    _changeDroneMode = ChangeDroneMode(comm: widget.mavlinkCommunication);
  }

  /// Sends a command to change the drone's mode.
  void _changeMode() {
    if (_selectedMode != null) {
      _changeDroneMode.changeMode(
        widget.systemId,
        widget.componentId,
        _selectedMode!,
      );
      setState(() {
        _confirmedMode = _selectedMode;
      });
    } else {
      print('No mode selected');
    }
  }

  // /// Sends a command to change the drone's mode.
  // void _changeMode() {
  //   if (_selectedMode != null) {
  //     widget.mavlinkCommunication.changeMode(
  //       widget.systemId,
  //       widget.componentId,
  //       _selectedMode!,
  //     );
  //     setState(() {
  //       _confirmedMode = _selectedMode;
  //     });
  //   } else {
  //     print('No mode selected');
  //   }
  // }

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
          dropdownMenuEntries:
              mavModes.entries.map<DropdownMenuEntry<MavMode>>((entry) {
            return DropdownMenuEntry<MavMode>(
              value: entry.key,
              label: entry.value,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _selectedMode != null ? _changeMode : null,
          child: const Text('Change Mode'),
        ),
        const SizedBox(height: 16),
        Text(
          'Current Mode: ${_confirmedMode != null ? mavModes[_confirmedMode] : 'No Mode Selected'}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}