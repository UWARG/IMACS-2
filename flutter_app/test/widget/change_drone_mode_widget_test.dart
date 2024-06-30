import 'package:dart_mavlink/dialects/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/modules/change_drone_mode.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/widgets/change_mode_widget.dart';

void main() {
  group('Control Drone Mode Widget', () {
    testWidgets('ControlDroneModeWidget displays a dropdown menu and a button',
        (WidgetTester tester) async {
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DroneModeChanger(
            changeDroneMode: ChangeDroneMode(comm: mavlinkCommunication),
            systemId: 0,
            componentId: 0,
          ),
        ),
      ));

      expect(find.byType(DropdownMenu<MavMode>), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('DroneModeChanger sends mode change on button press',
        (WidgetTester tester) async {
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DroneModeChanger(
            changeDroneMode: ChangeDroneMode(comm: mavlinkCommunication),
            systemId: 0,
            componentId: 0,
          ),
        ),
      ));

      // Open the dropdown menu and select a mode
      await tester.tap(find.byType(DropdownMenu<MavMode>));
      await tester.pumpAndSettle();
      final manualArmedFinder = find.descendant(
        of: find.byType(DropdownMenu<MavMode>),
        matching: find.text('Manual Armed'),
      );
      await tester.tap(manualArmedFinder.last);
      await tester.pumpAndSettle();

      // Press the change mode button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Current Mode: Manual Armed'), findsOneWidget);
    });
  });
}
