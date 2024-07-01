import 'dart:io';
import 'package:flutter/material.dart';

class LogDisplayer extends StatelessWidget{
  final String fileContext;
  const LogDisplayer ({Key? key, required this.fileContext}) : super(key: key);

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