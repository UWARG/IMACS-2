import 'package:flutter/material.dart';
import 'package:imacs/widgets/nav_bar_widget.dart';
import 'package:imacs/widgets/camera_widget.dart';

/// A screen that displays a live camera feed.
class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: CameraWidget(),
        bottomNavigationBar: const NavBar());
  }
}
