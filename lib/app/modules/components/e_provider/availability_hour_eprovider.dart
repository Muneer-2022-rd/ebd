import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/singleProviderModel.dart';
import 'package:emarates_bd/app/modules/e_provider/controllers/e_provider_controller.dart';
import 'package:emarates_bd/app/modules/e_provider/widgets/e_provider_til_widget.dart';

class AvailabilityHourEProvider extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    SingleProviderModel _eProvider = controller.singleProviderModel.value;
    controller.workingHourEProvider = {
      "Monday": _eProvider.workingHours?.mon?[0] ?? "",
      "Tuesday": _eProvider.workingHours?.tue?[0] ?? "",
      "Wednesday": _eProvider.workingHours?.wed?[0] ?? "",
      "Thursday": _eProvider.workingHours?.thu?[0] ?? "",
      "Sunday": _eProvider.workingHours?.sun?[0] ?? "",
    };
    var hourList = controller.workingHourEProvider.values.toList();
    var dyesList = controller.workingHourEProvider.keys.toList();
    return EProviderTilWidget(
      // title: Text("Доступность".tr, style: Get.textTheme.subtitle2),
      title: Text("Availability".tr,
          style: Get.textTheme.subtitle2!
              .copyWith(color: Get.theme.colorScheme.secondary)),
      conditionValue: controller.singleProviderModel.value.workingHours != null,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                ...List.generate(controller.workingHourEProvider.length,
                    (index) {
                  return Text(dyesList[index].tr.capitalizeFirst!)
                      .paddingSymmetric(vertical: Get.size.height / 50);
                }),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          Expanded(
            child: Column(
              children: List.generate(controller.workingHourEProvider.length,
                  (index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  width: 140,
                  child: Text(
                    Get.locale.toString() == 'ar'
                        ? controller.replaceFarsiNumber(hourList[index].tr)
                        : hourList[index].tr,
                    style: Get.textTheme.bodyText1?.copyWith(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    color: Get.theme.focusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                );
              }),
              //mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ),
        ],
      ),
      // actions: [
      //   if (_eProvider.available)
      //     Container(
      //       // child: Text("Доступность".tr,
      //       child: Text("Available".tr,
      //           maxLines: 1,
      //           style: Get.textTheme.bodyText2.merge(
      //             TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
      //           ),
      //           softWrap: false,
      //           textAlign: TextAlign.center,
      //           overflow: TextOverflow.fade),
      //       decoration: BoxDecoration(
      //         color: Colors.green.withOpacity(0.2),
      //         borderRadius: BorderRadius.circular(8),
      //       ),
      //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      //     ),
      //   if (!_eProvider.available)
      //     Container(
      //       child: Text("Offline".tr,
      //           // child: Text("Не в сети".tr,
      //           maxLines: 1,
      //           style: Get.textTheme.bodyText2.merge(
      //             TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
      //           ),
      //           softWrap: false,
      //           textAlign: TextAlign.center,
      //           overflow: TextOverflow.fade),
      //       decoration: BoxDecoration(
      //         color: Colors.grey.withOpacity(0.2),
      //         borderRadius: BorderRadius.circular(8),
      //       ),
      //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      //     ),
      // ],
    );
  }
}
