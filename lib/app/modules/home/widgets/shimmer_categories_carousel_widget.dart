import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';

class ShimmerCategoriesCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 15),
        child: ListView.builder(
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (_, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                    width: 100,
                    height: 500,
                    margin: EdgeInsetsDirectional.only(
                        end: 20, start: index == 0 ? 20 : 0),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: new BoxDecoration(
                      color: Get.theme.colorScheme.secondary.withOpacity(.5),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SizedBox()),
              );
            }));
  }
}
