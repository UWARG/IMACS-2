import 'package:cli_script/cli_script.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// Widget to select Python or Bash Scripts and run them through application
///
/// This widget allows the user to select Python and Bash Script from their
/// device and run them on the application itself. Useful for running pathing
/// scripts that are supposed to be sent to the drone.
///
class TerminalWidget extends StatefulWidget {
  /// @brief Constructs a TerminalWidget widget.
  ///
  const TerminalWidget({Key? key}) : super(key: key);

  @override
  TerminalWidgetState createState() => TerminalWidgetState();
}

class TerminalWidgetState extends State<TerminalWidget> {
  String? _filePath;
  String? _fileExtension;
  String _scriptOutput = '';
  String _scriptError = '';
  int _scriptExitCode = 0;
  String command = '';

  /// Allows the user to pick a Python (py) and Shell (sh) script from their
  /// native file picker. Returns the path of the file according to the user's
  /// operating system.
  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['py', 'sh'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.first.path;
        _fileExtension = result.files.first.extension;
      });
    }
  }

  /// Runs the script on the selected path. Updates the output and error using
  /// stdout and stderr respectively. Uses BroadCastStreams as they can be used
  ///  simultaneously in multiple instances.
  Future<void> _runScript() async {
    // Error Case (No file selected)
    if (_filePath == null) {
      setState(() {
        _scriptOutput = 'Please select a script file first.';
      });
      return;
    }

    try {
      if (_fileExtension == "py") {
        command = "python";
      } else if (_fileExtension == "sh") {
        command = "bash";
      } else {
        // Error case (Invalid file extension)
        setState(() {
          _scriptOutput = 'Invalid file extension.';
        });
        return;
      }

      final result = Script(command, args: [_filePath!]);
      final outputStream = result.stdout.text.asStream().asBroadcastStream();
      final errorStream = result.stderr.text.asStream().asBroadcastStream();

      outputStream.listen((output) {
        setState(() {
          _scriptOutput += output;
        });
      });

      errorStream.listen((error) {
        setState(() {
          _scriptError += error;
        });
      });

      _scriptExitCode = await result.exitCode;

      setState(() {
        if (_scriptExitCode != 0) {
          _scriptOutput +=
              '\nError (Exit code: $_scriptExitCode):\n$_scriptError';
        }
      });
    } catch (e) {
      setState(() {
        _scriptOutput = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Selected File: ${_filePath ?? "None"}'),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectFile,
              child: const Text('Select Python File'),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: _runScript,
              icon: const Icon(Icons.play_arrow),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.black,
          child: Text(
            _scriptOutput,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
