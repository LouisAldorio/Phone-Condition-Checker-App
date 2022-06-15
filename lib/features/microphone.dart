import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';

enum Command {
  start,
  stop,
}

class Microphones extends StatefulWidget {
  const Microphones({Key? key}) : super(key: key);

  static String routeName = '/microphone';

  @override
  State<Microphones> createState() => _MicrophonesState();
}

class _MicrophonesState extends State<Microphones>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Stream? stream;
  StreamSubscription? listener;
  List<int> visibleSamples = [];
  int? localMax;
  int? localMin;

  Random rng = Random();

  // Refreshes the Widget for every possible tick to force a rebuild of the sound wave
  late AnimationController controller;

  bool isRecording = false;
  bool memRecordingState = false;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setState(() {
      initPlatformState();
    });
  }

  // Responsible for switching between recording / idle state
  void _controlMicStream(Command command) async {
    switch (command) {
      case Command.start:
        _startListening();
        break;
      case Command.stop:
        _stopListening();
        break;
    }
  }

  Future<bool> _startListening() async {
    if (isRecording) return false;
    // if this is the first time invoking the microphone()
    // method to get the stream, we don't yet have access
    // to the sampleRate and bitDepth properties

    // Default option. Set to false to disable request permission dialogue
    MicStream.shouldRequestPermission(true);

    stream = await MicStream.microphone(
      audioSource: AudioSource.DEFAULT,
      sampleRate: 1000 * (rng.nextInt(50) + 30),
      channelConfig: ChannelConfig.CHANNEL_IN_MONO,
      audioFormat: AudioFormat.ENCODING_PCM_16BIT,
    );
    // after invoking the method for the first time, though, these will be available;
    // It is not necessary to setup a listener first, the stream only needs to be returned first
    debugPrint(
        "Start Listening to the microphone, sample rate is ${await MicStream.sampleRate}, bit depth is ${await MicStream.bitDepth}, bufferSize: ${await MicStream.bufferSize}");
    localMax = null;
    localMin = null;

    setState(() {
      isRecording = true;
    });
    visibleSamples = [];
    listener = stream!.listen(_calculateWaveSamples);
    return true;
  }

  void _calculateWaveSamples(samples) {
    bool first = true;
    visibleSamples = [];
    int tmp = 0;
    for (int sample in samples) {
      if (sample > 128) sample -= 255;
      if (first) {
        tmp = sample * 128;
      } else {
        tmp += sample;
        visibleSamples.add(tmp);

        localMax ??= visibleSamples.last;
        localMin ??= visibleSamples.last;
        localMax = max(localMax!, visibleSamples.last);
        localMin = min(localMin!, visibleSamples.last);

        tmp = 0;
      }
      first = !first;
    }
  }

  bool _stopListening() {
    if (!isRecording) return false;
    listener!.cancel();

    setState(() {
      isRecording = false;
    });
    return true;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
    isActive = true;

    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..addListener(() {
            if (isRecording) setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          })
          ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Microphones'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          !isRecording
              ? _controlMicStream(Command.start)
              : _controlMicStream(Command.stop);
        },
        child: (isRecording)
            ? const Icon(Icons.stop)
            : const Icon(Icons.keyboard_voice),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: (isRecording) ? "Stop recording" : "Start recording",
      ),
      body: Padding(
        padding:
            EdgeInsets.only(top: (MediaQuery.of(context).size.height * 0.25)),
        child: CustomPaint(
          painter: WavePainter(
            samples: visibleSamples,
            color: Theme.of(context).colorScheme.primary,
            localMax: localMax,
            localMin: localMin,
            context: context,
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isActive = true;

      _controlMicStream(memRecordingState ? Command.start : Command.stop);
    } else if (isActive) {
      memRecordingState = isRecording;
      _controlMicStream(Command.stop);

      isActive = false;
    }
  }

  @override
  void dispose() {
    if (listener != null) {
      listener!.cancel();
    }
    controller.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}

class WavePainter extends CustomPainter {
  int? localMax;
  int? localMin;
  List<int>? samples;
  late List<Offset> points;
  Color? color;
  BuildContext? context;
  Size? size;

  // Set max val possible in stream, depending on the config
  // int absMax = 255*4; //(AUDIO_FORMAT == AudioFormat.ENCODING_PCM_8BIT) ? 127 : 32767;
  // int absMin; //(AUDIO_FORMAT == AudioFormat.ENCODING_PCM_8BIT) ? 127 : 32767;

  WavePainter(
      {this.samples, this.color, this.context, this.localMax, this.localMin});

  @override
  void paint(Canvas canvas, Size? size) {
    this.size = context!.size;
    size = this.size;

    Paint paint = Paint()
      ..color = color!
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    if (samples!.isEmpty) return;

    points = toPoints(samples);

    Path path = Path();
    path.addPolygon(points, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  // Maps a list of ints and their indices to a list of points on a cartesian grid
  List<Offset> toPoints(List<int>? samples) {
    List<Offset> points = [];

    samples ??= List<int>.filled(size!.width.toInt(), (0.5).toInt());

    double pixelsPerSample = size!.width / samples.length;

    for (int i = 0; i < samples.length; i++) {
      var point = Offset(
          i * pixelsPerSample,
          0.5 *
              size!.height *
              pow((samples[i] - localMin!) / (localMax! - localMin!), 5));

      points.add(point);
    }

    return points;
  }
}
