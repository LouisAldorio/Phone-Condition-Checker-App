import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:headset_connection_event/headset_event.dart';

class AudioJack extends StatefulWidget {
  const AudioJack({Key? key}) : super(key: key);

  static String routeName = '/audio_jack';

  @override
  State<AudioJack> createState() => _AudioJackState();
}

class _AudioJackState extends State<AudioJack> {
  HeadsetEvent headsetPlugin = HeadsetEvent();
  HeadsetState headsetEvent = HeadsetState.DISCONNECT;

  @override
  void initState() {
    /// Detect the moment headset is plugged or unplugged
    headsetPlugin.setListener((_val) {
      setState(() {
        headsetEvent = _val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Audio Jack Port'),
        leading: CupertinoNavigationBarBackButton(
          color: Theme.of(context).colorScheme.primary,
          previousPageTitle: "Home",
          onPressed: () => Get.back(),
        ),
      ),
      child: Center(
        child: Text(
          'Audio Jack ${headsetEvent.name}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
