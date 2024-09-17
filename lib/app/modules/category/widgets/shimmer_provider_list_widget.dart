import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../common/ui.dart';
import '../controllers/category_controller.dart';

class ShimmerProvidersListWidget extends GetView<CategoryController> {
  ShimmerProvidersListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      primary: false,
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: ((_, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: Ui.getBoxDecoration(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    //image
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Get.theme.colorScheme.secondary.withOpacity(.5),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: new Container(
                            padding: new EdgeInsets.only(right: 13.0),
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.secondary
                                  .withOpacity(.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 120.0,
                            height: 18.0,
                            child: SizedBox(),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 8, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: [],
                        ),
                      ],
                    ),
                    Row(
                      children: [
//                        Icon(
//                          Icons.location_city_outlined,
//                          size: 18,
//                          color: Get.theme.focusColor,
//                        ),
                        SizedBox(width: 5),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 18,
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.secondary
                                  .withOpacity(.5),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: SizedBox(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Icon(
                        //   Icons.place_outlined,
                        //   size: 18,
                        //   color: Get.theme.focusColor,
                        // ),
                        SizedBox(width: 5),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 12,
                            width: Get.width / 2.2,
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.secondary
                                  .withOpacity(.5),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
