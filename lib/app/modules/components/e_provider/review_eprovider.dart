import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/e_provider/controllers/e_provider_controller.dart';

import '../../../../common/Functions/stutsrequest.dart';
import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../e_provider/widgets/e_provider_til_widget.dart';
import '../../e_service/widgets/review_item_widget.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';

class ReviewEProvider extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    var _eProvider = controller.eProvider.value;
    return EProviderTilWidget(
      conditionValue: controller.statusRequest != StatusRequest.loading,
      title: Text("Reviews & Ratings".tr,
          style: Get.textTheme.subtitle2!
              .copyWith(color: Get.theme.colorScheme.secondary)),
      content: Column(
        children: [
          Text(_eProvider.rating.toString(), style: Get.textTheme.headline1),
          Wrap(
            children:
                Ui.getStarsList(_eProvider.rating?.toDouble() ?? 0.0, size: 32),
          ),
          new GestureDetector(
            onTap: () {
              if (!controller.reviews.isEmpty)
                Get.toNamed(Routes.PROVIDERSREVIEW);
            },
            child: new Text(
              // "Отзывы (%s)".trArgs([_eProvider.totalReviews.toString()]),
              "Reviews (%s)".trArgs([
                controller.singleProviderModel.value.reviews?.length
                        .toString() ??
                    '0'
              ]),
              style: Get.textTheme.caption,
            ).paddingOnly(top: 10),
          ),
          Divider(height: 35, thickness: 1.3),
          Obx(() {
            if (controller.singleProviderModel.value.reviews == null) {
              return CircularLoadingWidget(height: 100);
            }
            return ListView.separated(
              padding: EdgeInsets.all(0),
              itemBuilder: (context, index) {
                return ReviewItemWidget(
                    review: controller.singleProviderModel.value.reviews!
                        .elementAt(index));
              },
              separatorBuilder: (context, index) {
                return Divider(height: 35, thickness: 1.3);
              },
              itemCount:
                  controller.singleProviderModel.value.reviews!.length < 2
                      ? controller.singleProviderModel.value.reviews!.length
                      : 2,
              // itemCount: controller.reviews.length,
              primary: false,
              shrinkWrap: true,
            );
          }),
          SizedBox(height: 20),
          BlockButtonWidget(
              text: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Leave a Review".tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline6?.merge(
                        TextStyle(
                            color: Get.isDarkMode
                                ? Get.theme.hintColor
                                : Get.theme.primaryColor),
                      ),
                    ),
                  ),
                  Icon(Icons.star_outlined,
                      color: Get.isDarkMode
                          ? Get.theme.hintColor
                          : Get.theme.primaryColor,
                      size: 22)
                ],
              ),
              color: Get.theme.colorScheme.secondary,
              onPressed: () {
                if (Get.find<AuthService>().isAuth &&
                    Get.find<AuthService>().user.value.email!.isNotEmpty) {
                  Get.toNamed(Routes.RATINGProvider,
                      arguments: {'provider': _eProvider});
                } else {
                  Get.toNamed(Routes.LOGIN);
                }
              }),
        ],
      ),
      actions: [
        // TODO view all reviews
      ],
    );
  }
}
