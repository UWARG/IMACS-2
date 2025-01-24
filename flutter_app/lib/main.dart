import 'package:flutter/material.dart';
import 'package:imacs/screens/camera_screen.dart';
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
        '/logs': (BuildContext context) =>
            const PlaceholderScreen(title: 'Logs'), // TODO: pass in ctx & name
        '/camera': (BuildContext context) =>
            const CameraScreen(title: 'Camera'),
        '/sitl': (BuildContext context) =>
            const PlaceholderScreen(title: 'SITL'),
      },
    );
  }
}
