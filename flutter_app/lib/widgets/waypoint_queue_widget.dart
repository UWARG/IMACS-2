import 'package:flutter/material.dart';
import 'package:imacs/modules/queue_waypoints.dart';

class QueueWaypointsWidget extends StatefulWidget {
  final QueueWaypoints queueWaypoints;

  const QueueWaypointsWidget({Key? key, required this.queueWaypoints})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QueueWaypointsWidgetState createState() => _QueueWaypointsWidgetState();
}

// The Queuewaypoints widget
class _QueueWaypointsWidgetState extends State<QueueWaypointsWidget> {
  final TextEditingController _latitudeInput = TextEditingController();
  final TextEditingController _longitudeInput = TextEditingController();
  final TextEditingController _altitudeInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final waypointQueue = widget.queueWaypoints.waypointQueue;

    // Scroll View for the list of queued waypoints
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Queued Waypoints",
              style: Theme.of(context).textTheme.headlineMedium),

          // Sized Boxes for each waypoint in the list of queued waypoints
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: waypointQueue.length,
              itemBuilder: (context, index) {
                final item = waypointQueue[index];
                return ListTile(
                  title: Text(
                      'Waypoint ${item.seq}: Lat=${item.x}, Lon=${item.y}, Alt=${item.z}'),
                );
              },
            ),
          ),

          // Outside of the Scrollview
          // Sized box for each of the inputs (to add a new waypoint)
          const SizedBox(height: 16),
          const Text("Add new waypoint: "),
          TextField(
            controller: _latitudeInput,
            decoration: const InputDecoration(labelText: "Latitude"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _longitudeInput,
            decoration: const InputDecoration(labelText: "Longitude"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _altitudeInput,
            decoration: const InputDecoration(labelText: "Altitude"),
            keyboardType: TextInputType.number,
          ),

          // Two buttons used to add and send the newly added waypoint
          ElevatedButton(
            onPressed: _addWaypoint,
            child: const Text("Add Waypoint"),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: _sendNextWaypoint,
              child: const Text("Send Next Waypoint"))
        ],
      ),
    );
  }

  // Takes the inputs from the sized boxes above and adds it to the waypoint queue
  void _addWaypoint() {
    final lat = double.tryParse(_latitudeInput.text) ?? 0.0;
    final lon = double.tryParse(_longitudeInput.text) ?? 0.0;
    final alt = double.tryParse(_altitudeInput.text) ?? 0.0;

    widget.queueWaypoints.queueWaypoint(
      1, // System ID
      1, // Component ID
      lat,
      lon,
      alt,
    );

    _latitudeInput.clear();
    _longitudeInput.clear();
    _altitudeInput.clear();

    setState(() {});
  }

  // Sends the next waypoint in queue
  void _sendNextWaypoint() async {
    widget.queueWaypoints.sendNextWaypointInQueue();
    setState(() {});
  }
}
