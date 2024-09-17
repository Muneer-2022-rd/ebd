import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/category/controllers/category_controller.dart';

import '../../global_widgets/circular_loading_widget.dart';
import 'package:emarates_bd/app/modules/category/widgets/services_list_item_widget.dart';

class OfferAndServicesListWidget extends GetView<CategoryController> {
  OfferAndServicesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('offer and services...');
    print(controller.offerServices.length);
    return Obx(() {
      if (controller.offerServices.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.offerServices.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.offerServices.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _service = controller.offerServices.elementAt(index);
              return ServicesListItemWidget(service: _service);
            }
          }),
        );
      }
    });
  }
}
