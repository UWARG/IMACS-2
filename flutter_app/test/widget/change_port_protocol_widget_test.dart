import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/modules/mavlink_communication.dart';
import 'package:imacs/widgets/change_port_protocol_widget.dart';

void main() {
  group('Change Port/Protocol Widget', () {
    testWidgets(
        'PortProtocolChanger displays a dropdown menu, a button, and two input fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PortProtocolChanger(
            communicationAddress: '127.0.0.1',
            communicationType: MavlinkCommunicationType.tcp,
            tcpPort: 14550,
            updateCommunicationParams:
                (MavlinkCommunicationType communicationType,
                    String communicationAddress, int tcpPort) {},
          ),
        ),
      ));

      expect(
          find.byType(DropdownMenu<MavlinkCommunicationType>), findsOneWidget);
      // Look for 3 TextFields because DropdownMenu also contains a TextField
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
