import 'dart:typed_data';
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
  final bool _shouldReadFromTCP;
  
  late Stream<Uint8List> _stream;
  late SerialPort _serialPort;
  
  MavlinkCommunication(bool shouldReadFromTCP, String connectionAddress) 
    : _parser = MavlinkParser(MavlinkDialectCommon()),
      _shouldReadFromTCP = shouldReadFromTCP {
  
    if (shouldReadFromTCP) {
      startupTcpPort(connectionAddress);
    }
    else {
      startupSerialPort(connectionAddress);
    }
    
    parseMavlinkMessage();
  }
  
  startupTcpPort(String connectionAddress) {
    // Connect to the socket  
    throw UnimplementedError();
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
    throw UnimplementedError();
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
      }
    });
  }

  
  Stream<double> getYawStream() {return _yawStreamController.stream; }
  Stream<double> getPitchStream() {return _pitchStreamController.stream; }
  Stream<double> getRollStream() {return _rollStreamController.stream; }
  Stream<double> getRollSpeedStream() {return _rollSpeedController.stream; }
  Stream<double> getPitchSpeedStream() {return _pitchSpeedController.stream; }
  Stream<double> getYawSpeedStream() {return _yawSpeedController.stream; }
  Stream<int> getTimeBootMsPitchStream() {return _timeBootMsPitchController.stream; }

  // Send MAVLink messages
  // Refer to the link below to see how MAVLink frames are sent 
  // https://github.com/nus/dart_mavlink/blob/main/example/parameter.dart
  void write(MavlinkFrame frame) {
    if (_shouldReadFromTCP) {
      writeToTcpPort(frame);
    }
    else {
      writeToSerialPort(frame);
    }
  }
}