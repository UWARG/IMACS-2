import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';
import 'package:imacs/command_constructors/create_waypoint_constructor.dart';
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

  test('Create Waypoint', () {
    const createWaypointCommandNumber = mavCmdNavWaypoint;
    const latitude = 47.938;
    const longitude = 8.545;
    const altitude = 10.0;

    var parser = MavlinkParser(dialect);
    parser.stream.listen((MavlinkFrame frm) {
      if (frm.message is MissionItem) {
        var mi = frm.message as MissionItem;
        expect(mi.command, equals(createWaypointCommandNumber));
        expect(mi.x, equals(latitude));
        expect(mi.y, equals(longitude));
        expect(mi.z, equals(altitude));
      }
    });

    var waypointCommand = createWaypoint(sequence, systemID, componentID, latitude, longitude, altitude);

    parser.parse(waypointCommand.serialize().buffer.asUint8List());
  });
}
