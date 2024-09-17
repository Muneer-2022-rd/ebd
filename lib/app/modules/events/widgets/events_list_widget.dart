import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/event_model.dart';
import 'package:emarates_bd/app/modules/events/controllers/events_controller.dart';
import 'events_list_item_widget.dart';

class EventsListWidget extends GetView<EventsController> {
  EventsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      primary: false,
      shrinkWrap: true,
      itemCount: controller.eventsList.length,
      separatorBuilder: (context, index) {
        return SizedBox();
      },
      itemBuilder: ((_, index) {
        return EventsListItemWidget(
            event: EventsModel.fromJson(controller.eventsList[index]));
      }),
    );

    // });
  }
}
