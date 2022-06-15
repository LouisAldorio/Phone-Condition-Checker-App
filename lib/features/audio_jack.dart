import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Jack'),
      ),
      body: Center(
        child: Text('Audio Jack ${headsetEvent.name}'),
      ),
    );
  }
}
