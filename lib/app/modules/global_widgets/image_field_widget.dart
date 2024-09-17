import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/global_widgets/show_tost.dart';
import 'package:emarates_bd/app/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/ui.dart';
import '../../models/media_model.dart';
import '../../repositories/upload_repository.dart';

class ImageFieldController extends GetxController {
  File? image;

  String uuid = '';
  final uploading = false.obs;
  late UploadRepository _uploadRepository;

  ImageFieldController() {
    _uploadRepository = new UploadRepository();
  }

  @override
  void onInit() {
    super.onInit();
  }

  void reset() {
    image = File("");
    uploading.value = false;
  }

  Future _deleteImageFromCache(String imageUrl) async {
    await CachedNetworkImage.evictFromCache(imageUrl);
  }

  Future<File> pickImage(
    ImageSource source,
    String field,
    ValueChanged<String> uploadCompleted,
  ) async {
    ImagePicker imagePicker = ImagePicker();
    await imagePicker
        .pickImage(source: source, imageQuality: 50)
        .then((value) async {
      image = File(value!.path);
      var decodedImage = await decodeImageFromList(image!.readAsBytesSync());
      update();
      if (image != null) {
        try {
          uploading.value = true;
          uuid = await _uploadRepository.image(image!);
          if (uuid.isNotEmpty) {
            Get.find<AuthService>().user.value.img = uuid;
            Get.find<AuthService>().user.value =
                Get.find<AuthService>().setUserData(img: uuid);
            _deleteImageFromCache(uuid);
            uploadCompleted(uuid);
            uploading.value = false;
            Get.showSnackbar(Ui.SuccessSnackBar(
                message: "change profile picture successfully".tr));
            update();
          }
        } catch (e) {
          Get.showSnackbar(Ui.ErrorSnackBar(message: "${e.toString()}".tr));
          uploading.value = false;
        }
      } else {
        uploading.value = false;
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "Please select an image file".tr));
      }
    });
    return image!;
  }

//  Future pickImage(ImageSource source, String field, ValueChanged<String> uploadCompleted) async {
//    ImagePicker imagePicker = ImagePicker();
//    Get.log("api token ${Get
//        .find<AuthService>()
//        .apiToken}");
//    XFile? pickedFile = await imagePicker.pickImage(source: source, imageQuality: 80);
//    File imageFile = File(pickedFile!.path);
//    Get.log("image file picked : ${imageFile.path.toString()}");
//    if (imageFile != null) {
//      try {
//        uploading.value = true;
//        await _uploadRepository.image(imageFile).then((newImage) {
//          Get.log("New Image From Api is : ${newImage.toString()}");
//          Get.find<AuthService>().user.value.img = newImage;
//          image = imageFile;
//          uploadCompleted(newImage);
//          uploading.value = false;
//          update();
//        });
//      } catch (e) {
//        uploading.value = false;
////        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//      }
//    } else {
//      uploading.value = false;
//      Get.showSnackbar(
//          Ui.ErrorSnackBar(message: "Please select an image file".tr));
//    }
//  }

  Future<void> deleteUploaded() async {
    if (uuid != null) {
      final done = await _uploadRepository.delete(uuid!);
      if (done) {
        uuid = '';
        image = null;
      }
    }
  }
}

class ImageFieldWidget extends StatelessWidget {
  ImageFieldWidget({
    Key? key,
    required this.label,
    required this.tag,
    required this.field,
    this.placeholder,
    this.img,
    this.buttonText,
    required this.uploadCompleted,
    this.initialImage,
    required this.reset,
  }) : super(key: key);

  final String label;
  final String? placeholder;
  final String? buttonText;
  final String tag;
  final String field;
  final String? img;
  final Media? initialImage;
  final ValueChanged<String> uploadCompleted;
  final ValueChanged<String> reset;
  bool? isLast;

  @override
  Widget build(BuildContext context) {
    Get.put(ImageFieldController());
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Get.theme.focusColor.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    label,
                    style: Get.textTheme.bodyText1,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              // MaterialButton(
              //   onPressed: () async {
              //     await controller.deleteUploaded();
              //     reset(controller.uuid);
              //   },
              //   shape: StadiumBorder(),
              //   color: Get.theme.focusColor.withOpacity(0.1),
              //   child: Text(buttonText ?? "Reset".tr, style: Get.textTheme.bodyText1),
              //   elevation: 0,
              //   hoverElevation: 0,
              //   focusElevation: 0,
              //   highlightElevation: 0,
              // ),
            ],
          ),
          GetBuilder<ImageFieldController>(builder: (controller) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 5,
                runSpacing: 8,
                children: [
                  if (controller.image == null)
                    ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          imageUrl: Get.find<AuthService>().user.value.img!,
                          placeholder: (context, url) => Image.asset(
                            'assets/img/loading.gif',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 100,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error_outline),
                        )),
                  if (controller.image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        controller.image ?? File(""),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  Obx(() {
                    if (controller.uploading.isTrue)
                      return buildLoader();
                    else
                      return GestureDetector(
                        onTap: () async {
                          await controller.pickImage(
                              ImageSource.gallery, field, uploadCompleted);
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Get.theme.focusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.add_photo_alternate_outlined,
                              size: 42,
                              color: Get.theme.focusColor.withOpacity(0.4)),
                        ),
                      );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildLoader() {
    return Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/img/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }

  Widget buildImage(File? image, String img) {
    final controller = Get.put(ImageFieldController(), tag: tag);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: [
          if (controller.image == null)
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                Get.find<AuthService>().user.value.img!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  return loadingProgress == null
                      ? child
                      : Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                        );
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Icon(Icons.error_outline);
                },
              ),
            ),
          if (controller.image != null)
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.file(
                image ?? File(""),
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          Obx(() {
            if (controller.uploading.isTrue)
              return buildLoader();
            else
              return GestureDetector(
                onTap: () async {
                  await controller.pickImage(
                      ImageSource.gallery, field, uploadCompleted);
                },
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Get.theme.focusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.add_photo_alternate_outlined,
                      size: 42, color: Get.theme.focusColor.withOpacity(0.4)),
                ),
              );
          }),
        ],
      ),
    );
  }
}
