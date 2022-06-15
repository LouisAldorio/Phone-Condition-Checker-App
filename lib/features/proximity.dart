import 'dart:async';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

import 'package:vibration/vibration.dart';

class ProximitySensing extends StatefulWidget {
  const ProximitySensing({Key? key}) : super(key: key);

  static String routeName = '/proximity';

  @override
  State<ProximitySensing> createState() => _ProximitySensingState();
}

class _ProximitySensingState extends State<ProximitySensing>
    with WidgetsBindingObserver {
  bool _isNear = false;

  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    Vibration.cancel();
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };

    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
        if (_isNear) {
          Vibration.vibrate(duration: 500);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proximity Sensor Testing'),
      ),
      body: const Center(
        child:
            Text('Put your phone on your ear, like you are calling somebody!'),
      ),
    );
  }
}
