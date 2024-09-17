import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Picker {
  static Future<File?> showPickImageDialog(
      BuildContext context, TextStyle? style, int? width, int? height) async {
    return showDialog<File?>(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () async {
              await pickGallaryImage().then((value) {
                return Navigator.of(context).pop(value);
              });
            },
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    'Pick from gallary',
                    textAlign: TextAlign.center,
                    style: style!.copyWith(fontSize: 20),
                  ),
                  Text(
                    '($width x $height)',
                    textAlign: TextAlign.center,
                    style: style.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          TextButton(
            onPressed: () async {
              await takeImage().then((value) {
                Navigator.of(context).pop(value);
              });
            },
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    'Take image',
                    textAlign: TextAlign.center,
                    style: style.copyWith(fontSize: 20),
                  ),
                  Text(
                    '($width x $height)',
                    textAlign: TextAlign.center,
                    style: style.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Future<File?> pickGallaryImage() async {
    if (Platform.isIOS) {
      bool photosPermission = await Permission.photos.isGranted;
      if (!photosPermission) {
        await Permission.photos.request();
        return null;
      }
    }
    final xImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 600,
        maxWidth: 1080);
    if (xImage == null) return null;
    File newImage = File(xImage.path);
    return newImage;
  }

  static Future<File?> takeImage() async {
    if (Platform.isIOS) {
      bool camPermission = await Permission.camera.isGranted;
      if (!camPermission) {
        await Permission.camera.request();
        return null;
      }
    }
    final xImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 600,
        maxWidth: 600);
    if (xImage == null) return null;
    File newImage = File(xImage.path);
    return newImage;
  }
}
