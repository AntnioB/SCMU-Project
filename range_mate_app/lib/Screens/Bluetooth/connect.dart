import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'device.dart';

class FlutterBlueApp extends StatelessWidget {
  const FlutterBlueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF8FD5A6),
        scaffoldBackgroundColor: const Color(0xFF0C8346),
      ),
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBluePlus.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return const FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.4, 0.7, 0.9],
            colors: [
              const Color(0xFF8FD5A6).withOpacity(0.8),
              const Color(0xFF329F5B),
              const Color(0xFF0C8346),
              const Color(0xFF0D5D56)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                color: Colors.white54,
              ),
              Text(
                'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Find Devices',
            style: TextStyle(color: Colors.black, fontFamily: 'BreeSerif'),
        ),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.instance.scanResults,
              initialData: const [],
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                    .map((result) => ListTile(
                  title: Text(result.device.name == "" ? "No Name " : result.device.name),
                  subtitle: Text(result.device.id.toString()),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    result.device.connect();
                    return DeviceScreen(device: result.device);
                  })),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => FlutterBluePlus.instance.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              backgroundColor: Colors.amber,
                child: const Icon(Icons.search), onPressed: () => FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}