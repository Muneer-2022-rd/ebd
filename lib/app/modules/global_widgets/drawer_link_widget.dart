/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../root/controllers/root_controller.dart';

class DrawerLinkWidget extends StatelessWidget {
  final Menu menu;
  final IconData? icon;
  final String? text;
  final ValueChanged<void>? onTap;
  final Menu selectedMenu;

  const DrawerLinkWidget({
    Key? key,
    required this.menu,
    required this.selectedMenu,
    this.icon,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5.0),
      child: InkWell(
        onTap: () {
          onTap!('');
        },
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              width: selectedMenu == menu ? Get.width / 1.3 : 0,
              height: 56,
              left: Get.locale.toString() == 'en' ? 0 : null,
              right: Get.locale.toString() == 'ar' ? 0 : null,
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            ListTile(
//            onTap: press,
              leading: SizedBox(
                height: 36,
                width: 36,
                child: Icon(
                  icon,
                  color:
                      selectedMenu == menu ? Colors.white : Get.theme.hintColor,
                ),
              ),
              title: Text(
                text!,
                style: TextStyle(
                    color: selectedMenu == menu
                        ? Colors.white
                        : Get.theme.hintColor,
                    fontSize: 13,
                    fontWeight: selectedMenu == menu
                        ? FontWeight.w600
                        : FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
