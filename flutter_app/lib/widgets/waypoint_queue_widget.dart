import 'package:flutter/material.dart';
import 'package:imacs/modules/queue_waypoints.dart';

/// Widget to queue waypoints of a drone using MAVLink communication.
///
/// This widget displays a table that contains a queue of waypoints to be
/// sent to the drone. It provides functionality to add a waypoint to the
/// queue as well as bypass the queue and send a waypoint to the drone
/// immediately.
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
      _altitude,
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
      _altitude,
    );
  }

  /// Sends the first waypoint in the queue to the drone.
  void _sendNextWaypointInQueue() {
    widget.queueWaypoints.sendNextWaypointInQueue();
    setState(() {
      _widgetKey.currentState?.reassemble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          'Waypoint Queue',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DataTable(
          columns: const [
            DataColumn(label: Text('Latitude')),
            DataColumn(label: Text('Longitude')),
            DataColumn(label: Text('Altitude')),
          ],
          rows: widget.queueWaypoints.waypointQueue
              .map(
                ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(element.x.toString())),
                        DataCell(Text(element.y.toString())),
                        DataCell(Text(element.z.toString())),
                      ],
                    )),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
            onPressed: _sendNextWaypointInQueue,
            child: const Text('Send Next Waypoint in Queue to Drone')),
        const SizedBox(height: 16),
        const Text(
          'Enter a Waypoint Below',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                height: 40,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Latitude',
                  ),
                  controller: _latitudeInput,
                ),
              ),
              SizedBox(
                width: 120,
                height: 40,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Longitude',
                  ),
                  controller: _longitudeInput,
                ),
              ),
              SizedBox(
                width: 120,
                height: 40,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Altitude',
                  ),
                  controller: _altitudeInput,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OverflowBar(spacing: 10, children: [
          ElevatedButton(
            onPressed: _queueWaypoint,
            child: const Text('Add Waypoint to Queue'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _queueWaypointWithoutQueue,
            child: const Text('Send Waypoint Immediately'),
          ),
        ]),
      ],
    );
  }
}
