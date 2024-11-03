import 'dart:io';

class SITLLogger {
  late File logFiles;
  final String filepath;

  SITLLogger({required this.logFiles, required this.filepath}) {
    logFiles = File(filepath);
    logFiles.writeAsStringSync('', mode: FileMode.write);
  }

  void logger(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final log = '[$timestamp] $message';

    print(log); //print to console

    logFiles.writeAsStringSync('$log\n', mode: FileMode.write);
  }

  void stdoutlogs(Process sitl) {
    sitl.stdout.transform(SystemEncoding().decoder).listen((data) {
      logger('SITL Output: $data');
    });
  }

  void stderrlogs(Process sitl) {
    sitl.stderr.transform(SystemEncoding().decoder).listen((data) {
      logger('SITL Error: $data');
    });
  }

  //not sure if there are other types of logging messages (ie. WARNING, INFO, ERROR, etc) to be used
}
