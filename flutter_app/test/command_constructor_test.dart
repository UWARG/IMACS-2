import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';
import 'package:imacs/command_constructor.dart';
import 'package:test/test.dart';

void main() {
  /// dialect: Selected MAVLink dialect
  /// sequence: The sequence number for the MAVLink frame.
  /// Each component counts up its send sequence.
  /// Allows to detect packet loss.
  /// systemId: The MAVLink system ID of the vehicle (normally "1").
  /// componentId: The MAVLink component ID (normally "0").
  /// messageId: The MAVLink message ID of the requested message.
  var dialect = MavlinkDialectCommon();
  const sequence = 0;
  const systemID = 1;
  const componentID = 0;
  const messageID = 33; // GLOBAL_POSITION_INT

  group('Command Constructor Tests', () {
    test('Request Message', () {
      const requestMessageCommandNumber =
          512; // MAV_CMD (MavLink Command) Number for requesting a single instance of a particular MAVLink message ID

      var parser = MavlinkParser(dialect);
      parser.stream.listen((MavlinkFrame frm) {
        if (frm.message is CommandLong) {
          var cl = frm.message as CommandLong;
          expect(cl.command, equals(requestMessageCommandNumber));
          expect(cl.param1, equals(messageID));
        }
      });

      parser.parse(requestMessage(sequence, systemID, componentID, messageID)
          .serialize());
    });

    test('Set Message Interval', () {
      const interval = 1000000; // Time interval in microseconds == 1 second
      const setIntervalCommandNumber =
          511; // MAV_CMD (MavLink Command) Number for setting an interval between messages for a particular MAVLink message ID

      var parser = MavlinkParser(dialect);
      parser.stream.listen((MavlinkFrame frm) {
        if (frm.message is CommandLong) {
          var cl = frm.message as CommandLong;
          expect(cl.command, equals(setIntervalCommandNumber));
          expect(cl.param2, equals(interval));
          expect(cl.param1, equals(messageID));
        }
      });

      parser.parse(setMessageInterval(
              sequence, systemID, componentID, messageID, interval)
          .serialize());
    });

    test('Change Mode', () {
      const changeModeCommandNumber =
          176; // MAV_CMD Number for changing the mode
      const baseMode = MAV_MODE_GUIDED_ARMED;

      var parser = MavlinkParser(dialect);
      parser.stream.listen((MavlinkFrame frm) {
        if (frm.message is CommandLong) {
          var cl = frm.message as CommandLong;
          expect(cl.command, equals(changeModeCommandNumber));
          expect(cl.param1, equals(baseMode));
        }
      });

      parser.parse(
          setMode(sequence, systemID, componentID, baseMode).serialize());
    });
  });
}
