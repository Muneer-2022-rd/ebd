import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/events/controllers/events_controller.dart';
import 'package:emarates_bd/app/modules/events/widgets/events_list_widget.dart';
import 'package:emarates_bd/app/modules/events/widgets/shimmer_event_list_widget.dart';
import 'package:emarates_bd/app/modules/global_widgets/header_refresh.dart';
import 'package:emarates_bd/app/modules/global_widgets/home_search_bar_widget.dart';
import 'package:emarates_bd/app/modules/root/controllers/root_controller.dart';
import 'package:emarates_bd/common/helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EventsViews extends GetView<EventsController> {
  @override
  Widget build(BuildContext context) {
    controller.initScrollController();
    return Scaffold(
      body: GetBuilder<EventsController>(
        builder: (controller) {
          return WillPopScope(
              child: SmartRefresher(
                  controller: controller.refreshController,
                  enablePullUp: true,
                  footer: ClassicFooter(
                    loadingText: 'Loading...'.tr,
                    noDataText: 'No more data'.tr,
                  ),
                  header: HeaderRefresh(),
                  onRefresh: () async {
                    final result = await controller.getEvents(isRefresh: true);
                    if (result == true) {
                      controller.refreshController.refreshCompleted();
                    } else {
                      controller.refreshController.refreshFailed();
                    }
                  },
                  onLoading: () async {
                    final result = await controller.getEvents(isRefresh: false);
                    if (result == true) {
                      if (controller.currentPage > controller.totalPages) {
                        controller.refreshController.loadNoData();
                      } else {
                        controller.refreshController.loadComplete();
                      }
                    } else {
                      controller.refreshController.loadFailed();
                    }
                  },
                  child: CustomScrollView(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: false,
                    slivers: <Widget>[
                      SliverAppBar(
                        backgroundColor: Get.theme.scaffoldBackgroundColor,
                        expandedHeight: 240,
                        elevation: 0.5,
                        primary: true,
                        // pinned: true,
                        floating: true,
                        iconTheme: IconThemeData(color: Get.theme.primaryColor),
                        title: Text(
                          "Events".tr,
                          style: Get.textTheme.headline6
                              ?.merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        leading: new IconButton(
                          icon: new Icon(Icons.arrow_back_ios,
                              color: Get.theme.primaryColor),
                          onPressed: () {
                            Get.find<RootController>().changePageInRoot(0);
                          },
                        ),
                        bottom: HomeSearchBarWidget(),
                        flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            background: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 75),
                              decoration: new BoxDecoration(
                                gradient: new LinearGradient(
                                    colors: [
                                      Colors.blue.withOpacity(1),
                                      Colors.blue.withOpacity(0.2)
                                    ],
                                    begin: AlignmentDirectional.topStart,
                                    //const FractionalOffset(1, 0),
                                    end: AlignmentDirectional.bottomEnd,
                                    stops: [0.1, 0.9],
                                    tileMode: TileMode.clamp),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                              ),
                              child: Icon(Icons.event,
                                  size: 66, color: Get.theme.primaryColor),
                            )).marginOnly(bottom: 42),
                      ),

                      // Obx(() {
                      // return SliverAppBar(
                      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      //   expandedHeight: 120,
                      //   elevation: 0.5,
                      //   floating: false,
                      //   iconTheme: IconThemeData(color: Get.theme.primaryColor),
                      //   title: Text(
                      //     Get.find<SettingsService>().setting.value.appName,
                      //     style: Get.textTheme.headline6,
                      //   ),
                      //   centerTitle: true,
                      //   automaticallyImplyLeading: false,
                      //   leading: new IconButton(
                      //     icon: new Icon(Icons.sort, color: Colors.black87),
                      //     onPressed: () => {Scaffold.of(context).openDrawer()},
                      //   ),
                      //   // actions: [NotificationsButtonWidget()],
                      //   // bottom: controller.events.isEmpty
                      //   //     ? TabBarLoadingWidget()
                      //   //     : TabBarWidget(
                      //   //   tag: 'bookings',
                      //   //   initialSelectedId: controller.events.elementAt(0).id,
                      //     // tabs: List.generate(controller.events.length, (index) {
                      //     //   var _status = controller.events.elementAt(index);
                      //     //   return ChipWidget(
                      //     //     tag: 'bookings',
                      //     //     text: '_status.status',
                      //     //     id: _status.id,
                      //     //     onSelected: (id) {
                      //     //       controller.changeTab(id);
                      //     //     },
                      //     //   );
                      //     // }),
                      //   // ),
                      // );
                      // }),
                      SliverToBoxAdapter(
                        child: Wrap(
                          children: [
                            controller.eventsList.isNotEmpty
                                ? EventsListWidget()
                                : ShimmerEventsListWidget(),
                          ],
                        ),
                      ),
                    ],
                  )),
              onWillPop: Helper().onWillPop);
        },
      ),
      // body
    );
  }
}
