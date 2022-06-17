import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Proximity Sensor Test'),
        leading: CupertinoNavigationBarBackButton(
          color: Theme.of(context).colorScheme.primary,
          previousPageTitle: "Home",
          onPressed: () => Get.back(),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Put your phone on your ear, like you are calling somebody!',
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
