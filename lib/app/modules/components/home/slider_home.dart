import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/home/controllers/home_controller.dart';

import '../../../models/slide_model.dart';
import '../../home/widgets/slide_item_widget.dart';

class SliderHome extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      background: Obx(() {
        return Stack(
          // alignment: controller.slider.isEmpty
          //     ? AlignmentDirectional.center
          //     : Ui.getAlignmentDirectional(controller.slider.elementAt(controller.currentSlide.value).textPosition),
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 7),
                height: 360,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  controller.currentSlide.value = index;
                },
              ),
              items: controller.slider.map((Slide slide) {
                return SlideItemWidget(slide: slide);
              }).toList(),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: controller.slider.map((Slide slide) {
                  return Container(
                    width: 20.0,
                    height: 5.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: controller.currentSlide.value ==
                                controller.slider.indexOf(slide)
                            ? Colors.white
                            : slide.indicatorColor!.withOpacity(0.1)),
                  );
                }).toList(),
              ),
            ),
            //
          ],
        );
      }),
    );
  }
}
