import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({Key? key}) : super(key: key);

  static String routeName = '/bluetooth';

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> with WidgetsBindingObserver {
  FlutterBlue bluetoothController = FlutterBlue.instance;
  StreamSubscription<List<ScanResult>>? _bluetoothScanSubscription;

  void subscribeBluetooth() {
    _bluetoothScanSubscription = bluetoothController.scanResults.listen(
      (results) {
        // do something with scan results
        for (ScanResult r in results) {
          debugPrint('${r.device.name} found! rssi: ${r.rssi}');
        }
      },
    );
  }

  @override
  void initState() {
    subscribeBluetooth();

    bluetoothController.startScan(timeout: const Duration(seconds: 5));
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // Handle this case
        break;
      case AppLifecycleState.inactive:
        // Handle this case
        break;
      case AppLifecycleState.paused:
        // Handle this case
        break;
      case AppLifecycleState.detached:
        // Handle this case
        break;
    }
  }

  @override
  void dispose() {
    if (_bluetoothScanSubscription != null) {
      _bluetoothScanSubscription!.cancel();
    }
    bluetoothController.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
      ),
      body: const Center(
        child: Text('Bluetooth'),
      ),
    );
  }
}
