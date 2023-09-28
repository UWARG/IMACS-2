import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

// ignore_for_file: avoid_print

// Construct command to request a single instance of a message using MAV_CMD_REQUEST_MESSAGE (512)
MavlinkFrame requestMessage(
    int sequence, int systemId, int componentId, int messageId, int param2) {
  var commandLong = CommandLong(
      targetSystem: 1,
      targetComponent: 0,
      command: 512,
      confirmation: 0,
      param1: messageId.toDouble(),
      param2: param2
          .toDouble(), // parameter required for some messages, described in common message set
      param3: 0,
      param4: 0,
      param5: 0,
      param6: 0,
      param7: 0);
  var frm = MavlinkFrame.v2(sequence, systemId, componentId, commandLong);
  return frm;
}

// Construct command to request messages at a specified rate using MAV_CMD_SET_MESSAGE_INTERVAL (511)
MavlinkFrame setMessageInterval(
    int sequence, int systemId, int componentId, int messageId, int interval) {
  var commandLong = CommandLong(
      targetSystem: 1,
      targetComponent: 0,
      command: 511,
      confirmation: 0,
      param1: messageId.toDouble(),
      param2: interval.toDouble(), // interval in μs
      param3: 0,
      param4: 0,
      param5: 0,
      param6: 0,
      param7: 0);
  var frm = MavlinkFrame.v2(sequence, systemId, componentId, commandLong);
  return frm;
}

void testConstruction() {
  var sequence = 0;
  var systemId = 255;
  var componentId = 1;
  var messageId = 33; // GLOBAL_POSITION_INT
  var interval = 1000000;

  var dialect = MavlinkDialectCommon();
  var parser = MavlinkParser(dialect);
  parser.stream.listen((MavlinkFrame frm) {
    if (frm.message is CommandLong) {
      var cl = frm.message as CommandLong;
      if (cl.command == 512) {
        print("Received Request Message");
        print("Message id: ${cl.param1}");
      } else if (cl.command == 511) {
        print("Received Set Message Interval");
        print("Interval: ${cl.param2} μs");
        print("Message id: ${cl.param1}");
      }
    }
  });

  parser.parse(requestMessage(sequence, systemId, componentId, messageId, 0)
      .serialize());
  parser.parse(
      setMessageInterval(sequence, systemId, componentId, messageId, interval)
          .serialize());
}