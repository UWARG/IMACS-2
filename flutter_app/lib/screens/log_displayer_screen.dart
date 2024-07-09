import 'package:flutter/material.dart';

class LogDisplayerScreen extends StatelessWidget {
  final String fileContext;
  final String fileName;
  const LogDisplayerScreen(
      {Key? key, required this.fileContext, required this.fileName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
      ),
      body: SingleChildScrollView(
        child: ListTile(
          title: Text(fileContext),
        ),
      ),
    );
  }
}
