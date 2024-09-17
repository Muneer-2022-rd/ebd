import 'dart:io';

import 'package:image_cropper/image_cropper.dart';

class AppImageCropper {
  static ImageCropper cropper = ImageCropper();
  static Future<File?> cropImage(
      File? file, int? maxWidth, int? maxHeight) async {
    if (file == null) return null;
    final croppedFile = await cropper.cropImage(
      sourcePath: file.path,
      cropStyle: CropStyle.rectangle,
      // aspectRatioPresets: [],
      aspectRatioPresets: [
        maxWidth == 500
            ? CropAspectRatioPreset.square
            // CropAspectRatioPreset.ratio3x2,
            // CropAspectRatioPreset.original,
            // CropAspectRatioPreset.ratio4x3,
            : CropAspectRatioPreset.ratio16x9
      ],
      compressQuality: 100,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }
}
  // Future example  () async {
  //               final file = await Picker.showPickImageDialog(
  //                 context,
  //                 onCardPrimary(),
  //               );
  //               if (file == null) return;
  //               HapticFeedback.lightImpact();
  //               await Future.delayed(Duration.zero);
  //               final image = await AppImageCropper.cropImage(file);
  //               if (image == null) return;
  //               // Api call
  //             },

