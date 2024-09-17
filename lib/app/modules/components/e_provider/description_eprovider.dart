import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/e_provider/controllers/e_provider_controller.dart';
import 'package:emarates_bd/common/ui.dart';

import '../../e_provider/widgets/e_provider_til_widget.dart';

class DescriptionEProvider extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    return EProviderTilWidget(
      title: Text("Description".tr,
          style: Get.textTheme.subtitle2!
              .copyWith(color: Get.theme.colorScheme.secondary)),
      content: Ui.applyHtml(controller.eProvider.value.description ?? '',
          style: Get.textTheme.bodyText1),
      conditionValue: controller.eProvider.value.description!.length > 0,
    );
  }
}
