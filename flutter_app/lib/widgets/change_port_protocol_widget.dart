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

  var statusMsg = "";

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      width: 400,
      padding: const EdgeInsets.all(10.0),
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
              var tcpPort = int.tryParse(portController.text);

              if (tcpPort == null) {
                setState(() {
                  statusMsg = "Invalid port";
                });
                return;
              }

              widget.updateCommunicationParams(selectedType ?? widget.communicationType, addressController.text, tcpPort);
              setState(() {
                statusMsg = "Successfully changed";
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(statusMsg)
          ),
        ]
      )
    );
  }
}