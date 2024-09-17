import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/on_boarding_model.dart';
import 'package:emarates_bd/app/routes/app_routes.dart';
import 'package:emarates_bd/app/services/sheardPrefServices.dart';

class onBoardingController extends GetxController {
  int currentIndex = 0;

  PageController pageController = PageController();
  List<OnBoardingModel> listOnBoarding = [
    OnBoardingModel(
        "Gain a free presence online via the Emirates Business Directory".tr,
        "assets/img/1.png"),
    OnBoardingModel(
        "You can  interact,create your own events , display your complete portfolio and much more!"
            .tr,
        "assets/img/2.png"),
    OnBoardingModel(
        "Your first steps towards increasing your online begins with a few click sand is absolutely free."
            .tr,
        "assets/img/3.png"),
  ];
  SharedPrefServices sharedPrefServices = Get.find();

  changePage(int index) {
    currentIndex = index;
    update();
  }

  nextPage() {
    if (currentIndex == listOnBoarding.length - 1) {
      sharedPrefServices.sharedPreferences!
          .setBool("onBoarding", true)
          .then((value) {
        Get.offAllNamed(Routes.Clearfiy);
      });
    } else {
      pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  previousPage() {
    pageController.previousPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
