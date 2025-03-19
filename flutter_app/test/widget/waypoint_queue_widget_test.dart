// queue_waypoints_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/modules/queue_waypoints.dart';
import 'package:imacs/widgets/waypoint_queue_widget.dart';

// This is a temp comm just to make the queuewaypoints happy (does not do anything)
class FakeMavlinkCommunication extends MavlinkCommunication {
  FakeMavlinkCommunication()
      : super(MavlinkCommunicationType.tcp, '127.0.0.1', 14550);

  @override
  void write(dynamic frame) {}
}

void main() {
  group('QueueWaypointsWidget', () {
    // Sets up the testing environment
    testWidgets('Widget expands and displays expected text',
        (WidgetTester tester) async {
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);
      final QueueWaypoints command = QueueWaypoints(comm: mavlinkCommunication);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QueueWaypointsWidget(queueWaypoints: command),
          ),
        ),
      );

      // Checks if all the sized boxes and buttons render properly (If the text renders that means the sized box renders)
      expect(find.text('Queued Waypoints'), findsOneWidget);
      expect(find.text('Add new waypoint: '), findsOneWidget);
      expect(find.text('Latitude'), findsOneWidget);
      expect(find.text('Longitude'), findsOneWidget);
      expect(find.text('Altitude'), findsOneWidget);
      expect(find.text('Add Waypoint'), findsOneWidget);
      expect(find.text('Send Next Waypoint'), findsOneWidget);
    });

    // Setting up environment for testing
    testWidgets('Buttons can be tapped without error',
        (WidgetTester tester) async {
      // Arrange
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);
      final QueueWaypoints command = QueueWaypoints(comm: mavlinkCommunication);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QueueWaypointsWidget(queueWaypoints: command),
          ),
        ),
      );

      // Looks for the buttons and makes sure they can be clicked
      final addButton = find.byType(ElevatedButton).at(0);
      final sendNextButton = find.byType(ElevatedButton).at(1);

      await tester.tap(addButton);
      await tester.pump();

      await tester.tap(sendNextButton);
      await tester.pump();

      expect(find.byType(QueueWaypointsWidget), findsOneWidget);
    });

    // These can be used for a future integration test, they test if the sent waypoint properly shows up on the list view
    /*
    testWidgets('adds waypoint and updates list', (WidgetTester tester) async {
      final fakeComm = FakeMavlinkCommunication();
      final queueWaypoints = QueueWaypoints(comm: fakeComm);

      await tester.pumpWidget(MaterialApp(
        home: QueueWaypointsWidget(queueWaypoints: queueWaypoints),
      ));

      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Latitude'),
          '12.34');

      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Longitude'),
          '56.78');

      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'Altitude'),
          '100');

      await tester.tap(find.text('Add Waypoint'));
      await tester.pump();

      expect(find.textContaining('Waypoint 0:'), findsOneWidget);
      expect(find.textContaining('Lat=100.0'), findsOneWidget);
      expect(find.textContaining('Lon=56.78'), findsOneWidget);
      expect(find.textContaining('Alt=100.0'), findsOneWidget);
    });

    testWidgets('send next waypoint removes from queue',
        (WidgetTester tester) async {
      final fakeComm = FakeMavlinkCommunication();
      final queueWaypoints = QueueWaypoints(comm: fakeComm);

      queueWaypoints.queueWaypoint(1, 1, 10.0, 20.0, 30.0);
      queueWaypoints.queueWaypoint(1, 1, 40.0, 50.0, 60.0);

      await tester.pumpWidget(MaterialApp(
        home: QueueWaypointsWidget(queueWaypoints: queueWaypoints),
      ));

      expect(find.textContaining('Waypoint 0:'), findsOneWidget);
      expect(find.textContaining('Waypoint 1:'), findsOneWidget);

      await tester.tap(find.text('Send Next Waypoiint'));
      await tester.pump();

      expect(find.textContaining('Waypoint 0:'), findsNothing);
      expect(find.textContaining('Waypoint 1:'), findsOneWidget);
    });
    */
  });
}
