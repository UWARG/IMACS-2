import 'package:imacs/modules/mavlink_communication.dart';

final class Defaults {
  static const communicationType = MavlinkCommunicationType.tcp;
  static const communicationAddress = '127.0.0.1';
  static const tcpPort = 14550;
}