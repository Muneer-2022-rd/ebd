import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';
import 'package:emarates_bd/app/modules/category/controllers/category_controller.dart';
import 'package:emarates_bd/app/modules/home/controllers/home_controller.dart';
import 'package:emarates_bd/app/modules/home/widgets/provider_list_item_widget.dart';

import '../../global_widgets/circular_loading_widget.dart';
import 'package:emarates_bd/app/modules/category/widgets/services_list_item_widget.dart';

class ProvidersListWidget extends GetView<CategoryController> {
  ProvidersListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print( 'providers...');
    // print( controller.providers.length);
    controller.getProviders();
    return Obx(() {
      if (controller.providers.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.providers.length,
          itemBuilder: ((_, index) {
            if (index == controller.providers.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                      // child: new Opacity(
                      //   opacity: controller.isLoading.value ? 1 : 0,
                      //   child: new CircularProgressIndicator(),
                      // ),
                      ),
                );
              });
            } else {
              var _provider = controller.providers.elementAt(index);
              return ProviderListItemWidget(provider: _provider);
            }
          }),
        );
      }
    });
  }
}
