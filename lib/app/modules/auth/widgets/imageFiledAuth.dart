import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/auth/controllers/auth_controller.dart';

class ImageFiledAuth extends StatelessWidget {
  String label;
  File? imageFile;
  void Function()? onTap;
  ImageFiledAuth(
      {required this.label, required this.imageFile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
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
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    label,
                    style: Get.textTheme.bodyText1,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
          GetBuilder<AuthController>(builder: (controller) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 5,
                runSpacing: 8,
                children: [
                  if (imageFile == null)
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image(
                        image: AssetImage(
                          "assets/img/blank.jpg",
                        ),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (imageFile != null)
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        imageFile ?? File(""),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Get.theme.focusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.add_photo_alternate_outlined,
                          size: 42,
                          color: Get.theme.focusColor.withOpacity(0.4)),
                    ),
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
