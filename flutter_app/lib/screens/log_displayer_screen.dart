import 'package:flutter/material.dart';

class LogDisplayerScreen extends StatelessWidget{
  final String fileContext;
  const LogDisplayerScreen ({Key? key, required this.fileContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Displayer'),
      ),
      body: ListView(
        children: [
          Text(fileContext),
        ],
      ),
    );
  }
}