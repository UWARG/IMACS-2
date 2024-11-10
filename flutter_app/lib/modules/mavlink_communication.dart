import 'dart:typed_data';
import 'dart:io';
import 'dart:developer';
import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

const String moduleName = "Mavlink Communication";

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
        log('[$moduleName] Trying to start TCP connection');
        //_startupTcpPort(connectionAddress, tcpPort);
        break;
      case MavlinkCommunicationType.serial:
        log('[$moduleName] Trying to start Serial connection');
        _startupSerialPort(connectionAddress);
        break;
    }
  }

  _startupTcpPort(String connectionAddress, int tcpPort) async {
    // Connect to the socket
    _tcpSocket = await Socket.connect(connectionAddress, tcpPort);
    _tcpSocketInitializationFlag.complete();
    log('[$moduleName] TCP Port successfully initialized!');
  }

  _startupSerialPort(String connectionAddress) {
    _serialPort = SerialPort(connectionAddress);
    _serialPort.openReadWrite();
    SerialPortReader serialPortReader = SerialPortReader(_serialPort);
    _stream = serialPortReader.stream;
  }

  _writeToTcpPort(MavlinkFrame frame) {
    _tcpSocket.write(frame.serialize());
    log('[$moduleName] Wrote a message to TCP Port. Frame ID: ${frame.componentId}');
    log('[$moduleName] Message: ${frame.message}');
  }

  _writeToSerialPort(MavlinkFrame frame) {
    _serialPort.write(frame.serialize());
    log('[$moduleName] Wrote a message to Serial Port. Frame ID: ${frame.componentId}');
    log('[$moduleName] Message: ${frame.message}');
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
  Socket get tcpSocket => _tcpSocket;
  SerialPort get serialPort => _serialPort;
  Stream<Uint8List> get stream => _stream;
}
