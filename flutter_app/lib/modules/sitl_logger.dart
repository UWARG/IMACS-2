import 'dart:io';
import 'dart:developer';

class SITLLogger {
  late File logFiles;
  final String filepath;

  SITLLogger({required this.logFiles, required this.filepath}) {
    logFiles = File(filepath);
    logFiles.writeAsStringSync('', mode: FileMode.write);
  }

  void logger(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logs = '[$timestamp] $message';

    log(logs);

    logFiles.writeAsStringSync('$logs\n', mode: FileMode.write);
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
}
