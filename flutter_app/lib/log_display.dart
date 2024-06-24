import 'package:flutter/material.dart';
import 'package:imacs/main.dart';
import 'package:imacs/mavlink_communication.dart';
import 'package:imacs/data_field_widget.dart';

import 'dart:math';
import 'dart:io';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget{
  //const MainPage ({super.key});

  @override
  Widget build (BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogReader(),
      /*
      routes:{
        '/LogReader': (context) => LogReader(),
        'LogDisplayer': (context) => LogDisplayer(),
      }
      */
    );
  }
}


class LogReader extends StatefulWidget{
  //const LogReader ({super.key});
  @override
  _LogReaderState createState() => _LogReaderState();
}

class _LogReaderState extends State<LogReader>{

  late Directory dir;
  // late String pathToDirectory = " "; // for respective location of data 
  late List <File> files;

  //late MavlinkCommunication comm; // for when i can run mavlink communications

  @override
  void initState(){
    super.initState();
    //comm = MavlinkCommunication(MavlinkCommunicationType.tcp, "C:\\Users\\emmao\\Documents\\logs", 14550);

    dir = Directory("C:\\Users\\emmao\\Documents\\logs"); // opens directory 
    files = dir.listSync(recursive: true, followLinks: true).whereType<File>().toList();
    //files = comm.loadDirectory("C:\\Users\\emmao\\Documents\\logs").listSync(recursive: true, followLinks: true).whereType<File>().toList(); 
    // when mavlink is used
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("AIRSIDE LOGS"),
        backgroundColor: const Color.fromARGB(255, 81, 170, 243),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, index){
            return Padding (
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton (
                child: Text (files[index].path),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LogDisplayer(fileContext: files[index].readAsStringSync()),
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
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text ("FILE CONTENT"),
        backgroundColor: Color.fromARGB(255, 126, 124, 124),
      ),
      body: ListView(
        children: [Text(fileContext),] // content from the file coming from its respective filename button
      ),
    );
  }
}