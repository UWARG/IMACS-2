import 'package:dart_mavlink/mavlink.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/command_constructors/create_waypoint_constructor.dart';
import 'package:dart_mavlink/dialects/common.dart';

class QueueWaypoints {
  final MavlinkCommunication comm;

  QueueWaypoints({required this.comm});

  final List<MissionItem> waypointQueue = [];

// Adds a waypoint
  void sendWaypointWithoutQueue(int systemID, int componentID, double latitude,
      double longitude, double altitude) async {
    if (comm.connectionType == MavlinkCommunicationType.tcp) {
      await comm.tcpSocketInitializationFlag.future;
    }

    var newWaypoint = createWaypoint(
        comm.sequence, systemID, componentID, latitude, longitude, altitude);
    var frame = MavlinkFrame.v2(newWaypoint.seq, newWaypoint.targetSystem,
        newWaypoint.targetComponent, newWaypoint);
    comm.sequence++;
    comm.write(frame);
  }

  /// Queues a waypoint to be sent.
  /// @waypointFrame The MAVLink frame representing the waypoint command.
  void queueWaypoint(int systemID, int componentID, double latitude,
      double longitude, double altitude) {
    var newWaypoint = createWaypoint(
        comm.sequence, systemID, componentID, latitude, longitude, altitude);
    comm.sequence++;
    waypointQueue.add(newWaypoint);
  }

  /// Takes first waypoint in the queue and send its to the drone
  void sendNextWaypointInQueue() async {
    if (comm.connectionType == MavlinkCommunicationType.tcp) {
      await comm.tcpSocketInitializationFlag.future;
    }

    if (waypointQueue.isNotEmpty) {
      var waypoint = waypointQueue.removeAt(0);
      var frame = MavlinkFrame.v2(waypoint.seq, waypoint.targetSystem,
          waypoint.targetComponent, waypoint);
      comm.write(frame);
    }
  }
}
