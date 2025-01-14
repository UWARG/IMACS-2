import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/modules/return_to_launch.dart';
import 'package:imacs/widgets/return_to_launch_widget.dart';

void main() {
  group("Return to Launch Widget", () {
    testWidgets("Return to Launch Button Generate",
        (WidgetTester tester) async {
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);
      final ReturnToLaunch command = ReturnToLaunch(comm: mavlinkCommunication);

      // Tests to see if the button renders
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ReturnToLaunchButton(
                  returnToLaunchCommand: command,
                  systemID: 1,
                  componentID: 0))));

      // Waits for all frames and animations to settle
      await tester.pumpAndSettle();
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text("Return to Launch"), findsOneWidget);
    });

    testWidgets("Button sends MavLink command", (WidgetTester tester) async {
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);
      final ReturnToLaunch command = ReturnToLaunch(comm: mavlinkCommunication);

      // Tests to see if the button renders
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ReturnToLaunchButton(
                  returnToLaunchCommand: command,
                  systemID: 1,
                  componentID: 0,
                  key: UniqueKey()))));

      await tester.pumpAndSettle();
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify the SnackBar appears then disappears
      expect(find.text('Send Mavlink RTL command'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Send Mavlink RTL command'), findsNothing);
    });
  });
}
