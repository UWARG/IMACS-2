import 'package:flutter/material.dart';
import 'package:imacs/modules/queue_waypoints.dart'

/// Widget to queue waypoints of a drone using MAVLink communication.
/// 
/// [DESCRIPTION]
class WaypointQueue extends StatefulWidget {
  /// @brief Constructs a WaypointQueue widget.
  /// 
  /// @param queueWaypoints
  /// QueueWaypoints class instance
  /// 
  /// @param systemId
  /// system ID for command constructor
  /// 
  /// @param componentId
  /// component ID for command constructor
  /// 
  final QueueWaypoints queueWaypoints;
  final int systemId;
  final int componentId;

  const WaypointQueue({
    Key? key,
    required this.systemId,
    required this.componentId,
    required this.queueWaypoints,
  }) : super(key: key);

  @override
  WaypointQueueState createState() => WaypointQueueState();
}

/// State for the QueueWaypoints widget.
class WaypointQueueState extends State<WaypointQueue> {
  late double _latitude;
  late double _longitude;
  late double _altitude;
  
  /// Sends a command to queue a waypoint.
  void _queueWaypoint() {
    widget.queueWaypoints.queueWaypoint(
      widget.systemId,
      widget.componentId,
      _latitude,
      _longitude,
      _altitude
    );
  }

  /// Sends a command to send a waypoint, bypassing the queue.
  void _queueWaypointWithoutQueue() {
    widget.queueWaypoints.sendWaypointWithoutQueue(
      widget.systemId,
      widget.componentId,
      _latitude,
      _longitude,
      _altitude
    );
  }

  void _sendNextWaypointInQueue() {
    /// remove first row of queue
    /// update row numbers
  }
  
  @override
  Widget build(BuildContext context) {
    /// could map a list to a table, table updates to the list
    return Column(children: [
      
      ElevatedButton(
        onPressed: _queueWaypoint, 
        child: const Text('Add Waypoint to Queue')
      ),
      ElevatedButton(
        onPressed: _queueWaypointWithoutQueue, 
        child: const Text('Send Waypoint Immediately')
      ),
    ],);
  }
}