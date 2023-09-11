import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';
import 'package:flutter_app/command_constructor.dart';
import 'package:test/test.dart';

void main() {
  group('Command Constructor Tests', () {
    var sequence = 0;
    var systemId = 1;
    var componentId = 0;
    var messageId = 33; // GLOBAL_POSITION_INT
    var interval = 1000000;

    var dialect = MavlinkDialectCommon();

    test('Request Message', () {
      var parser = MavlinkParser(dialect);
      parser.stream.listen((MavlinkFrame frm) {
        if (frm.message is CommandLong) {
          var cl = frm.message as CommandLong;
          expect(cl.command, equals(512));
          expect(cl.param1, equals(33));
        }
      });

      parser.parse(requestMessage(sequence, systemId, componentId, messageId)
          .serialize());
    });

    test('Set Message Interval', () {
      var parser = MavlinkParser(dialect);
      parser.stream.listen((MavlinkFrame frm) {
        if (frm.message is CommandLong) {
          var cl = frm.message as CommandLong;
          expect(cl.command, equals(511));
          expect(cl.param2, equals(1000000));
          expect(cl.param1, equals(33));
        }
      });

      parser.parse(setMessageInterval(
              sequence, systemId, componentId, messageId, interval)
          .serialize());
    });
  });
}
