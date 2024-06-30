// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:dart_mavlink/dialects/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/data_field_widget.dart';
import 'package:imacs/drone_information.dart';
import 'package:imacs/mavlink_communication.dart';
import 'package:imacs/change_mode_widget.dart';

void main() {
  group(
    'DataField widget',
    () {
      testWidgets(
        'DataField displays "No Data" when stream has no data',
        (WidgetTester tester) async {
          final StreamController<int> controller = StreamController<int>();

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DataField<int>(
                  name: 'Test Field',
                  value: controller.stream,
                  formatter: (int value) => (value / 1e7).round(),
                ),
              ),
            ),
          );

          expect(find.text('No data'), findsOneWidget);

          await controller.close();
        },
      );

      testWidgets(
        'DataField displays formatted data from a stream',
        (WidgetTester tester) async {
          const label = 'Test Field';
          final stream = Stream<int>.value(42);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DataField<int>(
                  name: label,
                  value: stream,
                  formatter: (int value) => value,
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.text('42'), findsOneWidget);
        },
      );

      /// Specifically tests DroneInformation widget, matches the value of Yaw, Pitch, Roll, Latitude
      /// Longitude, Altitude with the source of communication provided. If communication not available
      /// then looks for 'No Data'
      testWidgets(
        'Checking for all Data Headings',
        (WidgetTester tester) async {
          final comm = MavlinkCommunication(
            MavlinkCommunicationType.tcp,
            '127.0.0.1',
            14550,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DroneInformation(
                  comm: comm,
                ),
              ),
            ),
          );
          await tester.pump();

          expect(
            find.widgetWithText(
              DataField<double>,
              'Yaw (deg)',
            ),
            findsOneWidget,
          );
          expect(
            find.widgetWithText(
              DataField<double>,
              'Pitch (deg)',
            ),
            findsOneWidget,
          );

          expect(
            find.widgetWithText(
              DataField<double>,
              'Roll (deg)',
            ),
            findsOneWidget,
          );
          expect(
            find.widgetWithText(
              DataField<int>,
              'Latitude',
            ),
            findsOneWidget,
          );
          expect(
            find.widgetWithText(
              DataField<int>,
              'Longitude',
            ),
            findsOneWidget,
          );
          expect(
            find.widgetWithText(
              DataField<int>,
              'Altitude (m)',
            ),
            findsOneWidget,
          );
        },
      );
    },
  );

  group('Control Drone Mode Widget', () {
    testWidgets('ControlDroneModeWidget displays a dropdown menu and a button',
        (WidgetTester tester) async {
      final mavlinkCommunication = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DroneModeChanger(
            mavlinkCommunication: mavlinkCommunication,
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
            mavlinkCommunication: mavlinkCommunication,
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
