import 'package:flutter/material.dart';
import 'package:imacs/modules/get_airside_logs.dart';
import 'package:imacs/screens/log_displayer_screen.dart';

class LogsList extends StatelessWidget{

  const LogsList ({super.key, required this.getAirsideLogs,});

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
            return ListTile (
              trailing: ElevatedButton (
                child: Text (getAirsideLogs.getFiles()[index].path),
                onPressed: () async {
                  String fileContent = await getAirsideLogs.getFiles()[index].readAsString();
                  Navigator.restorablePush(
                    context,
                    (context, arguments) => MaterialPageRoute(
                      builder: (context) => LogDisplayerScreen(fileContext: fileContent),
                    ),
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