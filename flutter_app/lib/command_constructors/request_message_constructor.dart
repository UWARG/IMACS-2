import 'package:dart_mavlink/dialects/common.dart';
import 'package:dart_mavlink/mavlink.dart';

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
