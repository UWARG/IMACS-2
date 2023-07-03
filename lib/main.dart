import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';


// ignore_for_file: avoid_print

void main() {
  print("running");
  runApp(MyApp());  

  print(SerialPort.availablePorts); // uncomment to see available ports or use shell command
  SerialPort serialPort = SerialPort("/dev/cu.usbserial-10"); // ls /dev/{tty,cu}. on mac
  serialPort.openRead();

  var dialect = MavlinkDialectCommon();
  var parser = MavlinkParser(dialect);

  var sequence = 0;
  var systemId = 255;
  var componentId = 1;

  while (true) {
    Uint8List readVal = serialPort.read(4, timeout: 1000 );
    print("readVal: ");
    print(readVal);
    parser.parse(readVal);

      var paramRequestList = ParamRequestList(
        targetSystem: 1,
        targetComponent: 1,
      );
      var frm = MavlinkFrame.v1(sequence, systemId, componentId, paramRequestList);

      print("frm:");
      print(frm);

      print("frm.message");
      print(frm.message);

      print("frm.componentId");
      print(frm.componentId);
  }
}

class MyApp extends StatelessWidget {
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