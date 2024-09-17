import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/components/e_provider/buttons_social_eprovider.dart';
import 'package:emarates_bd/app/modules/components/e_provider/contact_detailes_eprovider.dart';
import 'package:emarates_bd/app/modules/e_provider/controllers/e_provider_controller.dart';
import 'package:emarates_bd/common/ui.dart';

class ContactUsEProvider extends GetView<EProviderController> {
  ContactUsEProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("Связаться с нами".tr, style: Get.textTheme.subtitle2),
                Text("Contact us".tr,
                    style: Get.textTheme.subtitle2!
                        .copyWith(color: Get.theme.colorScheme.secondary)),
                // Text("Если у вас есть какие-либо вопросы!".tr, style: Get.textTheme.caption),
                Text("If your have any question!".tr,
                    style: Get.textTheme.caption),
                SizedBox(
                  height: 40,
                ),
                ButtonsSocialEProvider()
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: ContactDetailsEProvider(),
          )
        ],
      ),
    );
  }
}
