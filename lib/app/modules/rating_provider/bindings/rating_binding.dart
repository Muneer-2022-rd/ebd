import 'package:get/get.dart';

import '../controllers/rating_controller.dart';

class RatingProviderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingProviderController>(
      () => RatingProviderController(),
    );
  }
}
