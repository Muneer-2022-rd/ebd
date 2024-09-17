import 'package:get/get.dart';

import '../models/slide_model.dart';
import '../providers/laravel_provider.dart';

class SliderRepository {
 late LaravelApiClient _laravelApiClient;

  SliderRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Slide>> getHomeSlider() {
    return _laravelApiClient.getHomeSlider();
  }
  Future<String> getHomeSlider2() {
    return _laravelApiClient.getHomeSlider2();
  }

  Future<List<Slide>> getHomeSlideFront() {
    return _laravelApiClient.getHomeSliderFront();
  }
}
