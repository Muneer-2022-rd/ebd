import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';
import 'package:emarates_bd/app/models/e_service_model.dart';
import 'package:emarates_bd/common/ui.dart';
import 'package:lottie/lottie.dart';
import '../controllers/mail_controller.dart';

class MailView extends GetView<MailController> {
  final bool hideAppBar;
  ProviderModel provider = Get.arguments['provider'];

  MailView({this.hideAppBar = false}) {}
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  var validate = false;

  void check_fields() {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      validate = true;
    } else
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Fill All Fields"));
  }

  @override
  Widget build(BuildContext context) {
    print('service.id');
    // print(provider.id ?? 'prov');
    // controller.profileForm = new GlobalKey<FormState>();
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
                title: Text(
                  "Email".tr,
                  style: context.textTheme.headline6,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios,
                      color: Get.theme.hintColor),
                  onPressed: () => Get.back(),
                ),
                elevation: 0,
              ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Get.theme.focusColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              GetBuilder<MailController>(
                builder: (controller) {
                  return Expanded(
                    child: controller.loading.value == true
                        ? Center(
                            child: Lottie.asset("assets/img/loading.json",
                                width: 170.0, height: 170.0),
                          )
                        : MaterialButton(
                            onPressed: () {
                              // check_fields();
                              if (nameController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  descriptionController.text.isNotEmpty) {
                                controller.sendMail(
                                    emailController.text,
                                    provider.id.toString(),
                                    descriptionController.text);
                              } else
                                Get.showSnackbar(Ui.ErrorSnackBar(
                                    message: "Fill All Fields".tr));
                            },
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Get.theme.colorScheme.secondary,
                            child: Text("Send Email".tr,
                                style: Get.textTheme.bodyText2?.merge(
                                    TextStyle(color: Get.theme.primaryColor))),
                            elevation: 0,
                            highlightElevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                          ),
                  );
                },
              )
              // SizedBox(width: 10),
              // MaterialButton(
              //   onPressed: () {
              //     controller.resetProfileForm();
              //   },
              //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //   color: Get.theme.hintColor.withOpacity(0.1),
              //   child: Text("Reset".tr, style: Get.textTheme.bodyText2),
              //   elevation: 0,
              //   highlightElevation: 0,
              //   hoverElevation: 0,
              //   focusElevation: 0,
              // ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          // key: controller.profileForm,
          child: ListView(
            primary: true,
            children: [
              // Text("Email details".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),

              // name
              name_field(context),
              // EMAIL
              email_field(context),
              // Phone
              phone_field(context),
              // description
              description_field(context),
            ],
          ),
        ));
  }

  Widget name_field(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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
            "Full Name".tr,
            style: Get.textTheme.bodyText1,
            textAlign: TextAlign.start,
          ),
          TextFormField(
            controller: nameController,
            style: Get.textTheme.bodyText2,
            textAlign: TextAlign.start,
            decoration: Ui.getInputDecoration(
              hintText: "John Doe".tr,
              iconData: Icons.person_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget email_field(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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
            "Email".tr,
            style: Get.textTheme.bodyText1,
            textAlign: TextAlign.start,
          ),
          TextFormField(
            controller: emailController,
            style: Get.textTheme.bodyText2,
            textAlign: TextAlign.start,
            decoration: Ui.getInputDecoration(
              hintText: "johndoe@gmail.com",
              iconData: Icons.alternate_email,
            ),
          ),
        ],
      ),
    );
  }

  Widget phone_field(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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
            "Phone number".tr,
            style: Get.textTheme.bodyText1,
            textAlign: TextAlign.start,
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: phoneController,
            style: Get.textTheme.bodyText2,
            textAlign: TextAlign.start,
            decoration: Ui.getInputDecoration(
              hintText: "+1 223 665 7896".tr,
              iconData: Icons.phone_android_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget description_field(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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
            "Short Description".tr,
            style: Get.textTheme.bodyText1,
            textAlign: TextAlign.start,
          ),
          TextFormField(
            controller: descriptionController,
            style: Get.textTheme.bodyText2,
            minLines: 1,
            maxLines: 5,
            // allow user to enter 5 line in textfield
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.start,
            decoration: Ui.getInputDecoration(
              hintText: "Your short description here".tr,
              iconData: Icons.article_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
