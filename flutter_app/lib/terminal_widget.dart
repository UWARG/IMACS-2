import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final terminal = Terminal(
    maxLines: 10000,
  );

  final terminalController = TerminalController();

  String getShell() {
    if (Platform.isLinux || Platform.isMacOS) {
      return Platform.environment['SHELL'] ?? 'bash';
    } else if (Platform.isWindows) {
      return 'cmd.exe';
    }

    return 'sh'; // Android
  }

  late final Pty pty;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        pty = Pty.start(getShell(),
            columns: terminal.viewWidth, rows: terminal.viewHeight);

        pty.output
            .cast<List<int>>()
            .transform(const Utf8Decoder())
            .listen(terminal.write);

        pty.exitCode
            .then((code) => terminal.write("process exited with code $code"));

        terminal.onOutput =
            (data) => pty.write(const Utf8Encoder().convert(data));

        terminal.onResize = (width, height, pixelWidth, pixelHeight) =>
            pty.resize(width, height);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TerminalView(
          terminal,
          controller: terminalController,
        ),
      ),
    );
  }
}
