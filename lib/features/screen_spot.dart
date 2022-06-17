import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ScreenSpot extends StatefulWidget {
  const ScreenSpot({Key? key}) : super(key: key);

  static String routeName = '/screen_spot';

  @override
  State<ScreenSpot> createState() => _ScreenSpotState();
}

class _ScreenSpotState extends State<ScreenSpot> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Screen Spot Testing'),
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
            children: [
              const Text(
                  'Slide Left or right to change the color of the screen.',
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              const Text(
                'The color of the screen will change depending on the direction of the swipe.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Press the back button after the checking is done.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              CupertinoButton.filled(
                  onPressed: () {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: [SystemUiOverlay.bottom]);
                    showGeneralDialog(
                      context: context,
                      barrierColor:
                          Colors.black12.withOpacity(0.6), // Background color
                      barrierDismissible: false,
                      barrierLabel: 'Dialog',
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (_, __, ___) {
                        return CarouselSlider(
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height,
                            viewportFraction: 1,
                          ),
                          items: [
                            Colors.white,
                            Colors.black,
                            Colors.red,
                            Colors.green,
                            Colors.blue
                          ].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: i),
                                  child: const Text(
                                    '',
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
                      },
                    ).then((value) {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                          overlays: [
                            SystemUiOverlay.bottom,
                            SystemUiOverlay.top,
                          ]);
                    });
                  },
                  child: const Text('Press Me to start testing!')),
            ],
          ),
        ),
      ),
    );
  }
}
