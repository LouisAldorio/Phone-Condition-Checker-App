import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Speakers extends StatefulWidget {
  const Speakers({Key? key}) : super(key: key);

  static String routeName = '/speakers';

  @override
  State<Speakers> createState() => _SpeakersState();
}

class _SpeakersState extends State<Speakers> with WidgetsBindingObserver {
  List<AudioPlayer> createdAudioPlayer = [];

  final data = [
    {
      "name": "Sandwich",
      "url": "sandwich.mp3",
    },
    {
      "name": "Pizza",
      "url": "pizza.mp3",
    },
    {"name": "Mozarella", "url": "mozarella.mp3"},
    {"name": "Hamburger", "url": "hamburger.mp3"},
    {"name": "Technology", "url": "technology.mp3"}
  ];

  void playSound(String path) async {
    final audioPlayer = AudioPlayer();
    createdAudioPlayer.add(audioPlayer);
    await audioPlayer.play(AssetSource("sounds/$path"));
  }

  @override
  void dispose() {
    for (AudioPlayer element in createdAudioPlayer) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Speakers'),
        leading: CupertinoNavigationBarBackButton(
          color: Theme.of(context).colorScheme.primary,
          previousPageTitle: "Home",
          onPressed: () => Get.back(),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.map((item) {
              return Column(children: [
                CupertinoButton.filled(
                  child: Text(item["name"].toString()),
                  onPressed: () {
                    playSound(item["url"].toString());
                  },
                ),
                const SizedBox(
                  height: 10,
                )
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
