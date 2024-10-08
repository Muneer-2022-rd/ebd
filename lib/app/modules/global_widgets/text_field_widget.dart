/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    this.onSaved,
    this.contentPadding,
    this.onTap,
    this.onFieldSubmitted,
    this.redOnly,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.iconData,
    this.labelText,
    this.obscureText,
    this.suffixIcon,
    this.isFirst,
    this.isLast,
    this.style,
    this.textAlign,
    this.focusNode,
    this.autoFocus,
    this.suffix,
    this.marginBottom
  }) : super(key: key);

  final FormFieldSetter<String>? onSaved;
  final EdgeInsetsGeometry? contentPadding;

  final GestureTapCallback? onTap;
  final bool? redOnly;

  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final FormFieldValidator<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool? autoFocus ;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final TextAlign? textAlign;
  final String? labelText;
  final TextStyle? style;
  final IconData? iconData;
  final FocusNode? focusNode ;
  final bool? obscureText;
  final bool? isFirst;
  final bool? isLast;
  final double? marginBottom;
  final Widget? suffixIcon;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(
          left: 20, right: 20, top: topMargin, bottom: bottomMargin!),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: buildBorderRadius,
          boxShadow: [
            BoxShadow(
                color: Get.theme.focusColor.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText ?? "",
            style: Get.textTheme.bodyText1,
            textAlign: textAlign ?? TextAlign.start,
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            initialValue: initialValue,
            focusNode: focusNode,
            autofocus: autoFocus ?? false ,
            controller: controller,
            onTap: onTap ?? () {},
            readOnly: redOnly ?? false,
            maxLines: keyboardType == TextInputType.multiline ? null : 1,
            key: key,
            keyboardType: keyboardType ?? TextInputType.text,
            onSaved: onSaved,
            onChanged: onChanged,
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
            style: style ?? Get.textTheme.bodyText2,
            obscureText: obscureText ?? false,
            textAlign: textAlign ?? TextAlign.start,
            decoration: Ui.getInputDecoration(
              contentPadding: contentPadding,
              hintText: hintText ?? '',
              iconData: iconData,
              suffixIcon: suffixIcon,
              suffix: suffix,
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius get buildBorderRadius {
    if (isFirst != null && isFirst!) {
      return BorderRadius.vertical(top: Radius.circular(10));
    }
    if (isLast != null && isLast!) {
      return BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (isFirst != null && !isFirst! && isLast != null && !isLast!) {
      return BorderRadius.all(Radius.circular(0));
    }
    return BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((isFirst != null && isFirst!)) {
      return 20;
    } else if (isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((isLast != null && isLast!)) {
      return 10;
    } else if (isLast == null) {
      return marginBottom ?? 10 ;
    } else {
      return 0;
    }
  }
}
