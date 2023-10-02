import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:dart_mavlink/mavlink.dart';
import 'package:dart_mavlink/dialects/common.dart';

class MavlinkCommunication {
  final MavlinkParser _parser;

  final StreamController<double> _yawStreamController = StreamController<double>();
  final StreamController<double> _pitchStreamController = StreamController<double>();
  final StreamController<double> _rollStreamController = StreamController<double>();
  final StreamController<double> _rollSpeedController = StreamController<double>();
  final StreamController<double> _pitchSpeedController = StreamController<double>();
  final StreamController<double> _yawSpeedController = StreamController<double>();
  final StreamController<int> _timeBootMsPitchController = StreamController<int>();

  final StreamController<int> _latStreamController = StreamController<int>();
  final StreamController<int> _lonStreamController = StreamController<int>();
  final StreamController<int> _altStreamController = StreamController<int>();

  final bool _shouldReadFromTCP;

  late Stream<Uint8List> _stream;
  late SerialPort _serialPort;

  late Socket _tcpSocket;

  MavlinkCommunication(bool shouldReadFromTCP, String connectionAddress, int tcpPort)
      : _parser = MavlinkParser(MavlinkDialectCommon()),
        _shouldReadFromTCP = shouldReadFromTCP {
    if (shouldReadFromTCP) {
      startupTcpPort(connectionAddress, tcpPort);
    } else {
      startupSerialPort(connectionAddress);
    }

    parseMavlinkMessage();
  }

  startupTcpPort(String connectionAddress, tcpPort) async {
    // Connect to the socket
    _tcpSocket = await Socket.connect(connectionAddress, tcpPort);
    _tcpSocket.listen(
      (Uint8List data) {
      _parser.parse(data);
      },
      onError: (error){
        // print if log does not work, I can't really test it, just avoid the warning
        log(error);
        _tcpSocket.destroy();
      }
    );
  }

  startupSerialPort(String connectionAddress) {
    _serialPort = SerialPort(connectionAddress);
    _serialPort.openReadWrite();
    SerialPortReader serialPortReader = SerialPortReader(_serialPort);
    _stream = serialPortReader.stream;
    _stream.listen((Uint8List data) {
      _parser.parse(data);
    });
  }

  writeToTcpPort(MavlinkFrame frame) {
    _tcpSocket.write(frame.serialize());
  }

  writeToSerialPort(MavlinkFrame frame) {
    _serialPort.write(frame.serialize());
  }

  parseMavlinkMessage() {
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

  Stream<double> getYawStream() {
    return _yawStreamController.stream;
  }

  Stream<double> getPitchStream() {
    return _pitchStreamController.stream;
  }

  Stream<double> getRollStream() {
    return _rollStreamController.stream;
  }

  Stream<double> getRollSpeedStream() {
    return _rollSpeedController.stream;
  }

  Stream<double> getPitchSpeedStream() {
    return _pitchSpeedController.stream;
  }

  Stream<double> getYawSpeedStream() {
    return _yawSpeedController.stream;
  }

  Stream<int> getTimeBootMsPitchStream() {
    return _timeBootMsPitchController.stream;
  }

  Stream<int> getLatStream() {
    return _latStreamController.stream;
  }

  Stream<int> getLonStream() {
    return _lonStreamController.stream;
  }

  Stream<int> getAltStream() {
    return _altStreamController.stream;
  }

  // Send MAVLink messages
  // Refer to the link below to see how MAVLink frames are sent
  // https://github.com/nus/dart_mavlink/blob/main/example/parameter.dart
  void write(MavlinkFrame frame) {
    if (_shouldReadFromTCP) {
      writeToTcpPort(frame);
    } else {
      writeToSerialPort(frame);
    }
  }
}