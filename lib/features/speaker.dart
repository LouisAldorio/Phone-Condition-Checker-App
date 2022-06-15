import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speakers'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.map((item) {
              return ElevatedButton(
                child: Text(item["name"].toString()),
                onPressed: () {
                  playSound(item["url"].toString());
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
