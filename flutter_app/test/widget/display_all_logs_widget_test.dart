import 'package:flutter/material.dart';
import 'package:imacs/modules/get_airside_logs.dart';
import 'package:imacs/screens/log_displayer_screen.dart';
import 'package:imacs/widgets/display_all_logs_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Display All Logs Widget',
    () {
      testWidgets(
        'Displays airside logs by showing their respective path',
        (WidgetTester tester) async {
          const String pathToDirectory = 'test/test_logs';
          final getAirsideLogs =
              GetAirsideLogs(pathToDirectory: pathToDirectory);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: LogsList(
                  getAirsideLogs:
                      GetAirsideLogs(pathToDirectory: pathToDirectory),
                ),
              ),
            ),
          );
          await tester.pump();
          final expectedFiles = getAirsideLogs.getFiles();

          final lastFile = expectedFiles.last;
          final lastFileSegments = lastFile.uri.pathSegments;
          final lastFileName = lastFileSegments.length == 1
              ? lastFileSegments.last
              : lastFileSegments
                  .sublist(lastFileSegments.length - 2, lastFileSegments.length)
                  .join('/');

          final firstFile = expectedFiles.first;
          final firstFileSegments = firstFile.uri.pathSegments;
          final firstFileName = firstFileSegments.length == 1
              ? firstFileSegments.last
              : firstFileSegments
                  .sublist(
                      firstFileSegments.length - 2, firstFileSegments.length)
                  .join('/');

          //testing scroll
          await tester.drag(
              find.byType(SingleChildScrollView), const Offset(0, -400));
          await tester.pumpAndSettle();

          expect(find.text(lastFileName), findsOneWidget);

          // test if all files show up
          expect(find.byType(Card), findsNWidgets(expectedFiles.length));

          // test that the names show up properly for each one
          for (var file in expectedFiles) {
            final filePath = file.uri.pathSegments;
            final fileName = filePath.length == 1
                ? filePath.last
                : filePath
                    .sublist(filePath.length - 2, filePath.length)
                    .join('/');
            expect(find.text(fileName), findsOneWidget);
          }

          // testing tapping the first file
          await tester.tap(find.text(firstFileName));
          await tester.pumpAndSettle();

          //testing LogDisplayerScreen navigation
          final fileContent = firstFile.readAsStringSync();
          expect(find.byType(LogDisplayerScreen), findsOneWidget);
          expect(find.text(fileContent), findsOneWidget);
          expect(find.text(firstFileName), findsOneWidget);
        },
      );
    },
  );
}
