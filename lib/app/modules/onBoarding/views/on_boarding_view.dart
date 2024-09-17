import 'package:emarates_bd/app/routes/app_routes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/on_boarding_model.dart';
import '../controller/on_boarding_controller.dart';

class OnBoardingView extends GetView<onBoardingController> {
  @override
  Widget build(BuildContext context) {
    Get.put(onBoardingController());
    return GetBuilder<onBoardingController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Get.theme.primaryColor,
          bottomSheet: Container(
            color: Get.theme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: controller.currentIndex != 0
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.spaceAround,
                children: [
                  if (controller.currentIndex != 0)
                    TextButton(
                      onPressed: () {
                        controller.previousPage();
                      },
                      child: Text(
                        "Previous".tr,
                        style:
                            TextStyle(color: Color(0xfffC09969), fontSize: 16),
                      ),
                    ),
                  SmoothPageIndicator(
                    controller: controller.pageController,
                    count: controller.listOnBoarding.length,
                    axisDirection: Axis.horizontal,
                    effect: ScrollingDotsEffect(
                        spacing: 10.0,
                        radius: 5.0,
                        dotWidth: 10.0,
                        dotHeight: 10.0,
                        strokeWidth: 1.5,
                        dotColor: Color(0xffC09969),
                        activeDotColor: Color(0xff1263AA)),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.sharedPrefServices.sharedPreferences!
                          .setBool("onBoarding", true)
                          .then((value) {
                        Get.offAllNamed(Routes.ROOT);
                      });
                    },
                    child: Text(
                      "Skip".tr,
                      style: TextStyle(color: Color(0xfffC09969), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: OrientationBuilder(builder: (context, orientation) {
            return Container(
              width: double.infinity,
              height: Get.height,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Opacity(
                    opacity: 0.3,
                    child: Container(
                      width: orientation == Orientation.landscape
                          ? 500
                          : double.infinity,
                      height: Get.height,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(
                          "assets/img/Group 9.png",
                        ),
                        fit: BoxFit.cover,
                      )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom:
                            orientation == Orientation.landscape ? 110 : 30),
                    child: SizedBox(
                      height: Get.height / 1.1,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: (index) {
                          controller.changePage(index);
                        },
                        itemBuilder: (context, index) {
                          return Center(
                              child: OnBoardingItem(
                                  controller.listOnBoarding[index],
                                  orientation,
                                  index));
                        },
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Positioned(
                    bottom: Get.height / 5,
                    child: GestureDetector(
                      onTap: () {
                        controller.nextPage();
                      },
                      child: Container(
                        width: 250,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xff1263AA),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Center(
                            child: Text(
                          controller.currentIndex ==
                                  controller.listOnBoarding.length - 1
                              ? "Start".tr
                              : "Next".tr,
                          style: TextStyle(
                              color: Get.theme.primaryColor, fontSize: 16.0),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class OnBoardingItem extends StatelessWidget {
  OnBoardingModel onBoardingModel;
  Orientation orientation;
  int index;

  OnBoardingItem(this.onBoardingModel, this.orientation, this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: index == 0 ? 25 : 0),
            child: Container(
              width: orientation == Orientation.landscape ? 120 : 180,
              height: orientation == Orientation.landscape ? 120 : 180,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(onBoardingModel.image!))),
            ),
          ),
          SizedBox(
            height: orientation == Orientation.landscape ? 20 : 50,
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: orientation == Orientation.landscape ? 0 : 50),
            child: Text(
              onBoardingModel.content!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff1263AA),
                fontSize: 17.0,
                height: 1.8,
              ),
            ),
          )
        ],
      ),
    );
  }
}
