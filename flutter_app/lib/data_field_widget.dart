import 'package:flutter/material.dart';

class DataField<T> extends StatelessWidget {
  const DataField(
      {Key? key,
      required this.name,
      required this.value,
      required this.formatter})
      : super(key: key);

  final String name;
  final Stream<T> value;
  final Function(T) formatter;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        "$name: ",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      StreamBuilder<T>(
          stream: value,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Text(formatter(snapshot.data as T).toString());
            } else {
              return const Text('No data');
            }
          })
    ]);
  }
}
