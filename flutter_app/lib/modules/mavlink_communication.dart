import 'dart:typed_data';
import 'dart:io';
import 'dart:developer';
import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

enum MavlinkCommunicationType {
  tcp,
  serial,
}

class MavlinkCommunication {
  final MavlinkParser _parser;

  final StreamController<double> _yawStreamController =
      StreamController<double>();
  final StreamController<double> _pitchStreamController =
      StreamController<double>();
  final StreamController<double> _rollStreamController =
      StreamController<double>();
  final StreamController<double> _rollSpeedController =
      StreamController<double>();
  final StreamController<double> _pitchSpeedController =
      StreamController<double>();
  final StreamController<double> _yawSpeedController =
      StreamController<double>();
  final StreamController<int> _timeBootMsPitchController =
      StreamController<int>();

  final StreamController<int> _latStreamController = StreamController<int>();
  final StreamController<int> _lonStreamController = StreamController<int>();
  final StreamController<int> _altStreamController = StreamController<int>();

  int sequence = 0; // sequence of current message

  final List<MissionItem> waypointQueue = [];

  final MavlinkCommunicationType _connectionType;

  late Stream<Uint8List> _stream;
  late SerialPort _serialPort;

  late Socket _tcpSocket;
  final Completer<void> _tcpSocketInitializationFlag = Completer<void>();

  MavlinkCommunication(MavlinkCommunicationType connectionType,
      String connectionAddress, int tcpPort)
      : _parser = MavlinkParser(MavlinkDialectCommon()),
        _connectionType = connectionType {
    switch (_connectionType) {
      case MavlinkCommunicationType.tcp:
        // Trying to start TCP connection
        _startupTcpPort(connectionAddress, tcpPort);
        break;
      case MavlinkCommunicationType.serial:
        // Trying to start Serial connection
        _startupSerialPort(connectionAddress);
        break;
    }

    _parseMavlinkMessage();
  }

  _startupTcpPort(String connectionAddress, int tcpPort) async {
    // Connect to the socket
    _tcpSocket = await Socket.connect(connectionAddress, tcpPort);
    _tcpSocket.listen((Uint8List data) {
      _parser.parse(data);
    }, onError: (error) {
      log('ERROR: $error');
      _tcpSocket.destroy();
    });

    _tcpSocketInitializationFlag.complete();
    log('TCP Port successfully initialized!');
  }

  _startupSerialPort(String connectionAddress) {
    _serialPort = SerialPort(connectionAddress);
    _serialPort.openReadWrite();
    SerialPortReader serialPortReader = SerialPortReader(_serialPort);
    _stream = serialPortReader.stream;
    _stream.listen((Uint8List data) {
      _parser.parse(data);
    }, onError: (error) {
      log('ERROR: $error');
      _serialPort.dispose();
    });

    log('Serial Port successfully initialized!');
  }

  _writeToTcpPort(MavlinkFrame frame) {
    _tcpSocket.write(frame.serialize());
    log('Wrote a message to TCP Port. Frame ID: ${frame.componentId}');
    log('Message: ${frame.message}');
  }

  _writeToSerialPort(MavlinkFrame frame) {
    _serialPort.write(frame.serialize());
    log('Wrote a message to Serial Port. Frame ID: ${frame.componentId}');
    log('Message: ${frame.message}');
  }

  _parseMavlinkMessage() {
    _parser.stream.listen((MavlinkFrame frame) {
      if (frame.message is Attitude) {
        // Append data to appropriate stream
        var attitude = frame.message as Attitude;
        _yawStreamController.add(attitude.yaw);
        _pitchStreamController.add(attitude.pitch);
        _rollStreamController.add(attitude.roll);
        _rollSpeedController.add(attitude.rollspeed);
        _pitchSpeedController.add(attitude.pitchspeed);
        _yawSpeedController.add(attitude.yawspeed);
        _timeBootMsPitchController.add(attitude.timeBootMs);
      } else if (frame.message is GlobalPositionInt) {
        var globalPositionInt = frame.message as GlobalPositionInt;
        _latStreamController.add(globalPositionInt.lat);
        _lonStreamController.add(globalPositionInt.lon);
        _altStreamController.add(globalPositionInt.relativeAlt);
      }
    });
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
  StreamController<double> get yawStreamController => _yawStreamController;
  StreamController<double> get pitchStreamController => _pitchStreamController;
  StreamController<double> get rollStreamController => _rollStreamController;
  StreamController<double> get rollSpeedController => _rollSpeedController;
  StreamController<double> get pitchSpeedController => _pitchSpeedController;
  StreamController<double> get yawSpeedController => _yawSpeedController;
  StreamController<int> get timeBootMsPitchController =>
      _timeBootMsPitchController;
  StreamController<int> get latStreamController => _latStreamController;
  StreamController<int> get lonStreamController => _lonStreamController;
  StreamController<int> get altStreamController => _altStreamController;
}
