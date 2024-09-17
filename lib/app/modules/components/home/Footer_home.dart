import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../home/controllers/home_controller.dart';

class FooterHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration:
      BoxDecoration(color: Get.theme.primaryColor),
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                child: Text(
                  "What Can I Do On The Emirates Business Directory?"
                      .tr,
                  style: TextStyle(
                      color: Get.isDarkMode
                          ? Get.theme.hintColor
                          : Get.theme.colorScheme.secondary,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          GetBuilder<HomeController>(builder: (controller) {
            return Column(
              children: [
                Center(
                  child: ToggleSwitch(
                    minWidth: 90.0,
                    minHeight: 50.0,
                    fontSize: 14.0,
                    initialLabelIndex:
                    controller.currentIndexToggle,
                    activeBgColor: [
                      Get.isDarkMode
                          ? Colors.black12
                          : Colors.grey[100]!
                    ],
                    activeFgColor: Get.isDarkMode
                        ? Colors.white
                        : Get.theme.colorScheme.secondary,
                    changeOnTap: true,
                    inactiveBgColor: Get.isDarkMode
                        ? Colors.black.withOpacity(.1)
                        : Get.theme.primaryColor,
                    inactiveFgColor: Get.isDarkMode
                        ? Get.theme.hintColor
                        : Colors.grey[500],
                    totalSwitches: 4,
                    labels: [
                      'List'.tr,
                      'Claim'.tr,
                      'Advertise'.tr,
                      "Grow".tr
                    ],
                    onToggle: (index) {
                      print(index);
                      controller.onToggle(index!);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Text(
                      "${controller.bodyToggle[controller.currentIndexToggle].tr}",
                      style: Get.textTheme.headline6!
                          .copyWith(
                          color: Get.isDarkMode
                              ? Colors.white
                              : Colors.grey[600],
                          fontSize: 12,
                          height: 2,
                          fontWeight: FontWeight.w300)),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
