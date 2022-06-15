import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class Volumes extends StatefulWidget {
  const Volumes({Key? key}) : super(key: key);

  static String routeName = '/volume';

  @override
  State<Volumes> createState() => _VolumesState();
}

class _VolumesState extends State<Volumes> with WidgetsBindingObserver {
  double _volumeListenerValue = 0;
  double _getVolume = 0;
  double _setVolumeValue = 0;

  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Listen to system volume change
    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
    playSound();
  }

  void playSound() async {
    String url =
        "https://fileserver.louisaldorio.site/audio/%E9%9F%B3%E9%97%95%E8%A9%A9%E8%81%BD%E2%80%93%E8%8A%92%E7%A8%AE-MangZhong-120900498.mp3";
    await audioPlayer.play(UrlSource(url));
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volume Plugin example app'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Current volume: $_volumeListenerValue'),
            Row(
              children: [
                const Text('Set Volume:'),
                Flexible(
                  child: Slider(
                    min: 0,
                    max: 1,
                    onChanged: (double value) {
                      _setVolumeValue = value;
                      VolumeController().setVolume(_setVolumeValue);
                      setState(() {});
                    },
                    value: _setVolumeValue,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Volume is: $_getVolume'),
                TextButton(
                  onPressed: () async {
                    _getVolume = await VolumeController().getVolume();
                    setState(() {});
                  },
                  child: const Text('Get Volume'),
                ),
              ],
            ),
            TextButton(
              onPressed: () => VolumeController().muteVolume(),
              child: const Text('Mute Volume'),
            ),
            TextButton(
              onPressed: () => VolumeController().maxVolume(),
              child: const Text('Max Volume'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show system UI:${VolumeController().showSystemUI}'),
                TextButton(
                  onPressed: () => setState(() => VolumeController()
                      .showSystemUI = !VolumeController().showSystemUI),
                  child: const Text('Show/Hide UI'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
