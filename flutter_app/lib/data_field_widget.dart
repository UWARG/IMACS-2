import 'package:flutter/material.dart';

/// Widget to display a data stream with label and formatting.
///
/// This widget takes a data stream, a label for the data, and a formatting
/// function as input. It displays the label followed by the formatted data
/// streamed from the provided stream. If no data is available, it displays
/// "No data".
///
/// @template T
/// The type of data streamed.
class DataField<T> extends StatelessWidget {
  /// @brief Constructs a DataField widget.
  ///
  /// @param name The label to display before the data.
  /// @param value The data stream to display.
  /// @param formatter A function to format the streamed data before displaying.
  ///
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
        },
      )
    ]);
  }
}
