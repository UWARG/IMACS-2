import 'dart:io';

class GetAirsideLogs {
  final String pathToDirectory;

  GetAirsideLogs({required this.pathToDirectory});

  List<File> getFiles() {
    return Directory(pathToDirectory)
        .listSync(recursive: true, followLinks: true)
        .whereType<File>()
        .toList();
  }
}
