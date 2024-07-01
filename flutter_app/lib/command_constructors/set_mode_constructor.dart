import 'package:dart_mavlink/dialects/common.dart';
import 'package:dart_mavlink/mavlink.dart';

/// Constructs a MAVLink command to set the mode of the vehicle using MAV_CMD_DO_SET_MODE (176).
///
/// @sequence The sequence number for the MAVLink frame.
/// Each component counts up its send sequence.
/// Allows to detect packet loss.
/// @systemId The MAVLink system ID of the vehicle (normally "1").
/// @componentId The MAVLink component ID (normally "0").
/// @customMode The new autopilot-specific mode. This is system-specific.
/// @baseMode The new base mode.
/// @customSubMode The new autopilot-specific sub-mode. This is system-specific.
///
/// @return A MAVLink frame representing the set mode command.
MavlinkFrame setMode(
    int sequence, int systemID, int componentID, MavMode baseMode,
    {int customMode = 0, int customSubMode = 0}) {
  var commandLong = CommandLong(
      targetSystem: 1,
      targetComponent: 0,
      command: 176,
      confirmation: 0,
      param1: baseMode.toDouble(),
      param2: customMode.toDouble(),
      param3: customSubMode.toDouble(),
      param4: 0,
      param5: 0,
      param6: 0,
      param7: 0);
  var frm = MavlinkFrame.v2(sequence, systemID, componentID, commandLong);
  return frm;
}
