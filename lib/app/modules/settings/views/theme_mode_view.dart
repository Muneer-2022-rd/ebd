import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/routes/app_routes.dart';
import 'package:emarates_bd/common/helper.dart';

import '../../../../common/ui.dart';
import '../controllers/theme_mode_controller.dart';

class ThemeModeView extends GetView<ThemeModeController> {
  final bool hideAppBar;

  ThemeModeView({this.hideAppBar = false});
  @override
  Widget build(BuildContext context) {
    Get.put(ThemeModeController());
    return WillPopScope(
      onWillPop: Helper().onWillpop,
      child: Scaffold(
        appBar: hideAppBar
            ? PreferredSize(
                preferredSize: Size(0, 0),
                child: AppBar(
                  title: Text(
                    "".tr,
                    style: context.textTheme.headline6,
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                ),
              )
            : AppBar(
                title: Text(
                  "Theme Mode".tr,
                  style: context.textTheme.headline6,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios,
                      color: Get.theme.hintColor),
                  onPressed: () => Get.toNamed(Routes.ROOT),
                ),
                elevation: 0,
              ),
        body: ListView(
          primary: true,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(color: Get.theme.primaryColor),
              child: Column(
                children: [
                  RadioListTile(
                    value: ThemeMode.light,
                    groupValue: controller.selectedThemeMode.value,
                    onChanged: (value) {
                      controller.changeThemeMode(value!);
                    },
                    title:
                        Text("Light Theme".tr, style: Get.textTheme.bodyText2),
                  ),
                  RadioListTile(
                    value: ThemeMode.dark,
                    groupValue: controller.selectedThemeMode.value,
                    onChanged: (value) {
                      controller.changeThemeMode(value!);
//                      (context as Element).reassemble();
                    },
                    title:
                        Text("Dark Theme".tr, style: Get.textTheme.bodyText2),
                  ),
                  // RadioListTile(
                  //   value: ThemeMode.system,
                  //   groupValue: controller.selectedThemeMode.value,
                  //   onChanged: (value) {
                  //     controller.changeThemeMode(value);
                  //   },
                  //   title: Text("System Theme".tr, style: Get.textTheme.bodyText2),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
