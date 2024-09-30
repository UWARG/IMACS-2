import 'package:flutter/material.dart';
import 'package:imacs/modules/mavlink_communication.dart';

const Map<MavlinkCommunicationType, String> mavCommTypes = {
  MavlinkCommunicationType.serial: "Serial",
  MavlinkCommunicationType.tcp: "TCP"
};

class PortProtocolChanger extends StatefulWidget {
  final MavlinkCommunicationType communicationType;
  final String communicationAddress;
  final int tcpPort;
  final Function(MavlinkCommunicationType communicationType, String communicationAddress, int tcpPort) updateCommunicationParams;

  const PortProtocolChanger({super.key, required this.communicationType, required this.communicationAddress, required this.tcpPort, required this.updateCommunicationParams});

  @override
  State<PortProtocolChanger> createState() => _PortProtocolChangerState();
}

class _PortProtocolChangerState extends State<PortProtocolChanger> {
  late final TextEditingController addressController = TextEditingController.fromValue(TextEditingValue(text: widget.communicationAddress));
  late final portController = TextEditingController.fromValue(TextEditingValue(text: widget.tcpPort.toString()));

  late MavlinkCommunicationType? selectedType = widget.communicationType;

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          DropdownMenu<MavlinkCommunicationType>(
            dropdownMenuEntries:
              mavCommTypes.entries.map<DropdownMenuEntry<MavlinkCommunicationType>>((entry) {
                return DropdownMenuEntry(
                  value: entry.key,
                  label: entry.value
                );
              }).toList(),
            initialSelection: widget.communicationType,
            onSelected: (MavlinkCommunicationType? newValue) {
              setState(() {
                selectedType = newValue;
              });
            }
          ),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(
              hintText: "Address"
            ),
          ),
          TextField(
            controller: portController,
            decoration: const InputDecoration(
              hintText: "Port"
            ),
          ),
          ElevatedButton(
            child: const Text("Update Connection Params"),
            onPressed: () {
              // TODO: add input validation
              widget.updateCommunicationParams(selectedType ?? widget.communicationType, addressController.text, int.parse(portController.text));
            },
          )
        ]
      )
    );
  }
}