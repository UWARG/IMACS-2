import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/modules/change_port_protocol.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/widgets/change_port_protocol_widget.dart';

void main() {
  group('Change Port/Protocol Widget', () {
    testWidgets(
        'PortProtocolChanger displays a dropdown menu, a button, and two input fields',
        (WidgetTester tester) async {
      MavlinkCommunication comm = MavlinkCommunication(MavlinkCommunicationType.tcp, '127.0.0.1', 14550);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PortProtocolChanger(
            comm: comm,
            changePortProtocol: ChangePortProtocol(comm: comm),
          ),
        ),
      ));

      expect(
          find.byType(DropdownMenu<MavlinkCommunicationType>), findsOneWidget);
      // Look for 3 TextFields because DropdownMenu also contains a TextField
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('PortProtocolChanger changes communication params',
        (WidgetTester tester) async {
      final comm = MavlinkCommunication(
          MavlinkCommunicationType.tcp, '127.0.0.1', 14550);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PortProtocolChanger(
            comm: comm,
            changePortProtocol: ChangePortProtocol(comm: comm),
          ),
        ),
      ));

      // Open the dropdown menu and select a mode
      await tester.tap(find.byType(DropdownMenu<MavlinkCommunicationType>));
      await tester.pumpAndSettle();
      final serialFinder = find.descendant(
        of: find.byType(DropdownMenu<MavlinkCommunicationType>),
        matching: find.text('serial'),
      );
      await tester.tap(serialFinder.first);
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(TextField);
      await tester.enterText(textFieldFinder.at(1), "127.0.1.0");
      await tester.enterText(textFieldFinder.at(2), "14551");

      // Press the change port/protocol button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Successfully changed'), findsOneWidget);
    });
  });
}
