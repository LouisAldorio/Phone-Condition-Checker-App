import 'dart:async';
import 'package:camera/camera.dart';
import 'package:checker_app_poc/features/audio_jack.dart';
import 'package:checker_app_poc/features/bluetooth.dart';
import 'package:checker_app_poc/features/camera.dart';
import 'package:checker_app_poc/features/charging.dart';
import 'package:checker_app_poc/features/microphone.dart';
import 'package:checker_app_poc/features/proximity.dart';
import 'package:checker_app_poc/features/screen_spot.dart';
import 'package:checker_app_poc/features/speaker.dart';
import 'package:checker_app_poc/features/touch_calibration.dart';
import 'package:checker_app_poc/features/vibration.dart';
import 'package:checker_app_poc/features/volume.dart';
import 'package:checker_app_poc/permission.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();

  runApp(const MediaQuery(
    child: Root(),
    data: MediaQueryData(),
  ));
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  static String routeName = '/';

  static PermissiongGateway permission = PermissiongGateway();

  final features = [
    {
      "name": "Microphone",
      "route": Microphones.routeName,
      "color": Colors.teal[50],
      "text_white": false,
    },
    {
      "name": "Camera",
      "route": Camera.routeName,
      "color": Colors.teal[100],
      "text_white": false,
    },
    {
      "name": "Charging",
      "route": Charging.routeName,
      "color": Colors.teal[200],
      "text_white": false,
    },
    {
      "name": "Proximity",
      "route": ProximitySensing.routeName,
      "color": Colors.teal[300],
      "text_white": false,
    },
    {
      "name": "Screen Spot",
      "route": ScreenSpot.routeName,
      "color": Colors.teal[400],
      "text_white": false,
    },
    {
      "name": "Speaker",
      "route": Speakers.routeName,
      "color": Colors.teal[500],
      "text_white": true,
    },
    {
      "name": "Touch Calibration",
      "route": TouchCalibration.routeName,
      "color": Colors.teal[600],
      "text_white": true,
    },
    {
      "name": "Vibration",
      "route": Vibrations.routeName,
      "color": Colors.teal[700],
      "text_white": true,
    },
    {
      "name": "Volume",
      "route": Volumes.routeName,
      "color": Colors.teal[800],
      "text_white": true,
    },
    {
      "name": "Bluetooth",
      "route": Bluetooth.routeName,
      "color": Colors.teal[900],
      "text_white": true,
    },
    {
      "name": "Audio Jack",
      "route": AudioJack.routeName,
      "color": Colors.teal[900],
      "text_white": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: OrientationBuilder(
            builder: (context, orientation) {
              return GridView.count(
                physics: const AlwaysScrollableScrollPhysics(),
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                children: features.map((feature) {
                  return InkWell(
                    onTap: () {
                      if (feature["name"] as String == "Camera") {
                        permission.checkCameraPermission(() {
                          Get.toNamed(feature["route"] as String);
                        });
                      }else if (feature["name"] as String == "Bluetooth") {
                        permission.checkLocationPermission(() {
                          Get.toNamed(feature["route"] as String);
                        });
                      }else if(feature["name"] as String == "Microphone") {
                        permission.checkMicrophonePermission(() {
                          Get.toNamed(feature["route"] as String);
                        });
                      } else {
                        Get.toNamed(feature["route"] as String);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: feature['color'] as Color,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          feature["name"].toString(),
                          style: TextStyle(
                            color: feature["text_white"] as bool == true
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GetMaterialApp(
      initialRoute: Home.routeName,
      getPages: [
        GetPage(
          name: Home.routeName,
          page: () => Home(),
        ),
        GetPage(
          name: Camera.routeName,
          page: () => Camera(
            cameras: _cameras,
          ),
        ),
        GetPage(
          name: Charging.routeName,
          page: () => const Charging(),
        ),
        GetPage(
          name: Bluetooth.routeName,
          page: () => const Bluetooth(),
        ),
        GetPage(
          name: Vibrations.routeName,
          page: () => const Vibrations(),
        ),
        GetPage(
          name: Volumes.routeName,
          page: () => const Volumes(),
        ),
        GetPage(
          name: ProximitySensing.routeName,
          page: () => const ProximitySensing(),
        ),
        GetPage(
          name: ScreenSpot.routeName,
          page: () => const ScreenSpot(),
        ),
        GetPage(
          name: Speakers.routeName,
          page: () => const Speakers(),
        ),
        GetPage(
          name: TouchCalibration.routeName,
          page: () => TouchCalibration(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
        ),
        GetPage(
          name: Microphones.routeName,
          page: () => const Microphones(),
        ),
        GetPage(
          name: AudioJack.routeName,
          page: () => const AudioJack(),
        ),
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F8FD),
        primaryColor: const Color.fromARGB(255, 0, 150, 136),
        primarySwatch: MaterialColor(
          const Color.fromARGB(255, 0, 150, 136).value,
          const <int, Color>{
            50: Color.fromARGB(255, 0, 150, 136),
            100: Color.fromARGB(255, 0, 150, 136),
            200: Color.fromARGB(255, 0, 150, 136),
            300: Color.fromARGB(255, 0, 150, 136),
            400: Color.fromARGB(255, 0, 150, 136),
            500: Color.fromARGB(255, 0, 150, 136),
            600: Color.fromARGB(255, 0, 150, 136),
            700: Color.fromARGB(255, 0, 150, 136),
            800: Color.fromARGB(255, 0, 150, 136),
            900: Color.fromARGB(255, 0, 150, 136),
          },
        ),
        appBarTheme: const AppBarTheme(color: Colors.teal),
        typography: Typography.material2018(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'Phone Checker App',
    );
  }
}
