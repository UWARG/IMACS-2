import 'package:flutter/material.dart';
import 'package:imacs/modules/return_to_launch.dart';

class ReturnToLaunchButton extends StatelessWidget {
  final ReturnToLaunch returnToLaunchCommand;

  const ReturnToLaunchButton({Key? key, required this.returnToLaunchCommand})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          returnToLaunchCommand.returnNoQueue();
        },
        child: const Text("Return To Launch"));
  }
}
