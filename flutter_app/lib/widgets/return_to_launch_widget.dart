import 'package:flutter/material.dart';
import 'package:imacs/modules/return_to_launch.dart';

class ReturnToLaunchTemplate extends StatefulWidget {
  final ReturnToLaunch returnToLaunchCommand;
  final int systemID;
  final int componentID;

// Needs the ReturnToLaunch object from the return_to_launch dart

  const ReturnToLaunchTemplate(
      {Key? key,
      required this.returnToLaunchCommand,
      required this.systemID,
      required this.componentID})
      : super(key: key);

  @override
  ReturnToLaunchButton createState() => ReturnToLaunchButton();
}

class ReturnToLaunchButton extends State<ReturnToLaunchTemplate> {
  String buttonLabel = "Return to Launch";

  void updateButton() {
    setState(() {
      buttonLabel = "Sent"; // Triggers a rebuild
    });
  }

  // Returns a button that tells the drone to return to launch
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          bool result = await widget.returnToLaunchCommand
              .returnNoQueue(widget.systemID, widget.componentID);
          if (true) {
            updateButton();
          }
        },
        child: Text(buttonLabel));
  }
}
