import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

// ignore_for_file: avoid_print

void main() async {

  var dialect = MavlinkDialectCommon();
  var parser = MavlinkParser(dialect);

  // replace this with whatever for other messages
  parser.stream.listen((MavlinkFrame frm) {
    if (frm.message is Attitude) {
      var attitude = frm.message as Attitude;
      print('Yaw: ${attitude.yaw / 3.14 * 180} [deg]');
    }
  });

  Socket.connect("127.0.0.1", 14550).then((Socket socket){
    print("Mission planner connected");

    socket.listen(
    // handle data from the server
    (Uint8List data) {
      parser.parse(data);
    },

    // handle error
    onError: (error) {
      print(error);
      socket.destroy();
    },

    // ending connection
    onDone: () {
      print('Mission planner disconnected');
      socket.destroy();
    });

  });

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