import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/event_model.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class EventCarouselWidget extends GetWidget<HomeController> {
  final events = <Event>[].obs;
  @override
  Widget build(BuildContext context) {
    // print( controller.events.value.length);
    // print('event');

    controller.events.forEach((element) {
      // if(element.featured==true){
      //   events.add(element);
      //   print('events');
      //   print(element.title);
      // }
    });
    // print('events');
    // print(events);

/*    itemCount: controller.events.length,
    itemBuilder: (_, index) {

    var _event = controller.events.elementAt(index);*/

    return Container(
      height: 345,
      color: Get.theme.primaryColor,
      child: Obx(() {
        controller.events.forEach((element) {
          if (element.featured == true) {
            events.add(element);
            // print('events');
            // print(element.title);
          }
        });

        return ListView.builder(
            padding: EdgeInsets.only(bottom: 10),
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (_, index) {
              var _event = events.elementAt(index);
              // var _event = controller.events.elementAt(index);
              // print(index);
              return GestureDetector(
                onTap: () {
                  // Get.toNamed(Routes.E_SERVICE, arguments: {'eService': _event, 'heroTag': 'recommended_carousel'});
                  // Get.toNamed(Routes.CATEGORY, arguments: _category);
                  //  print(_event);
                  // Get.toNamed(Routes.EVENTS, arguments: _event);
                  Get.toNamed(Routes.EVENTS, arguments: {
                    'event': _event,
                    'heroTag': 'services_carousel'
                  });
                },
                child: Container(
                  width: 180,
                  margin: EdgeInsetsDirectional.only(
                      end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
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
                        tag: 'recommended_carousel' + _event.id!,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: _event.firstImageUrl,
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
                        height: 115,
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
                              _event.title ?? '',
                              maxLines: 2,
                              style: Get.textTheme.bodyText2?.merge(
                                  TextStyle(color: Get.theme.hintColor)),
                            ),
                            Text(
                              _event.place ?? '',
                              maxLines: 2,
                              style: Get.textTheme.bodyText1?.merge(
                                  TextStyle(color: Get.theme.hintColor)),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 1,
                              alignment: WrapAlignment.spaceBetween,
                              direction: Axis.horizontal,
                              children: [
                                Text(
                                  'Start From' ?? ''.tr,
                                  style: Get.textTheme.caption,
                                ),
                                Text(
                                  new intl.DateFormat("yyyy-MM-dd")
                                      .format(DateTime.parse(_event.from!)),
                                  style: Get.textTheme.bodyText2?.merge(
                                      TextStyle(
                                          color:
                                              Get.theme.colorScheme.secondary)),
                                ),
                              ],
                            )
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
