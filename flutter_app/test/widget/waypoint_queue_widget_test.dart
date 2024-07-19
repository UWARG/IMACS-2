import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/modules/queue_waypoints.dart';
import 'package:imacs/widgets/waypoint_queue_widget.dart';

void main() {
  group('WaypointQueue widget', () {
    testWidgets(
        'WaypointQueueWidget displays a table, text input fields, and 3 buttons',
        (WidgetTester tester) async {
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);
      final queueWaypoints = QueueWaypoints(comm: mavlinkCommunication);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: WaypointQueue(
            queueWaypoints: queueWaypoints,
            systemId: 0,
            componentId: 0,
          ),
        ),
      ));

      expect(find.byType(ElevatedButton), findsNWidgets(3));
      expect(find.byType(DataTable), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3));
    });
    testWidgets(
        'WaypointQueue sends a waypoint to the drone without queueing it',
        (WidgetTester tester) async {
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);
      final queueWaypoints = QueueWaypoints(comm: mavlinkCommunication);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: WaypointQueue(
            queueWaypoints: queueWaypoints,
            systemId: 0,
            componentId: 0,
          ),
        ),
      ));

      /// Enter a waypoint in the text fields
      await tester.enterText(
          find.ancestor(
            of: find.text('Latitude'),
            matching: find.byType(TextField),
          ),
          '10.01');
      await tester.enterText(
          find.ancestor(
            of: find.text('Longitude'),
            matching: find.byType(TextField),
          ),
          '-20.02');
      await tester.enterText(
          find.ancestor(
            of: find.text('Altitude'),
            matching: find.byType(TextField),
          ),
          '30.03');

      expect(find.text('10.01'), findsOneWidget);
      expect(find.text('-20.02'), findsOneWidget);
      expect(find.text('30.03'), findsOneWidget);

      await tester.tap(
          find.widgetWithText(ElevatedButton, 'Send Waypoint Immediately'));
      await tester.pump();

      expect(queueWaypoints.waypointQueue.length, 0);
      expect(find.text('10.01'), findsOneWidget);
      expect(find.text('-20.02'), findsOneWidget);
      expect(find.text('30.03'), findsOneWidget);
    });

    testWidgets('WaypointQueue adds waypoint to queue on button press',
        (WidgetTester tester) async {
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);
      final queueWaypoints = QueueWaypoints(comm: mavlinkCommunication);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: WaypointQueue(
            queueWaypoints: queueWaypoints,
            systemId: 0,
            componentId: 0,
          ),
        ),
      ));

      /// Enter a waypoint in the text fields
      await tester.enterText(
          find.ancestor(
            of: find.text('Latitude'),
            matching: find.byType(TextField),
          ),
          '10.01');
      await tester.enterText(
          find.ancestor(
            of: find.text('Longitude'),
            matching: find.byType(TextField),
          ),
          '-20.02');
      await tester.enterText(
          find.ancestor(
            of: find.text('Altitude'),
            matching: find.byType(TextField),
          ),
          '30.03');

      expect(find.text('10.01'), findsOneWidget);
      expect(find.text('-20.02'), findsOneWidget);
      expect(find.text('30.03'), findsOneWidget);

      await tester
          .tap(find.widgetWithText(ElevatedButton, 'Add Waypoint to Queue'));
      await tester.pump();

      expect(find.text('10.01'), findsNWidgets(2));
      expect(find.text('-20.02'), findsNWidgets(2));
      expect(find.text('30.03'), findsNWidgets(2));
      expect(queueWaypoints.waypointQueue.length, 1);
      expect(queueWaypoints.waypointQueue[0].x, 10.01);
      expect(queueWaypoints.waypointQueue[0].y, -20.02);
      expect(queueWaypoints.waypointQueue[0].z, 30.03);
    });
    testWidgets('WaypointQueue sends first waypoint in queue to drone',
        (WidgetTester tester) async {
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);
      final queueWaypoints = QueueWaypoints(comm: mavlinkCommunication);

      queueWaypoints.queueWaypoint(0, 0, 10.01, -20.02, 30.03);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: WaypointQueue(
            queueWaypoints: queueWaypoints,
            systemId: 0,
            componentId: 0,
          ),
        ),
      ));

      expect(queueWaypoints.waypointQueue.length, 1);
      expect(find.text('10.01'), findsOneWidget);
      expect(find.text('-20.02'), findsOneWidget);
      expect(find.text('30.03'), findsOneWidget);
      expect(queueWaypoints.waypointQueue[0].x, 10.01);
      expect(queueWaypoints.waypointQueue[0].y, -20.02);
      expect(queueWaypoints.waypointQueue[0].z, 30.03);

      await tester.tap(find.widgetWithText(
          ElevatedButton, 'Send Next Waypoint in Queue to Drone'));
      await tester.pump(const Duration(milliseconds: 10000));

      expect(find.text('10.01'), findsNothing);
      expect(find.text('-20.02'), findsNothing);
      expect(find.text('30.03'), findsNothing);
      expect(queueWaypoints.waypointQueue.length, 0);
    });
  });
}
