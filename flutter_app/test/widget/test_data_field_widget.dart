import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/widgets/data_field_widget.dart';

void main() {
  group('DataField widget', () {
    testWidgets('DataField displays "No Data" when stream has no data',
        (WidgetTester tester) async {
      final StreamController<int> controller = StreamController<int>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DataField<int>(
            name: 'Test Field',
            value: controller.stream,
            formatter: (int value) => (value / 1e7).round(),
          ),
        ),
      ));

      expect(find.text('No data'), findsOneWidget);

      await controller.close();
    });

    testWidgets('DataField displays formatted data from a stream',
        (WidgetTester tester) async {
      const label = 'Test Field';
      final stream = Stream<int>.value(42);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataField<int>(
              name: label,
              value: stream,
              formatter: (int value) => value,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('42'), findsOneWidget);
    });
  });
}
