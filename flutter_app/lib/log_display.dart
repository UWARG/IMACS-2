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
  late Iterable <File> files;
  late Iterable <String> filenames;
  late List <String> names;
  late List <String> fileContent = [];

  @override
  void initState(){
    super.initState();
    dir = Directory("C:\\Users\\emmao\\Documents\\logs"); // opens directory (from where i put it on my laptop)
    files = dir.listSync(recursive: true, followLinks: true).whereType<File>(); // gets files from each folder; iterable list of files
    filenames = files.map((file) => (file.path)); // maps the filepath to the file
    // alternatively, should i map the file name to the file content, so i don't need index anymore?
    // files.map((file.path) => (file.toString()));
    names = filenames.toList(); // makes a string list of the file names
    
    for (var file in files){
      file.readAsString().then((String contents) {
        fileContent.add(contents);
      });
     // string version of file for every file 
    }
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
          itemCount: names.length,
          itemBuilder: (context, index){
            return Padding (
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton (
                child: Text (names[index]),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LogDisplayer(fileContext: fileContent[index]),
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