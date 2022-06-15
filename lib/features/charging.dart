import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class Charging extends StatefulWidget {
  const Charging({Key? key}) : super(key: key);

  static String routeName = '/charging';

  @override
  State<Charging> createState() => _ChargingState();
}

class _ChargingState extends State<Charging> with WidgetsBindingObserver {
  Battery battery = Battery();
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  String batteryState = 'Unknown';

  void listenToBatteryPort() {
    _batteryStateSubscription =
        battery.onBatteryStateChanged.listen((BatteryState state) {
      // Do something with new state
      switch (state) {
        case BatteryState.charging:
          setState(() {
            batteryState = 'Charging';
          });
          break;
        case BatteryState.discharging:
          setState(() {
            batteryState = 'Discharging';
          });
          break;
        case BatteryState.full:
          setState(() {
            batteryState = 'Full';
          });
          break;
        case BatteryState.unknown:
          setState(() {
            batteryState = 'Unknown';
          });
          break;
        default:
          break;
      }
    });
  }

  @override
  void initState() {
    listenToBatteryPort();
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
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charging Port Testing'),
      ),
      body: Center(
        child: Text(batteryState),
      ),
    );
  }
}
