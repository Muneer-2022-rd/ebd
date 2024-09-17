import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/home/widgets/providers_carousel_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/home_controller.dart';

class FeaturedCategoriesWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.featured.isEmpty) {
        return CircularLoadingWidget(height: 300);
      }
      return Column(
        children: List.generate(controller.featured.length, (index) {
          var _category = controller.featured.elementAt(index);
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(_category.name!,
                            style: Get.textTheme.headline5)),
                    // MaterialButton(
                    //   onPressed: () {
                    //     Get.toNamed(Routes.CATEGORY, arguments: _category);
                    //   },
                    //   shape: StadiumBorder(),
                    //   color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                    //   // View All
                    //   child: Text("View All".tr, style: Get.textTheme.subtitle1),
                    //   elevation: 0,
                    // ),
                  ],
                ),
              ),
              Obx(() {
                print('featuder cat priov');
                print(controller.featured.elementAt(index).eProviders!.length);
                // if (controller.featured.elementAt(index).eServices.isEmpty) {
                //   // Loading
                //   return Text('Loading...');
                // }

                if (controller.featured.elementAt(index).eProviders!.isEmpty) {
                  // Loading
                  return Text('Loading...');
                }
                return ProvidersCarouselWidget(
                    provider: controller.featured.elementAt(index).eProviders!);
              }),
            ],
          );
        }),
      );
    });
  }
}
