import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/widgets/nav_bar_widget.dart';

void main() {
  testWidgets('NavBar navigates to correct route on icon tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Scaffold(body: NavBar()),
          '/logs': (context) => Scaffold(body: Text('Logs Page')),
          '/camera': (context) => Scaffold(body: Text('Camera Page')),
          '/sitl': (context) => Scaffold(body: Text('SITL Page')),
        },
      ),
    );

    expect(find.byType(BottomNavigationBar), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_sharp));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget); 

    await tester.tap(find.byIcon(Icons.format_list_bulleted_sharp));
    await tester.pumpAndSettle();
    expect(find.text('Logs Page'), findsOneWidget);
  });
}
