/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountLinkWidget extends StatelessWidget {
  final Icon? icon;
  final Widget? text;
  final ValueChanged<void>? onTap;

  const AccountLinkWidget({
    this.icon,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!('');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            icon!,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              width: 1,
              height: 24,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
            Expanded(
              child: text ?? Text(""),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Get.theme.focusColor,
            ),
          ],
        ),
      ),
    );
  }
}
