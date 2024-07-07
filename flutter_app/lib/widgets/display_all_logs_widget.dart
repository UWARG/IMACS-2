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
    final String fileContent = arguments as String;
    return MaterialPageRoute(
      builder: (context) => LogDisplayerScreen(fileContext: fileContent),
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
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  tileColor: Colors.blue.withOpacity(0.2),
                  title: Text(getAirsideLogs.getFiles()[index].path),
                  onTap: () {
                    String fileContent =
                      getAirsideLogs.getFiles()[index].readAsStringSync();
                    Navigator.of(context).restorablePush(
                      _logDisplayerRoute, // restorable push wouldn't function without static method
                      arguments: fileContent,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
