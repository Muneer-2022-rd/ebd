import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HeaderRefresh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  WaterDropHeader(
      waterDropColor: Get.theme.colorScheme.secondary,
      failed: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Icon(Icons.close , color: Colors.grey[500],),
            SizedBox(width: 10.0,),
            Text("Refresh failed".tr),
          ],
        ),
      ),
      complete: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Icon(Icons.check , color: Colors.grey[500],),
            SizedBox(width: 10.0,),
            Text("Refresh Complete".tr),
          ],
        ),
      ),
    );
  }
}
