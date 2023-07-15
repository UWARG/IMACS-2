import 'package:flutter/material.dart';
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

// ignore_for_file: avoid_print

void main() {
  runApp(const MyApp());

  var dialect = MavlinkDialectCommon();
  var parser = MavlinkParser(dialect);

  parser.stream.listen((MavlinkFrame frm) {
    if (frm.message is CommandLong) {
      var cl = frm.message as CommandLong;

      if (cl.command == 512) {
        print("Received Request Message");
        print("Message id: ${cl.param1}");
      } else if (cl.command == 511) {
        print("Received Set Message Interval");
        print("Interval: ${cl.param2} μs");
        print("Message id: ${cl.param1}");
      }
    }
  });

  var sequence = 0;
  var systemId = 255;
  var componentId = 1;

  // example of requesting a single instance of a message using MAV_CMD_REQUEST_MESSAGE (512)
  var desiredMessage = 33; // GLOBAL_POSITION_INT
  var param2 =
      0; // parameter required for some messages, described in common message set
  var commandLong = CommandLong(
      targetSystem: 1,
      targetComponent: 0,
      command: 512,
      confirmation: 0,
      param1: desiredMessage.toDouble(),
      param2: param2.toDouble(),
      param3: 0,
      param4: 0,
      param5: 0,
      param6: 0,
      param7: 0);
  var frm = MavlinkFrame.v1(sequence, systemId, componentId, commandLong);
  parser.parse(frm.serialize());

  // example of requesting messages at a specified rate using MAV_CMD_SET_MESSAGE_INTERVAL (511)
  var interval = 1000000; // interval in μs
  commandLong = CommandLong(
      targetSystem: 1,
      targetComponent: 0,
      command: 511,
      confirmation: 0,
      param1: desiredMessage.toDouble(),
      param2: interval.toDouble(),
      param3: 0,
      param4: 0,
      param5: 0,
      param6: 0,
      param7: 0);
  frm = MavlinkFrame.v1(sequence, systemId, componentId, commandLong);
  parser.parse(frm.serialize());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WARG IMACS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
