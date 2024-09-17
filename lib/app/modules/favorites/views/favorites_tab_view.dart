import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:emarates_bd/app/modules/favorites/widgets/favorites_list_widget.dart';
import '../../../providers/laravel_provider.dart';

class FavoritesTabView extends GetView<FavoritesController> {
  @override
  Widget build(BuildContext context) {
    controller.refreshFavorites(showMessage: true);

    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            // controller.refreshBookings(showMessage: true, statusId: controller.currentStatus.value);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            slivers: <Widget>[
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
                    FavoritesListWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
