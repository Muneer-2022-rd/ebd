import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/global_widgets/block_button_widget.dart';
import 'package:emarates_bd/app/modules/global_widgets/show_tost.dart';
import '../controllers/auth_controller.dart';

class QuickListingView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async => controller.loading.value ? false : true,
        child: PreferredSize(
          preferredSize: Size.fromHeight(400),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                controller.titleQuickListing[controller.currentIndex].tr,
                style: Get.textTheme.headline6?.merge(TextStyle(
                    color: Get.isDarkMode
                        ? Get.theme.hintColor
                        : context.theme.primaryColor)),
              ),
              centerTitle: true,
              backgroundColor: Get.theme.colorScheme.secondary,
              automaticallyImplyLeading: false,
              elevation: 0,
              leading: controller.loading.value
                  ? SizedBox()
                  : IconButton(
                      icon: new Icon(Icons.arrow_back_ios,
                          color: Get.theme.primaryColor),
                      onPressed: () => {controller.skipContentInformation()},
                    ),
            ),
            body: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: Stepper(
                        controlsBuilder:
                            (BuildContext context, ControlsDetails controls) {
                          return const SizedBox.shrink();
                        },
                        elevation: 0.0,
                        type: StepperType.horizontal,
                        currentStep: controller.currentIndex,
                        onStepTapped: (step) {
                          ShowToast.showToast(
                              ToastType.NORMAL,
                              "Complete Information then press on Continue Button"
                                  .tr,
                              gravity: ToastGravity.CENTER);
                        },
                        steps: [
                          Step(
                            title: Text("Step".tr + " 1"),
                            content: SizedBox(),
                            isActive: controller.currentIndex > 0,
                          ),
                          Step(
                              title: Text("Step".tr + " 2"),
                              content: SizedBox(),
                              isActive: controller.currentIndex > 1),
                          Step(
                              title: Text("Step".tr + " 3"),
                              content: SizedBox(),
                              isActive: controller.currentIndex > 2),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.size.height,
                      width: Get.size.width,
                      child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller.pageController,
                        itemBuilder: (context, index) {
                          return controller.pages[index];
                        },
                        itemCount: controller.pages.length,
                        onPageChanged: (index) {
                          controller.changeIndexPage(index);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: BlockButtonWidget(
                      onPressed: controller.loading.value
                          ? null
                          : () async {
                              if (controller.currentIndex == 0) {
                                controller.sendDataBasicInformation();
                              } else if (controller.currentIndex == 1) {
                                controller.sendContentInformation();
                              } else {
                                controller.editQuickListing();
                              }
                            },
                      color: controller.loading.value
                          ? Colors.grey.withOpacity(.6)
                          : Get.theme.colorScheme.secondary,
                      text: controller.loading.value
                          ? Text(
                              "Loading..",
                              style: Get.textTheme.headline6?.merge(TextStyle(
                                  color: Get.isDarkMode
                                      ? Get.theme.hintColor
                                      : Get.theme.primaryColor)),
                            )
                          : Text(
                              controller.currentIndex == 2
                                  ? "Save"
                                  : "Continue".tr,
                              style: Get.textTheme.headline6?.merge(TextStyle(
                                  color: Get.isDarkMode
                                      ? Get.theme.hintColor
                                      : Get.theme.primaryColor)),
                            ),
                    ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                  ),
                  if (controller.currentIndex == 1)
                    Expanded(
                      child: BlockButtonWidget(
                        onPressed: controller.loading.value
                            ? null
                            : () async {
                                if (controller.currentIndex == 1) {
                                  controller.skipContentInformation();
                                }
                              },
                        color: Colors.green,
                        text: Text(
                          "Skip".tr,
                          style: Get.textTheme.headline6?.merge(TextStyle(
                              color: Get.isDarkMode
                                  ? Get.theme.hintColor
                                  : Get.theme.primaryColor)),
                        ),
                      ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  static Widget googleButtonRect(title, color, color_text, icon,
      {Function? onTap}) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        height: 35,
        width: 230,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.all(Radius.circular(0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 0, right: 0.0),
              child: Image.asset(
                'assets/img/google_icon.png',
                width: 16,
                height: 20,
              ), //   <--- image
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(title,
                  style: TextStyle(
                      color: color_text,
                      fontSize: 11,
                      fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      ),
    );
  }

  void citySetSelected(value) {
    controller.city_selected.value = value;
    print(value);
  }

//  String cityVal = 'Dubai';

// List of items in our dropdown menu
}
