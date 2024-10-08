import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/services/auth_service.dart';
import '../../global_widgets/custom_bottom_nav_bar.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        drawer: Drawer(
          child: MainDrawerWidget(),
          elevation: 0,
        ),
        body: controller.currentPage,
        bottomNavigationBar: CustomBottomNavigationBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          itemColor: context.theme.colorScheme.secondary,
          currentIndex: controller.currentIndex.value,
          onChange: (index) {
            print(Get.find<AuthService>().user.value.apiToken);
            controller.changePage(index);
          },
          children: [
            CustomBottomNavigationItem(
              icon: Icons.home_outlined,
              label: "Home".tr,
            ),
            CustomBottomNavigationItem(
              icon: Icons.event,
              label: "Events".tr,
            ),
            // CustomBottomNavigationItem(
            //   icon: Icons.chat_outlined,
            //   label: "Chats".tr,
            // ),

            // CustomBottomNavigationItem(
            //   icon: Icons.favorite_outline,
            //   label: "Favorites".tr,
            //
            // ),
            CustomBottomNavigationItem(
              icon: Icons.person_outline,
              label: "Account".tr,
            ),
          ],
        ),
      );
    });
  }
}
