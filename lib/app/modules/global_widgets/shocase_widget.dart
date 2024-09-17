import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/services/sheardPrefServices.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  const ShowCaseView(
      {Key? key,
      required this.globalKey,
      required this.title,
      required this.description,
      required this.child,
      this.shapeBorder = const CircleBorder()})
      : super(key: key);
  final GlobalKey globalKey;

  final String title;

  final String description;
  final Widget child;

  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) {
    SharedPrefServices sharedPrefServices = Get.find();
    return sharedPrefServices.sharedPreferences!.containsKey("click show case")
        ? SizedBox()
        : Showcase(
            key: globalKey,
            title: title,
            description: description,
            child: child,
            targetShapeBorder: shapeBorder,
          );
  }
}
