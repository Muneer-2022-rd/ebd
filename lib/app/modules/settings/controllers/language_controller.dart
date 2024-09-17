import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:emarates_bd/app/modules/settings/controllers/theme_mode_controller.dart';

import '../../../models/setting_model.dart';
import '../../../services/settings_service.dart';

class LanguageController extends GetxController {
  late GetStorage _box;

  final setting = Setting().obs;

  LanguageController() {
    _box = new GetStorage();
  }

  void updateLocale(value) async {
    if (value.contains('_')) {
      // en_US
      Get.updateLocale(
          Locale(value.split('_').elementAt(0), value.split('_').elementAt(1)));
    } else {
      // en

      Get.updateLocale(Locale(value));
    }
    await _box.write('language', value);
    Get.rootController.setTheme(Get.find<SettingsService>().getLightTheme());
  }
}
