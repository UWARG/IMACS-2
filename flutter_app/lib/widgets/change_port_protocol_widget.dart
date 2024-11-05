import 'package:flutter/material.dart';
import 'package:imacs/modules/change_port_protocol.dart';
import 'package:imacs/modules/mavlink_communication.dart';

const Map<MavlinkCommunicationType, String> mavCommTypes = {
  MavlinkCommunicationType.serial: "Serial",
  MavlinkCommunicationType.tcp: "TCP"
};

class PortProtocolChanger extends StatefulWidget {
  final MavlinkCommunication comm;
  final ChangePortProtocol changePortProtocol;

  const PortProtocolChanger(
      {super.key,
      required this.comm, required this.changePortProtocol});

  @override
  State<PortProtocolChanger> createState() => _PortProtocolChangerState();
}

class _PortProtocolChangerState extends State<PortProtocolChanger> {
  late final TextEditingController addressController =
      TextEditingController.fromValue(
          TextEditingValue(text: widget.comm.connectionAddress));
  late final portController = TextEditingController.fromValue(
      TextEditingValue(text: widget.comm.tcpPort.toString()));

  late MavlinkCommunicationType? selectedType = widget.comm.connectionType;

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
        child: Column(children: [
          DropdownMenu<MavlinkCommunicationType>(
              dropdownMenuEntries: mavCommTypes.entries
                  .map<DropdownMenuEntry<MavlinkCommunicationType>>((entry) {
                return DropdownMenuEntry(value: entry.key, label: entry.value);
              }).toList(),
              initialSelection: widget.comm.connectionType,
              onSelected: (MavlinkCommunicationType? newValue) {
                setState(() {
                  selectedType = newValue;
                });
              }),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(hintText: "Address"),
          ),
          TextField(
            controller: portController,
            decoration: const InputDecoration(hintText: "Port"),
          ),
          const SizedBox(height: 8),
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

              widget.changePortProtocol.updateCommParams(
                  selectedType ?? widget.comm.connectionType,
                  addressController.text,
                  tcpPort);
              setState(() {
                statusMsg = "Successfully changed";
              });
            },
          ),
          Padding(
              padding: const EdgeInsets.only(top: 5), child: Text(statusMsg)),
        ]));
  }
}
