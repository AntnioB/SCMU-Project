import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class DeviceWidget extends StatefulWidget {
  const DeviceWidget({super.key});

  @override
  State<DeviceWidget> createState() => _DeviceWidget();
}

class _DeviceWidget extends State<DeviceWidget> {
  String deviceName = '19B10010-E8F2-537E-4F6C-D104768A1214';
  bool isOn = false;
  String ballsRemaining = '';

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  void getDeviceState() async {
    var collection = FirebaseFirestore.instance.collection('devices');
    collection.doc('19B10010-E8F2-537E-4F6C-D104768A1214').snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;

        // You can then retrieve the value from the Map like this:
        var status = data['status'];
        if(status == "OFF"){
          isOn = false;
        }
        else {isOn = true;}
      }
    });
  }

  void setDeviceState(bool state) async{
    var collection = FirebaseFirestore.instance.collection('devices');
    Socket socket = await Socket.connect('192.168.0.92' ,80); // serrado -> 192.168.0.92 | uni -> ?
    String status;
    if(state){
      status  = "STANDBY";
      socket.write('1');
    }
    else{
      status = "OFF";
      socket.write('0');
    }
    socket.close();
    collection.doc('19B10010-E8F2-537E-4F6C-D104768A1214').update({"status": status});
  }


  @override
  Widget build(BuildContext context) {
    getDeviceState();

// final docRef = FirebaseFirestore.instance.collection("devices").doc(deviceName);
//     docRef.snapshots().listen(
//       (event) {
//         final source = (event.metadata.hasPendingWrites) ? "Local" : "Server";
//         developer.log("$source data: ${event.data()}");
//         String status = event.get('status');
//         if(status == "OFF") {isOn = false;}
//         else {isOn = true;}
//         ballsRemaining = event.get('ballsRemaining').toString();
//         developer.log(ballsRemaining.toString());
//       },
//       onError: (error) => developer.log("Listen failed: $error"),
//     );

    return Container(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Column(
          children: [
            const Text(
              'deviceID:',
              style: TextStyle(
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
                                      setDeviceState(isOn);
                                    });
                                  },
                                )))))
              ],
            ),
            Row(children: [
              Text('Balls Remaining:                        $ballsRemaining',
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  )),
            ]),
          ],
        ));
  }
}
