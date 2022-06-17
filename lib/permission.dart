import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:checker_app_poc/utils/title_case.dart";

enum PermissionType { camera, microphone, location }

class PermissiongGateway {
  void _showAppSettingDialog(PermissionType type) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text("${type.name.toString().toTitleCase()} Permission"),
        content: Text(
            "Please Allow permission on ${type.name.toString().toTitleCase()} to continue"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text("Settings"),
            onPressed: () {
              AppSettings.openAppSettings().then((value) {
                Get.back();
              });
            },
          ),
          CupertinoDialogAction(
            child: const Text("Cancel"),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void checkCameraPermission(Function callback) async {
    PermissionStatus status = await Permission.camera.request();

    debugPrint('status: $status');

    if (status.isDenied) {
      Get.snackbar(
          "Camera Permission", "Please Allow permission on camera to continue", backgroundColor: Colors.teal, colorText: Colors.white);
    }

    if (status.isPermanentlyDenied) {
      _showAppSettingDialog(PermissionType.camera);
    }

    if (status.isGranted) {
      checkMicrophonePermission(callback);
    }
  }

  void checkMicrophonePermission(Function callback) async {
    PermissionStatus status = await Permission.microphone.request();

    debugPrint('status: $status');

    if (status.isDenied) {
      Get.snackbar("Microphone Permission",
          "Please Allow permission on microphone to continue", backgroundColor: Colors.teal, colorText: Colors.white);
    }

    if (status.isPermanentlyDenied) {
      _showAppSettingDialog(PermissionType.microphone);
    }

    if (status.isGranted) {
      callback();
    }
  }

  void checkLocationPermission(Function callback) async {
    PermissionStatus status = await Permission.location.request();

    debugPrint('status: $status');

    if (status.isDenied) {
      Get.snackbar("Location Permission",
          "Please Allow permission on location to continue", backgroundColor: Colors.teal, colorText: Colors.white);
    }

    if (status.isPermanentlyDenied) {
      _showAppSettingDialog(PermissionType.location);
    }

    if (status.isGranted) {
      callback();
    }
  }

  void checkBluetooth(Function callback) async {
    FlutterBlue bluetoothController = FlutterBlue.instance;

    if (await bluetoothController.isAvailable == false) {
      Get.snackbar("Bluetooth", "Device does not support bluetooth", backgroundColor: Colors.teal, colorText: Colors.white);
    } else {
      if (await bluetoothController.isOn) {
        callback();
      } else {
        Get.dialog(
          CupertinoAlertDialog(
            title: const Text("Bluetooth"),
            content: const Text("Please turn on bluetooth to continue"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text("Settings"),
                onPressed: () {
                  AppSettings.openBluetoothSettings().then((value) {
                    Get.back();
                  });
                },
              ),
              CupertinoDialogAction(
                child: const Text("Cancel"),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      }
    }
  }
}
