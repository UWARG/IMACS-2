import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

// ignore_for_file: avoid_print

/// Constructs a MAVLink command to request a single instance of a message using MAV_CMD_REQUEST_MESSAGE (512).
///
/// @sequence The sequence number for the MAVLink frame.
/// Each component counts up its send sequence.
/// Allows to detect packet loss.
/// @systemId The MAVLink system ID of the vehicle (normally "1").
/// @componentId The MAVLink component ID (normally "0").
/// @messageId The MAVLink message ID of the requested message.
/// @param2 Depends on the message requested; see that message's definition for details. Otherwise 0.
/// @param3-6 The use of this parameter, must be defined in the requested message. Otherwise 0.
/// @responseTarget: Target address of message stream (if message has target address fields).
/// 0: Flight-stack default (recommended), 1: address of requestor, 2: broadcast.
///
/// @return A MAVLink frame representing the request command.
MavlinkFrame requestMessage(
  int sequence,
  int systemID,
  int componentID,
  int messageID, {
  int param2 = 0,
  int param3 = 0,
  int param4 = 0,
  int param5 = 0,
  int param6 = 0,
  int responseTarget = 0,
}) {
  var commandLong = CommandLong(
      targetSystem: 1,
      targetComponent: 0,
      command: 512,
      confirmation: 0,
      param1: messageID.toDouble(),
      param2: param2.toDouble(),
      param3: param3.toDouble(),
      param4: param4.toDouble(),
      param5: param5.toDouble(),
      param6: param6.toDouble(),
      param7: responseTarget.toDouble());
  var frm = MavlinkFrame.v2(sequence, systemID, componentID, commandLong);
  return frm;
}

// Construct command to request messages at a specified rate using MAV_CMD_SET_MESSAGE_INTERVAL (511)
///
/// @sequence: The sequence number for the MAVLink frame.
/// Each component counts up its send sequence.
/// Allows to detect packet loss.
/// @systemId: The MAVLink system ID of the vehicle (normally "1").
/// @componentId: The MAVLink component ID (normally "0").
/// @messageId: The MAVLink message ID of the requested message.
/// @interval: Time interval between messages in microseconds.
/// -1: disable, 0: request default rate.
/// @responseTarget: Target address of message stream (if message has target address fields).
/// 0: Flight-stack default (recommended), 1: address of requestor, 2: broadcast.
///
/// @return A MAVLink frame representing the request command.
MavlinkFrame setMessageInterval(
    int sequence, int systemID, int componentID, int messageID, int interval,
    {int responseTarget = 0}) {
  var commandLong = CommandLong(
      targetSystem: 1,
      targetComponent: 0,
      command: 511,
      confirmation: 0,
      param1: messageID.toDouble(),
      param2: interval.toDouble(), // interval in μs
      param3: 0,
      param4: 0,
      param5: 0,
      param6: 0,
      param7: responseTarget.toDouble());
  var frm = MavlinkFrame.v2(sequence, systemID, componentID, commandLong);
  return frm;
}

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

  return missionItem;
}
