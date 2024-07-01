import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';
import 'package:imacs/command_constructors/set_mode_constructor.dart';
import 'package:test/test.dart';

void main() {
  /// dialect: Selected MAVLink dialect
  /// sequence: The sequence number for the MAVLink frame.
  /// Each component counts up its send sequence.
  /// Allows to detect packet loss.
  /// systemId: The MAVLink system ID of the vehicle (normally "1").
  /// componentId: The MAVLink component ID (normally "0").
  var dialect = MavlinkDialectCommon();
  const sequence = 0;
  const systemID = 1;
  const componentID = 0;

  test('Change Mode', () {
    const changeModeCommandNumber = 176; // MAV_CMD Number for changing the mode
    const baseMode = mavModeGuidedArmed;

    var parser = MavlinkParser(dialect);
    parser.stream.listen((MavlinkFrame frm) {
      if (frm.message is CommandLong) {
        var cl = frm.message as CommandLong;
        expect(cl.command, equals(changeModeCommandNumber));
        expect(cl.param1, equals(baseMode));
      }
    });

    parser
        .parse(setMode(sequence, systemID, componentID, baseMode).serialize());
  });
}
