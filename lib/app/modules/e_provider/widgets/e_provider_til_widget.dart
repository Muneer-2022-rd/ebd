/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';

import '../../../../common/ui.dart';

class EProviderTilWidget extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final bool conditionValue;
  final List<Widget>? actions;
  final double? horizontalPadding;

  const EProviderTilWidget(
      {Key? key,
      this.title,
      this.content,
      this.actions,
      this.horizontalPadding,
      this.conditionValue = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(conditionValue);
    return conditionValue
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding ?? 20, vertical: 15),
            decoration: Ui.getBoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: title!),
                    if (actions != null)
                      Wrap(
                        children: actions!,
                      )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding == 0 ? 20.0 : 0),
                  child: Divider(
                    height: 26,
                    thickness: 1.2,
                  ),
                ),
                content!,
              ],
            ),
          )
        : SizedBox();
  }
}
