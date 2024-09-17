import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/auth/controllers/auth_controller.dart';
import 'package:emarates_bd/common/class/curd.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud());
    Get.lazyPut(() => AuthController());
  }
}
