import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

enum ToastType {
  ERROR,
  WARNING,
  SUCCESS,
  NORMAL,
}

class ShowToast {
  static showToast(ToastType toastType, String msg , {ToastGravity gravity = ToastGravity.BOTTOM}) {
    switch (toastType) {
      case ToastType.ERROR:
        {
          return Fluttertoast.showToast(
              msg: msg.tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: gravity,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red.withOpacity(.9),
              textColor: Colors.white,
              fontSize: 14.0);
        }
      case ToastType.WARNING:
        {
          return Fluttertoast.showToast(
              msg: msg.tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: gravity,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.orange.withOpacity(.9),
              textColor: Colors.white,
              fontSize: 12.0);
        }
        break;
      case ToastType.SUCCESS:
        {
          return Fluttertoast.showToast(
              msg: msg.tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: gravity,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green.withOpacity(.9),
              textColor: Colors.white,
              fontSize: 12.0);
        }
        // TODO: Handle this case.
        break;
      case ToastType.NORMAL:
        {
          return Fluttertoast.showToast(
              msg: msg.tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: gravity,
              timeInSecForIosWeb: 1,
              backgroundColor: Get.theme.colorScheme.secondary,
              textColor: Colors.white,
              fontSize: 12.0);
        }
        break;
      default:
        {
          return Fluttertoast.showToast(
              msg: msg.tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: gravity,
              timeInSecForIosWeb: 1,
              backgroundColor: Get.theme.colorScheme.secondary,
              textColor: Colors.white,
              fontSize: 12.0);
        }
    }
  }
}
