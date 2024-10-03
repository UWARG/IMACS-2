import 'package:dart_mavlink/dialects/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/modules/return_to_launch.dart';
import 'package:imacs/command_constructors/return_to_launch_constructor.dart';
import 'package:imacs/widgets/return_to_launch_widget.dart';

void main() {
  group("Return to Launch Widget", () {
    testWidgets("Return to Launch Button Generate",
        (WidgetTester tester) async {
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);
      final ReturnToLaunch command = ReturnToLaunch(
          comm: mavlinkCommunication,
          returnToLaunchConstructor: returnToLaunch(0, 1, 0));

      // Tests to see if the button renders
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ReturnToLaunchButton(returnToLaunchCommand: command))));

      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
