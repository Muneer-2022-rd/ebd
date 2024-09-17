import 'package:get/get.dart';
import 'package:emarates_bd/app/services/sheardPrefServices.dart';

import '../../root/controllers/root_controller.dart';

class AccountController extends GetxController {
  SharedPrefServices sharedPrefServices = Get.find();
  @override
  void onInit() {
    Get.find<RootController>().getNotificationsCount();
    super.onInit();
  }
}
