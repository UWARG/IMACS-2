import 'package:flutter/material.dart';
import 'package:imacs/screens/home_screen.dart';
import 'package:imacs/widgets/nav_bar_widget.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WARG IMACS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (BuildContext context) => HomePage(title: 'WARG IMACS'),
        '/logs': (BuildContext context) => const Placeholder(child: NavBar()),
        '/camera': (BuildContext context) => const Placeholder(child: NavBar()),
        '/sitl': (BuildContext context) => const Placeholder(child: NavBar()),
      },
    );
  }
}
