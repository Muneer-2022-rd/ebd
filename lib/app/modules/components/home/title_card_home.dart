import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class TitleCardHome extends StatelessWidget {
  String title;
  VoidCallback? onPressedViewAll;
  bool showViewAll;
  TitleCardHome(
      {required this.title, this.onPressedViewAll, required this.showViewAll});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Categories
        Expanded(child: Text(title.tr, style: Get.textTheme.headline5)),
        if (showViewAll)
          MaterialButton(
            onPressed: onPressedViewAll,
            // shape: StadiumBorder(),
            // color: Get.theme.colorScheme.secondary.withOpacity(0.1),
            // View All
            child: Row(
              children: [
                Text("View All".tr, style: Get.textTheme.subtitle1),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Get.theme.hintColor,
                  size: Get.textTheme.subtitle1!.fontSize,
                ),
              ],
            ),
            elevation: 0,
          ),
      ],
    );
  }
}
