import 'package:dart_mavlink/dialects/common.dart';

/// Constructs a MissionItem command to return to launch using MAV_CMD_NAV_RETURN_TO_LAUNCH (20).
///
/// @sequence The sequence number for the MAVLink frame.
/// @systemId The MAVLink system ID of the vehicle (normally "1").
/// @componentId The MAVLink component ID (normally "0").
/// @latitude The latitude of the launchpad (Defaults to where it was armed).
/// @longitude The longitude of the launchpad (Defaults to where it was armed).
/// @altitude The altitude of the waypoint (Defaults to 15m)
/// @param1 Unused
/// @param2 Unused
/// @param3 Unused
/// @param4 Unused
///
/// @return A MissionItem representing the reutrn to launch command.

MissionItem returnToLaunch(int sequence, int systemID, int componentID,
    {double latitude = 0.0,
    double longitude = 0.0,
    double altitude = 15.0,
    double param1 = 0,
    double param2 = 0,
    double param3 = 0,
    double param4 = 0}) {
  var missionItem = MissionItem(
      targetSystem: systemID,
      targetComponent: componentID,
      seq: sequence,
      frame: mavFrameGlobalRelativeAlt,
      command: mavCmdNavReturnToLaunch,
      current: 1,
      autocontinue: 1,
      param1: param1,
      param2: param2,
      param3: param3,
      param4: param4,
      x: latitude,
      y: longitude,
      z: altitude,
      missionType: 0);
  return missionItem;
}
