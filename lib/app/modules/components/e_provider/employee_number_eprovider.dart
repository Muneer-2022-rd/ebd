import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/e_provider/controllers/e_provider_controller.dart';
import '../../e_provider/widgets/e_provider_til_widget.dart';

class EmployeeNumberEProvider extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    return EProviderTilWidget(
      conditionValue:
          controller.singleProviderModel.value.employeesNumber != 0 &&
              controller.singleProviderModel.value.employeesNumber != null,
      title: Text("Employee Number".tr,
          style: Get.textTheme.subtitle2!
              .copyWith(color: Get.theme.colorScheme.secondary)),
      content: Column(
        children: [
          Text(
            "${controller.singleProviderModel.value.employeesNumber}",
            style: TextStyle(fontSize: 15.0),
          ),
        ],
      ),
    );
  }
}
