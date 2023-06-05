import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  Future<String> getTokenNum() async{
    var user = FirebaseAuth.instance.currentUser;
    String res = "-1";
    await FirebaseFirestore.instance.collection('users').where("id", isEqualTo: user?.uid).get().then(
            (query) => {
          res = query.docs.first.get("tokens").toString()
        }
    );
    return res;
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(message, style: const TextStyle(color: Colors.red)
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  updateToken(BuildContext context, User? user,int value, BluetoothCharacteristic aux) async{
    int tokens = value - 1;

    if(tokens < 0){
      Navigator.of(context).pop();
      showError(context, "You do not have any tokens to spend :(");
      return;
    }

    await FirebaseFirestore.instance.collection('users').where("id", isEqualTo: user?.uid).get().then(
            (query) => {
          FirebaseFirestore.instance.collection('users').doc(query.docs.first.id).update(
              {
                "tokens": tokens
              })
        }
    );

    aux.write([1]);
  }

  deductToken(BuildContext context, BluetoothCharacteristic aux) async {
    User? user = FirebaseAuth.instance.currentUser;
    getTokenNum().then(
            (value) => {
          updateToken(context, user, int.parse(value), aux)
        }
    );
    Navigator.of(context).pop();
  }

  Future showPaymentAlert(BuildContext context,  BluetoothCharacteristic aux) {return showDialog(
      context: context,
      builder: (BuildContext context) { return
        AlertDialog(
          title: const Text('This action will deduct a Token are you sure you want to continue?'),
          actions: [
            TextButton(
                onPressed: () => deductToken(context, aux), child: const Text('Reserve', style: TextStyle(color: Colors.green),)),
            TextButton(onPressed: () => {Navigator.of(context).pop()}, child: const Text('Cancel', style: TextStyle(color: Colors.red)))
          ],
        );
      });
  }

  Widget _buildServiceTiles(BuildContext context, List<BluetoothService> services) {


    for(var i=0;i<services.length;i++){
      if(services[i].characteristics[0].uuid.toString() == "19b10010-e8f2-537e-4f6c-d104768a1214") {
        BluetoothCharacteristic aux = services[i].characteristics[0];
        return Column(
          children: [
            ListTile(
              splashColor: Colors.amber,
              title: const Text("Reserve now", style: TextStyle(fontSize: 22),),
              onTap: () {
                showPaymentAlert(context, aux);
              },
            ),
            ListTile(
              splashColor: Colors.amber,
              title: const Text("End reservation", style: TextStyle(fontSize: 22),),
              onTap: () {
              aux.write([0]);
              },
            )
          ],
        );
      }
    }
    return Text("");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return TextButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading:
                (snapshot.data == BluetoothDeviceState.connected) ? const Icon(Icons.bluetooth_connected) : const Icon(Icons.bluetooth_disabled),
                title: Text('Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data! ? 1 : 0,
                    children: <Widget>[
                      TextButton(
                        child: const Text("Show Services"),
                        onPressed: () => device.discoverServices(),
                      ),
                      const IconButton(
                        icon: SizedBox(
                          width: 18.0,
                          height: 18.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: const [],
              builder: (c, snapshot) {
                return  _buildServiceTiles(context, snapshot.data!);
              },
            ),
          ],
        ),
      ),
    );
  }
}