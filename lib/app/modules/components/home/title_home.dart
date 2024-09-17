import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/services/settings_service.dart';

class TitleHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
              width: 170,
              height: 70,
              child: Image(image: AssetImage("assets/img/EBDWlogo.png"))),
          Container(
            margin: EdgeInsets.only(bottom: 28),
            child: Text(
              Get.find<SettingsService>().setting.value.appName!,
              style: Get.textTheme.headline6!.copyWith(fontSize: 12).copyWith(
                  color: Get.isDarkMode
                      ? Get.theme.hintColor
                      : Colors.white.withOpacity(1)),
            ),
          ),
        ],
      ),
    );
  }
}
