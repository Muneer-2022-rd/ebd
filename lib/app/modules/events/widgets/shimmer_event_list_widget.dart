import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/events/controllers/events_controller.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../common/ui.dart';

class ShimmerEventsListWidget extends GetView<EventsController> {
  ShimmerEventsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      primary: false,
      shrinkWrap: true,
      itemCount: 4,
      separatorBuilder: (context, index) {
        return SizedBox();
      },
      itemBuilder: ((_, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: Ui.getBoxDecoration(
              border: Border.all(color: Color(0xffc09868).withOpacity(.3))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          color:
                              Get.theme.colorScheme.secondary.withOpacity(.5),
                          child: SizedBox(),
                        ),
                      )),
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Opacity(
                  opacity: 1,
                  child: Wrap(
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                              child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 100.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Get.theme.colorScheme.secondary
                                    .withOpacity(.5),
                              ),
                              child: SizedBox(),
                            ),
                          )),
                          // BookingOptionsPopupMenuWidget(booking: _booking),
                        ],
                      ),
                      Divider(height: 8, thickness: 1),
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 150.0,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Get.theme.colorScheme.secondary
                                      .withOpacity(.5),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 150.0,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Get.theme.colorScheme.secondary
                                      .withOpacity(.5),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 8, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Expanded(
                          //   flex: 1,
                          //   child: Text(
                          //     "Total".tr,
                          //     maxLines: 1,
                          //     overflow: TextOverflow.fade,
                          //     softWrap: false,
                          //     style: Get.textTheme.bodyText1,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );

    // });
  }
}
