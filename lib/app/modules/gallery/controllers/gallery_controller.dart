import 'package:get/get.dart';
import 'package:emarates_bd/app/models/gallery_model.dart';
import 'package:emarates_bd/app/models/singleProviderModel.dart';

import '../../../models/media_model.dart';

class GalleryController extends GetxController {
  final media = <Gallery>[].obs;
  final current = Gallery().obs;
  final heroTag = ''.obs;

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    media.assignAll(arguments['media'] as List<Gallery>);
    current.value = arguments['current'] as Gallery;
    heroTag.value = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
