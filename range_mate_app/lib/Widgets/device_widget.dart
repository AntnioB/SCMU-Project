import 'package:flutter/material.dart';

class DeviceWidget extends StatefulWidget {
  const DeviceWidget({super.key});

  @override
  State<DeviceWidget> createState() => _DeviceWidget();
}

class _DeviceWidget extends State<DeviceWidget> {
  String deviceName = 'Device 1';
  bool isOn = true;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Column(
          children: [
            Text(
              'deviceID:',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                const Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                    child: Container(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                            width: 90,
                            height: 70,
                            child: FittedBox(
                                fit: BoxFit.fill,
                                child: Switch(
                                  thumbIcon: thumbIcon,
                                  // This bool value toggles the switch.
                                  value: isOn,
                                  activeColor: Colors.red,
                                  onChanged: (bool value) {
                                    // This is called when the user toggles the switch.
                                    setState(() {
                                      isOn = value;
                                    });
                                  },
                                )))))
              ],
            ),
            Row(children: [
              Text('Balls Remaining: 1000',
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  )),
            ]),
          ],
        ));
  }
}
