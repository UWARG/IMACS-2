import 'package:flutter/material.dart';

/// Widget for navigating between different screens
///
/// This widget displays the different sceeens in tabs along a bar at
/// the bottom of the screen. When clicked, each tab will navigate to
/// the corresponding screen.
class NavBar extends StatelessWidget {
  /// @brief Constructs a NavBar widget.
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.popAndPushNamed(context, '/logs');
            break;
          case 2:
            Navigator.popAndPushNamed(context, '/camera');
            break;
          default:
            Navigator.popAndPushNamed(context, '/sitl');
            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_sharp),
          label: 'Home',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted_sharp),
          label: 'Logs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_sharp),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_box_sharp),
          label: 'SITL',
        )
      ],
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: const Placeholder(),
        bottomNavigationBar: const NavBar());
  }
}
