import 'dart:async';
import 'dart:ffi';
import "dart:math" as math;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({Key? key}) : super(key: key);

  static String routeName = '/bluetooth';

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  FlutterBlue bluetoothController = FlutterBlue.instance;
  StreamSubscription<List<ScanResult>>? _bluetoothScanSubscription;

  late AnimationController controller;

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
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    if (controller.isAnimating) {
      controller.stop();
    } else {
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
    }

    subscribeBluetooth();

    bluetoothController
        .startScan(timeout: const Duration(seconds: 5))
        .then((value) {
      if (value is List) {
        Get.back();
        Get.snackbar("Bluetooth Checking", "Your bluetooth is working great!",
            backgroundColor: Colors.teal, colorText: Colors.white);
      }
    });
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
    controller.dispose();
    bluetoothController.stopScan();
    super.dispose();
  }

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return '${duration.inMinutes}:${((duration.inSeconds % 60)).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext context, Widget? child) {
                                  return CustomPaint(
                                      painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.white,
                                    color: Colors.teal,
                                  ));
                                },
                              ),
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    "Checking Bluetooth",
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                  ),
                                  AnimatedBuilder(
                                      animation: controller,
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Text(
                                          timerString,
                                          style: const TextStyle(
                                              fontSize: 112.0,
                                              color: Colors.white),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  bool shouldRepaint(CustomTimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);

    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }
}
