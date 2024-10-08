import 'dart:developer';

import 'package:cli_script/cli_script.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget to pick multiple files from the device
///
/// This widget arranges a button which, when clicked, opens up the native
/// file picker of the device, and follows the user to select multiple files.
///
class TerminalWidget extends StatefulWidget {
  const TerminalWidget({
    Key? key,
  }) : super(key: key);

  @override
  _TerminalWidgetState createState() => _TerminalWidgetState();
}

class _TerminalWidgetState extends State<TerminalWidget> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();
  final _fileExtensionController = TextEditingController();
  String? _fileName; // name of the files selected
  List<PlatformFile>? _paths; // extracted paths
  String? _extension; // extensions allowed for picking
  final bool _lockParentWindow = false;
  final FileType _pickingType = FileType.any;

  @override
  void initState() {
    super.initState();
    _fileExtensionController
        .addListener(() => _extension = _fileExtensionController.text);
  }

  // opens a dialogue window, allows the user to pick multiple files,
  // and returns the file paths
  void _pickFiles() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: _pickingType,
        allowMultiple: true,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      log('[Terminal Widget] Files selected  are $_fileName');
    });
  }

  void _logException(String message) {
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _runCode() {
    wrapMain(() async {
      await run('echo "Hello, world!"');
    });
    if (!mounted) {
      return;
    }
    setState(() {
      _fileName = null;
      _paths = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("The file selected is: ${_fileName != null ? _fileName : "None"}"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFiles,
              child: const Text("Select File"),
            ),
            const SizedBox(
              width: 30,
            ),
            IconButton(onPressed: _runCode, icon: const Icon(Icons.play_arrow)),
          ],
        ),
      ],
    );
  }
}
