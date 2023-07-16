import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class SerialComms {
  final SerialPortReader _reader;
  final SerialPort _port;
  StreamController<Uint8List> _dataStreamController = StreamController<Uint8List>();
  Stream<Uint8List> get onData => _dataStreamController.stream;

  SerialComms(SerialPort port, {int? timeout}) 
      : _port = port,
        _reader = SerialPortReader(port, timeout: timeout) {
    port.openReadWrite();
    _reader.stream.listen((Uint8List data) {
      _dataStreamController.add(data);
    }, onError: (error) {
      // TODO
    }, onDone: () {
      _dataStreamController.close();
    });
  }

  void listen() {
    onData.listen((Uint8List data) {
      print('Received data: ${data}');
      Uint8List sendData = Uint8List.fromList('Hello'.codeUnits);
      write(sendData);
    });
  }
  
  void write(Uint8List data) {
    print("writing data");
    print(data);
    _port.write(data);
  }
  
  void close() {
    _reader.close();
  }
}
