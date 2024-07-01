import 'package:flutter/material.dart';
import 'package:imacs/mavlink_communication.dart';
import 'package:imacs/data_field_widget.dart';

import 'dart:io';
/*
void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget{
  //const MainPage ({super.key});
  final comm2 = MavlinkCommunication(MavlinkCommunicationType.airside, "C:\\Users\\emmao\\Documents\\logs", 14550);
  
  @override
  Widget build (BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogReader(files: comm2.loadFiles("C:\\Users\\emmao\\Documents\\logs")),
      /*
      routes:{
        '/LogReader': (context) => LogReader(),
        'LogDisplayer': (context) => LogDisplayer(),
      }
      */
    );
  }
}
*/
class LogReader extends StatelessWidget{
  late List <File> files;
  
  LogReader ({Key? key, required this.files}) : super(key: key);
   
  @override
  Widget build (BuildContext context){
    return SizedBox(
      height: 300,
      child: AspectRatio(
        aspectRatio: 16/9,
        child: ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, index){
            return Padding (
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton (
                child: Text (files[index].path),
                onPressed: () async {
                  String fileContent = await files[index].readAsString();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LogDisplayer(fileContext: fileContent),
                    )
                  ); // i want it to make a unique button for all the files in the iterable file list 
                } // i also need access to that index so that i can use it retun the corresponding file content 
              ),
            );
          },
        ),
      ),
    );
  }
}

class LogDisplayer extends StatelessWidget{
  final String fileContext;
  LogDisplayer ({Key? key, required this.fileContext}) : super(key: key);

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