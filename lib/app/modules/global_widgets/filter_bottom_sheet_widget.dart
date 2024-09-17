/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/global_widgets/show_tost.dart';

import '../search/controllers/search_controller.dart';
import 'circular_loading_widget.dart';

class FilterBottomSheetWidget extends GetView<CustomSearchController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height - 90,
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.4),
              blurRadius: 30,
              offset: Offset(0, -30)),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: ListView(
              padding: EdgeInsets.only(top: 20, bottom: 15, left: 4, right: 4),
              children: [
                Obx(() {
                  // if (controller.categories.isEmpty) {
                  if (controller.cities.isEmpty) {
                    return CircularLoadingWidget(height: 100);
                  }
                  return ExpansionTile(
                    // title: Text("Categories".tr, style: Get.textTheme.bodyText2),
                    title: Text("Search  Method".tr,
                        style: Get.textTheme.bodyText2),
                    children: [
                      Obx(
                        () {
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.platform,
                            value: controller.isChecked.value,
                            onChanged: (value) {
                              controller.toggleSearchMethod(value!);
                            },
                            title: Text(
                              "Show Result In List".tr,
                              style: Get.textTheme.bodyText1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          );
                        },
                      ),
                      Obx(
                        () {
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.platform,
                            value: !controller.isChecked.value,
                            onChanged: (value) {
                              controller.toggleSearchMethod(value!);
                            },
                            title: Text(
                              "Show Results On Map".tr,
                              style: Get.textTheme.bodyText1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          );
                        },
                      ),
                    ],
                    initiallyExpanded: false,
                  );
                }),
                Obx(() {
                  // if (controller.categories.isEmpty) {
                  if (controller.cities.isEmpty) {
                    return CircularLoadingWidget(height: 100);
                  }
                  return ExpansionTile(
                    // title: Text("Categories".tr, style: Get.textTheme.bodyText2),
                    title: Text("Cities".tr, style: Get.textTheme.bodyText2),
                    children: List.generate(controller.cities.length, (index) {
                      // var _category = controller.categories.elementAt(index);
                      var _city = controller.cities.elementAt(index);
                      return Obx(() {
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.platform,
                          value: controller.selectedCity.contains(_city.id),
                          onChanged: (value) {
                            print(value);
                            controller.toggleCity(value!, _city);
                          },
                          title: Text(
                            _city.name!.tr,
                            style: Get.textTheme.bodyText1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 1,
                          ),
                        );
                      });
                    }),
                    initiallyExpanded: false,
                  );
                }),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 45),
            child: Row(
              children: [
                Expanded(
                    child: Text("Filter".tr, style: Get.textTheme.headline5)),
                MaterialButton(
                  onPressed: () async {
                    // controller.searchEServices(keywords: controller.textEditingController.text);
                    // controller.searchEProvidersByCities(keywords: controller.textEditingController.text);
                    if (controller.textEditingController.text.isNotEmpty) {
                      controller.searchProviders(isBannerSearch: true);
                      Get.back();
                    } else {
                      Get.back();
                      ShowToast.showToast(
                          ToastType.NORMAL,
                          "Please type the name of the company you want to search for"
                              .tr);
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary.withOpacity(0.15),
                  child: Text("Apply".tr, style: Get.textTheme.subtitle1),
                  elevation: 0,
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: 13, horizontal: (Get.width / 2) - 30),
            decoration: BoxDecoration(
              color: Get.theme.focusColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.focusColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
              //child: SizedBox(height: 1,),
            ),
          ),
        ],
      ),
    );
  }
}
