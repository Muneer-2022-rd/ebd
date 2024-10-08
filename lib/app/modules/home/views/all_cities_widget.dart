import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class CitiesCarouselScreen extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 720,
      color: Get.theme.primaryColor,
      padding: EdgeInsets.only(left: 20),
      child: Obx(() {
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 10),
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.vertical,
            itemCount: controller.cities.length,
            itemBuilder: (_, index) {
              var _city = controller.cities.elementAt(index);
              // print(_city.cover);
              return GestureDetector(
                onTap: () {
                  print(_city);
                  Get.toNamed(Routes.CITY, arguments: _city);
                },
                child: Container(
                  width: 180,
                  margin: EdgeInsetsDirectional.only(
                      end: 20, start: index == 0 ? 0 : 0, top: 20, bottom: 10),
                  // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Get.theme.focusColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    //alignment: AlignmentDirectional.topStart,
                    children: [
                      Hero(
                        tag: 'city' + _city.id!,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: _city.cover!,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 100,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              _city.name!.tr +
                                  ' (' +
                                  _city.providersCount! +
                                  ')',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: Get.textTheme.bodyText2?.merge(
                                  TextStyle(color: Get.theme.hintColor)),
                            ),

                            // SizedBox(height: 10),
                            // Wrap(
                            //   spacing: 1,
                            //   alignment: WrapAlignment.spaceBetween,
                            //   direction: Axis.horizontal,
                            //   children: [
                            //     Text(
                            //       _city.bio ?? ''.tr,
                            //       style: Get.textTheme.caption,
                            //     ),
                            //
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
