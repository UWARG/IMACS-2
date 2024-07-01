import 'package:flutter/material.dart';
import 'package:imacs/modules/get_airside_logs.dart';
import 'package:imacs/screens/log_display_screen.dart';

class LogReader extends StatelessWidget{

  const LogReader ({super.key, required this.getAirsideLogs});

  final GetAirsideLogs getAirsideLogs;
   
  @override
  Widget build (BuildContext context){
    return SizedBox(
      height: 300,
      child: AspectRatio(
        aspectRatio: 16/9,
        child: ListView.builder(
          itemCount: getAirsideLogs.getFiles().length,
          itemBuilder: (context, index){
            return Padding (
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton (
                child: Text (getAirsideLogs.getFiles()[index].path),
                onPressed: () async {
                  String fileContent = await getAirsideLogs.getFiles()[index].readAsString();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LogDisplayer(fileContext: fileContent),
                    )
                  );  
                } 
              ),
            );
          },
        ),
      ),
    );
  }
}