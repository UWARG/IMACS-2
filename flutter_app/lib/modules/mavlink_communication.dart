import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

enum MavlinkCommunicationType {
  tcp,
  serial,
}

class MavlinkCommunication {
  int sequence = 0; // sequence of current message

  final List<MissionItem> waypointQueue = [];

  final MavlinkCommunicationType _connectionType;

  late Stream<Uint8List> _stream;
  late SerialPort _serialPort;

  late Socket _tcpSocket;
  final Completer<void> _tcpSocketInitializationFlag = Completer<void>();

  MavlinkCommunication(MavlinkCommunicationType connectionType,
      String connectionAddress, int tcpPort)
      : _connectionType = connectionType {
    switch (_connectionType) {
      case MavlinkCommunicationType.tcp:
        _startupTcpPort(connectionAddress, tcpPort);
        break;
      case MavlinkCommunicationType.serial:
        _startupSerialPort(connectionAddress);
        break;
    }
  }

  _startupTcpPort(String connectionAddress, int tcpPort) async {
    // Connect to the socket
    _tcpSocket = await Socket.connect(connectionAddress, tcpPort);
    _tcpSocket.listen((Uint8List data) {}, onError: (error) {
      // print if log does not work, I can't really test it, just avoid the warning
      print(error);
      _tcpSocket.destroy();
    });

    _tcpSocketInitializationFlag.complete();
  }

  _startupSerialPort(String connectionAddress) {
    _serialPort = SerialPort(connectionAddress);
    _serialPort.openReadWrite();
    SerialPortReader serialPortReader = SerialPortReader(_serialPort);
    _stream = serialPortReader.stream;
    _stream.listen((Uint8List data) {});
  }

  _writeToTcpPort(MavlinkFrame frame) {
    _tcpSocket.write(frame.serialize());
  }

  _writeToSerialPort(MavlinkFrame frame) {
    _serialPort.write(frame.serialize());
  }

  // Send MAVLink messages
  // Refer to the link below to see how MAVLink frames are sent
  // https://github.com/nus/dart_mavlink/blob/main/example/parameter.dart
  void write(MavlinkFrame frame) {
    switch (_connectionType) {
      case MavlinkCommunicationType.tcp:
        _writeToTcpPort(frame);
        break;
      case MavlinkCommunicationType.serial:
        _writeToSerialPort(frame);
        break;
    }
  }

  MavlinkCommunicationType get connectionType => _connectionType;
  Completer<void> get tcpSocketInitializationFlag =>
      _tcpSocketInitializationFlag;
  Stream<Uint8List> get stream =>
      _connectionType == MavlinkCommunicationType.tcp
          ? _tcpSocket.asBroadcastStream()
          : _stream;
}
