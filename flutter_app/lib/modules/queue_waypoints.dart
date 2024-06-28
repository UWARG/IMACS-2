import 'package:dart_mavlink/mavlink.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/command_constructors/create_waypoint_constructor.dart';


extension QueueWaypoints on MavlinkCommunication {
  void sendWaypointWithoutQueue(int systemID, int componentID, double latitude,
      double longitude, double altitude) async {
    if (connectionType == MavlinkCommunicationType.tcp) {
      await tcpSocketInitializationFlag.future;
    }

    var newWaypoint = createWaypoint(
        sequence, systemID, componentID, latitude, longitude, altitude);
    var frame = MavlinkFrame.v2(newWaypoint.seq, newWaypoint.targetSystem,
        newWaypoint.targetComponent, newWaypoint);
    sequence++;
    write(frame);
  }

  void queueWaypoint(int systemID, int componentID, double latitude,
      double longitude, double altitude) {
    var newWaypoint = createWaypoint(
        sequence, systemID, componentID, latitude, longitude, altitude);
    sequence++;
    waypointQueue.add(newWaypoint);
  }

  void sendNextWaypointInQueue() async {
    if (connectionType == MavlinkCommunicationType.tcp) {
      await tcpSocketInitializationFlag.future;
    }

    if (waypointQueue.isNotEmpty) {
      var waypoint = waypointQueue.removeAt(0);
      var frame = MavlinkFrame.v2(waypoint.seq, waypoint.targetSystem,
          waypoint.targetComponent, waypoint);
      write(frame);
    }
  }
}
