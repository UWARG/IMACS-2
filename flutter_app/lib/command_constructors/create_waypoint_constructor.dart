import 'package:dart_mavlink/dialects/common.dart';
import 'dart:developer';

/// Constructs a MissionItem command to create a new waypoint using MAV_CMD_NAV_WAYPOINT (16).
///
/// @sequence The sequence number for the MAVLink frame.
/// @systemId The MAVLink system ID of the vehicle (normally "1").
/// @componentId The MAVLink component ID (normally "0").
/// @latitude The latitude of the waypoint.
/// @longitude The longitude of the waypoint.
/// @altitude The altitude of the waypoint.
/// @param1 Hold time in decimal seconds.
/// @param2 Acceptance radius in meters (how close the vehicle must get to the waypoint before it moves to the next waypoint).
/// @param3 Orbit radius in meters (for circle mode, set to 0 to disable).
/// @param4 Desired yaw angle in degrees (set to NaN to use the default yaw angle).
///
/// @return A MissionItem representing the waypoint command.
MissionItem createWaypoint(int sequence, int systemID, int componentID,
    double latitude, double longitude, double altitude,
    {double param1 = 0,
    double param2 = 0,
    double param3 = 0,
    double param4 = 0}) {
  var missionItem = MissionItem(
    targetSystem: systemID,
    targetComponent: componentID,
    seq: sequence,
    frame: mavFrameGlobalRelativeAlt,
    command: mavCmdNavWaypoint,
    current: 1,
    autocontinue: 1,
    param1: param1,
    param2: param2,
    param3: param3,
    param4: param4,
    x: latitude,
    y: longitude,
    z: altitude,
    missionType: mavMissionTypeMission,
  );

  log('Created a waypoint at ($latitude, $longitude)');

  return missionItem;
}
