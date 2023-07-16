import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class SerialComms {
  final SerialPortReader _reader;
  StreamController<Uint8List> _dataStreamController = StreamController<Uint8List>();
  Stream<Uint8List> get onData => _dataStreamController.stream;

  SerialComms(SerialPort port, {int? timeout}) : _reader = SerialPortReader(port, timeout: timeout) {
    _reader.stream.listen((Uint8List data) {
      print("data:" + data.toString());
      _dataStreamController.add(data);
    }, onError: (error) {
      // Handle errors if needed
    }, onDone: () {
      _dataStreamController.close();
    });
  }

  void listen() {
    // Start listening for data (if not already started by the constructor)
    print("listening");
    onData.listen((Uint8List data) {
      print('Received data: ${data}');
    });
  }
  
  void close() {
    _reader.close();
  }
}
