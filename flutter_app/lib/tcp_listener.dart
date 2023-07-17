import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

// Dart mavlink library
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

class TCP_Listener{

  String address = "127.0.0.1";
  int port = 14550;
  var dialect;
  var parser;
  
  TCP_Listener(){
    dialect = MavlinkDialectCommon();
    parser = MavlinkParser(dialect);

  }

  void begin(){
    Socket.connect(address, port).then((Socket socket){

    socket.listen(
    // handle data from the server
    (Uint8List data) {
      parser.parse(data);
    },

    // handle error
    onError: (error) {
      socket.destroy();
    },

    // ending connection
    onDone: () {
      socket.destroy();
    });
    });
  }

  void listen(){
    parser.stream.listen((MavlinkFrame frm) {
    // TODO: Pass in a list of message we want
    if (frm.message is Attitude) {
      var attitude = frm.message as Attitude;
      print('Yaw: ${attitude.yaw / 3.14 * 180} [deg]');
    }
  });
  }

}