import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imacs/widgets/nav_bar_widget.dart';

void main() {
  group('Navbar widget', () {
    testWidgets('NavBar navigates to correct route',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => const Scaffold(
                body: Text('Home Page'), bottomNavigationBar: NavBar()),
            '/logs': (context) => const Scaffold(
                body: Text('Logs Page'), bottomNavigationBar: NavBar()),
            '/camera': (context) => const Scaffold(
                body: Text('Camera Page'), bottomNavigationBar: NavBar()),
            '/sitl': (context) => const Scaffold(
                body: Text('SITL Page'), bottomNavigationBar: NavBar()),
          },
        ),
      );

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Test home icon tap
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Home Page'), findsOneWidget);

      await tester.tap(find.text('Logs'));
      await tester.pumpAndSettle();
      expect(find.text('Logs Page'), findsOneWidget);

      await tester.tap(find.text('Camera'));
      await tester.pumpAndSettle();
      expect(find.text('Camera Page'), findsOneWidget);

      await tester.tap(find.text('SITL'));
      await tester.pumpAndSettle();
      expect(find.text('SITL Page'), findsOneWidget);
    });
  });
}
