import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/modules/get_drone_information.dart';
import 'package:imacs/widgets/data_field_widget.dart';
import 'package:imacs/widgets/drone_information_widget.dart';
import 'package:imacs/modules/mavlink_communication.dart';

void main() {
  group(
    'Drone Information widget',
    () {
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
                  getDroneInformation: GetDroneInformation(comm: comm),
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
}
