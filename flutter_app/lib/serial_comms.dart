import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';


class SerialComms {
  final SerialPortReader _reader;
  StreamController<Uint8List> _dataStreamController = StreamController<Uint8List>();
  Stream<Uint8List> get onData => _dataStreamController.stream;

  SerialComms(SerialPort port, {int? timeout}) : _reader = SerialPortReader(port, timeout: timeout) {
    _reader.stream.listen((Uint8List data) {
      _dataStreamController.add(data);
    }, onError: (error) {
      // Handle errors if needed
    }, onDone: () {
      _dataStreamController.close();
    });
  }

  void listen() {
    // Start listening for data (if not already started by the constructor)
  }
  
  void close() {
    _reader.close();
  }
}
