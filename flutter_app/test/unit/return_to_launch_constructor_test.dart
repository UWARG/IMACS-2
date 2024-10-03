import 'package:dart_mavlink/dialects/common.dart';
import 'package:dart_mavlink/mavlink.dart';
import 'package:imacs/command_constructors/return_to_launch_constructor.dart';
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

  test("Return To Launch", () {
    const createReturnToLaunchCommandNumber = mavCmdNavReturnToLaunch;
    const latitude = 47.938;
    const longitude = 8.545;
    const altitude = 15.0;

    var parser = MavlinkParser(dialect);
    parser.stream.listen((MavlinkFrame frm) {
      if (frm.message is MissionItem) {
        var mi = frm.message as MissionItem;
        expect(mi.command, equals(createReturnToLaunchCommandNumber));
        expect(mi.x, equals(latitude));
        expect(mi.y, equals(longitude));
        expect(mi.z, equals(altitude));
      }
    });

    var returnToLaunchCommand = returnToLaunch(sequence, systemID, componentID,
        latitude: latitude, longitude: longitude, altitude: altitude);

    parser.parse(returnToLaunchCommand.serialize().buffer.asUint8List());
  });
}
