import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() {
  runApp(MyApp());

  // ignore_for_file: avoid_print

  print(SerialPort.availablePorts); // uncomment to see available ports or use shell command
  SerialPort serialPort = SerialPort("/dev/cu.usbserial-210"); // ls /dev/{tty,cu}. on mac
  serialPort.openRead();
  while (true) {
    print(serialPort.read(4, timeout: 1000 ));
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