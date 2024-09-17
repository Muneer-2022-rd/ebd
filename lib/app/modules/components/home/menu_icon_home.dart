import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuIconHome extends StatelessWidget {
  BuildContext contextHome;
  MenuIconHome(this.contextHome);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: new Icon(Icons.sort,
          color: Get.isDarkMode
              ? Get.theme.hintColor
              : Get.theme.primaryColor),
      onPressed: () => {Scaffold.of(contextHome).openDrawer()},
    );
  }
}
