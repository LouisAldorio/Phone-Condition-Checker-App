import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Camera({Key? key, required this.cameras}) : super(key: key);

  static String routeName = '/camera';

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  late List<CameraDescription> _cameras;
  CameraController? cameraController;
  int _currentCameraIndex = 0;

  int camerasCount = 0;
  void updateCamera() {
    cameraController =
        CameraController(_cameras[_currentCameraIndex], ResolutionPreset.max);
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            debugPrint('User denied camera access.');
            Get.back();
            break;
          default:
            debugPrint('Handle other errors.');
            break;
        }
      }
    });
  }

  void permissionGateCheck() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isDenied) {
      Get.back();
      Get.snackbar(
          "Camera Permission", "Please Allow permission on camera to continue", backgroundColor: Colors.teal, colorText: Colors.white);
    }

    if (status.isPermanentlyDenied) {
      AppSettings.openAppSettings();
    }

    if (status.isGranted) {
      updateCamera();
    }
  }

  @override
  void initState() {
    _cameras = widget.cameras;
    setState(() {
      camerasCount = _cameras.length;
    });

    updateCamera();
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
    if (cameraController != null) {
      cameraController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null) {
      return Container();
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Phone has $camerasCount cameras'),
        leading: CupertinoNavigationBarBackButton(
          color: Theme.of(context).colorScheme.primary,
          previousPageTitle: "Home",
          onPressed: () => Get.back(),
        ),
      ),
      child: Scaffold(
        body: CameraPreview(cameraController!),
        bottomNavigationBar: _cameras.isEmpty
            ? null
            : BottomNavigationBar(
                items: _cameras.map((CameraDescription camera) {
                  return BottomNavigationBarItem(
                    icon: const Icon(Icons.camera),
                    label: "Camera ${camera.name}",
                  );
                }).toList(),
                currentIndex: _currentCameraIndex,
                onTap: (int index) {
                  setState(() {
                    _currentCameraIndex = index;
                    updateCamera();
                  });
                },
              ),
      ),
    );
  }
}
