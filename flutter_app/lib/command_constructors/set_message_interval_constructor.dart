import 'package:dart_mavlink/dialects/common.dart';
import 'package:dart_mavlink/mavlink.dart';

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
