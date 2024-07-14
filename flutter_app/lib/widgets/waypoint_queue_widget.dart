import 'package:flutter/material.dart';
import 'package:imacs/modules/queue_waypoints.dart';

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
  final GlobalKey _widgetKey = GlobalKey(); // GlobalKey for the widget
  final TextEditingController _latitudeInput = TextEditingController();
  final TextEditingController _longitudeInput = TextEditingController();
  final TextEditingController _altitudeInput = TextEditingController();

  late double _latitude;
  late double _longitude;
  late double _altitude;
  
  /// Gets the waypoints from the TextFields
  void _getWaypointsFromInput() {
    try {
      _latitude = double.parse(_latitudeInput.text);
      _longitude = double.parse(_longitudeInput.text);
      _altitude = double.parse(_altitudeInput.text);
    } catch (e) {
      print('Enter valid numbers.');
    }
  }
  /// Sends a command to queue a waypoint.
  void _queueWaypoint() {
    _getWaypointsFromInput();
    widget.queueWaypoints.queueWaypoint(
      widget.systemId,
      widget.componentId,
      _latitude,
      _longitude,
      _altitude
    );
    setState(() {
      _widgetKey.currentState?.reassemble();
    });
  }

  /// Sends a command to send a waypoint, bypassing the queue.
  void _queueWaypointWithoutQueue() {
    _getWaypointsFromInput();
    widget.queueWaypoints.sendWaypointWithoutQueue(
      widget.systemId,
      widget.componentId,
      _latitude,
      _longitude,
      _altitude
    );
  }

  void _sendNextWaypointInQueue() {
    /// send waypoint
    /// update row numbers
  }
  
  @override
  Widget build(BuildContext context) {
    /// could map a list to a table, table updates to the list
    return Column(
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Latitude')),
            DataColumn(label: Text('Longitude')),
            DataColumn(label: Text('Altitude')),
          ],
          rows: widget.queueWaypoints.waypointQueue.map(
            ((element) => DataRow(
            cells: <DataCell>[
              DataCell(Text(element.x.toString())),
              DataCell(Text(element.y.toString())),
              DataCell(Text(element.z.toString())),
            ],
          )),
        ).toList(),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(controller: _latitudeInput),
             ),
            Expanded(
              child: TextField(controller: _longitudeInput),
            ),  
            Expanded(
              child: TextField(controller: _altitudeInput),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _queueWaypoint, 
          child: const Text('Add Waypoint to Queue')
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _queueWaypointWithoutQueue, 
          child: const Text('Send Waypoint Immediately')
        ),
      ],
    );
  }
}