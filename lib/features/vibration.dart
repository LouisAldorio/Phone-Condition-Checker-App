import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class Vibrations extends StatefulWidget {
  const Vibrations({Key? key}) : super(key: key);

  static String routeName = '/vibration';

  @override
  _VibrationsState createState() => _VibrationsState();
}

class _VibrationsState extends State<Vibrations> with WidgetsBindingObserver {
  @override
  void dispose() {
    Vibration.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: const Text('Press Me to start vibrating!'),
                onPressed: () {
                  Vibration.vibrate(
                      pattern: [1000, 500, 1000, 500, 1000, 500, 1000, 500]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
