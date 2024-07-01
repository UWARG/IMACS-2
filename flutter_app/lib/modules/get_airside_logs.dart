import 'dart:io';

class GetAirsideLogs{
  final String pathToDirectory;

  GetAirsideLogs({required this.pathToDirectory});

  List <File> getFiles(){
    return Directory(pathToDirectory).listSync().whereType<File>().toList();
  }

}

