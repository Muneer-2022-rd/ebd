import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/onBoarding/controller/on_boarding_controller.dart';

class OnBoardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<onBoardingController>(
      () => onBoardingController(),
    );
  }
}
