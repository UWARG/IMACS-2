import 'package:flutter/material.dart';
import 'package:imacs/modules/return_to_launch.dart';

class ReturnToLaunchButton extends StatelessWidget {
  final ReturnToLaunch returnToLaunchCommand;
  final int systemID;
  final int componentID;

  // Needs the ReturnToLaunch object from the return_to_launch dart
  const ReturnToLaunchButton(
      {Key? key,
      required this.returnToLaunchCommand,
      required this.systemID,
      required this.componentID})
      : super(key: key);

  // Returns a button that tells the drone to return to launch + displays a snackbar
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          returnToLaunchCommand.returnNoQueue(systemID, componentID);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Send Mavlink RTL command'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Text("Return To Launch"));
  }
}
