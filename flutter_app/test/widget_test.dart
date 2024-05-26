// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:imacs/main.dart';

void main() {
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
}
