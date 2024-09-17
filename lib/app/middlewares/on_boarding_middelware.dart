import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/services/connectivity_checker_service.dart';
import 'package:emarates_bd/app/services/sheardPrefServices.dart';
import '../routes/app_routes.dart';

class OnBoardingMiddelware extends GetMiddleware {
  @override
  RouteSettings? redirect(route) {
    SharedPrefServices sharedPrefServices = Get.find();
    if (sharedPrefServices.sharedPreferences!.containsKey("onBoarding")) {
      return RouteSettings(name: Routes.ROOT);
    }
    return null;
  }
}
