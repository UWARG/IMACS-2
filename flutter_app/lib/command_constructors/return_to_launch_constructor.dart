import 'package:dart_mavlink/dialects/common.dart';
import 'package:dart_mavlink/mavlink.dart';

/// Constructs a MissionItem command to return to launch using MAV_CMD_NAV_RETURN_TO_LAUNCH (20).
///
/// @sequence The sequence number for the MAVLink frame.
/// @systemId The MAVLink system ID of the vehicle (normally "1").
/// @componentId The MAVLink component ID (normally "0").
/// @param1 Unused
/// @param2 Unused
/// @param3 Unused
/// @param4 Unused
/// @param5 Unused
/// @param6 Unused
/// @param7 Unused
///
/// @return A MavlinkFrame representing the reutrn to launch command.

MavlinkFrame returnToLaunch(int sequence, int systemID, int componentID) {
  var commandLong = CommandLong(
    targetSystem: systemID,
    targetComponent: componentID,
    command: mavCmdNavReturnToLaunch,
    confirmation: 0,
    param1: 0,
    param2: 0,
    param3: 0,
    param4: 0,
    param5: 0,
    param6: 0,
    param7: 0,
  );

  var frm = MavlinkFrame.v2(sequence, systemID, componentID, commandLong);

  return frm;
}
