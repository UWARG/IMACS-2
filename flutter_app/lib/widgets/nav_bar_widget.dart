import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  int _index = 0;

  void _onItemClicked(int index) {
    setState(() {
      _index = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case 1:
        Navigator.pushNamed(context, '/logs');
        break;
      case 2:
        Navigator.pushNamed(context, '/camera');
        break;
      default:
        Navigator.pushNamed(context, '/sitl');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: _onItemClicked,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted_sharp),
          label: 'Logs',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_sharp),
          label: 'Camera',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_box_sharp),
          label: 'SITL',
          backgroundColor: Colors.black,
        )
      ],
      showUnselectedLabels: true,
    );
  }
}
