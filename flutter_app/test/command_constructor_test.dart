import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';
import 'package:flutter_app/command_constructor.dart';
import 'package:test/test.dart';

void main() {
  group('Command Constructor Tests', () {
    const sequence = 0;
    const systemID = 1;
    const componentID = 0;
    const messageID = 33; // GLOBAL_POSITION_INT
    var dialect = MavlinkDialectCommon();

    test('Request Message', () {
      const requestMessageCommandNumber = 512; // MAV_CMD (MavLink Command) Number for requesting a single instance of a particular MAVLink message ID
      
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
      const setIntervalCommandNumber = 511; // MAV_CMD (MavLink Command) Number for setting an interval between messages for a particular MAVLink message ID

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
  });
}
