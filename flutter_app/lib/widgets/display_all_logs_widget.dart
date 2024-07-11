import 'package:flutter/material.dart';
import 'package:imacs/modules/get_airside_logs.dart';
import 'package:imacs/screens/log_displayer_screen.dart';

class LogsList extends StatelessWidget {
  const LogsList({
    super.key,
    required this.getAirsideLogs,
  });

  final GetAirsideLogs getAirsideLogs;

  static Route _logDisplayerRoute(BuildContext context, Object? arguments) {
    final args = arguments as Map<String, String>;
    return MaterialPageRoute(
      builder: (context) => LogDisplayerScreen(
          fileContext: args['fileContent']!, fileName: args['fileName']!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 600,
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: ListView.builder(
            itemCount: getAirsideLogs.getFiles().length,
            itemBuilder: (context, index) {
              List<String> filePath =
                  getAirsideLogs.getFiles()[index].uri.pathSegments;
              String fileName = filePath.length == 1
                  ? filePath.last
                  : filePath
                      .sublist(filePath.length - 2, filePath.length)
                      .join('/');
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(fileName),
                    onTap: () {
                      String fileContent =
                          getAirsideLogs.getFiles()[index].readAsStringSync();
                      Navigator.of(context).restorablePush(
                        _logDisplayerRoute, // restorable push wouldn't function without static method
                        arguments: {
                          'fileContent': fileContent,
                          'fileName': fileName,
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
