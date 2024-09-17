import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:emarates_bd/app/modules/auth/views/busness_information_page3.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../../common/helper.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class BusinessInformationPage2 extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put(AuthController());
    controller.quickListingKey2 =
        GlobalKey<FormState>(debugLabel: "business_information step1");
    return WillPopScope(
        // onWillPop: Helper().onWillPop,
        child: Scaffold(
          body: Form(
            key: controller.quickListingKey2,
            child: ListView(
              physics: BouncingScrollPhysics(),
              primary: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldWidget(
                      labelText: "Facebook".tr,
                      onSaved: (value) {
                        controller.facebook.text = value!;
                      },
                      hintText: "www.facebook.com".tr,
                      controller: controller.facebook,
                      iconData: FontAwesomeIcons.facebook,
                      isFirst: true,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      labelText: "Twitter".tr,
                      onSaved: (value) {
                        controller.twitter.text = value!;
                      },
                      controller: controller.twitter,
                      hintText: "www.twitter.com".tr,
                      isFirst: false,
                      iconData: FontAwesomeIcons.twitter,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      labelText: "Instagram".tr,
                      onSaved: (value) {
                        controller.instagram.text = value!;
                      },
                      controller: controller.instagram,
                      hintText: "www.instgram.com".tr,
                      iconData: FontAwesomeIcons.instagram,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      labelText: "Whatsapp".tr,
                      onSaved: (value) {
                        controller.whatsapp.text = value!;
                      },
                      controller: controller.whatsapp,
                      hintText: "www.Whatsapp.com".tr,
                      iconData: FontAwesomeIcons.whatsapp,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      labelText: "Linkedin".tr,
                      onSaved: (value) {
                        controller.linkedin.text = value!;
                      },
                      controller: controller.linkedin,
                      hintText: "www.Linkedin.com".tr,
                      iconData: FontAwesomeIcons.linkedin,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.snapchat,
                      onSaved: (value) {
                        controller.snapchat.text = value!;
                      },
                      labelText: "Snapchat".tr,
                      hintText: "www.Snapchat.com".tr,
                      iconData: FontAwesomeIcons.snapchat,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.pinterest,
                      onSaved: (value) {
                        controller.pinterest.text = value!;
                      },
                      labelText: "Pinterest".tr,
                      hintText: "www.Pinterest.com".tr,
                      iconData: FontAwesomeIcons.pinterest,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.email2,
                      onSaved: (value) {
                        controller.email2.text = value!;
                      },
                      labelText: "Email 2".tr,
                      hintText: "johndoe@gmail.com".tr,
                      iconData: Icons.email,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.website,
                      onSaved: (value) {
                        controller.website.text = value!;
                      },
                      labelText: "Website".tr,
                      hintText: "https://emiratesbd.ae".tr,
                      iconData: Icons.web,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.phone,
                      onSaved: (value) {
                        controller.phone.text = value!;
                      },
                      labelText: "Phone".tr,
                      hintText: "50 000 0000".tr,
                      iconData: Icons.phone,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.mobile,
                      onSaved: (value) {
                        controller.mobile.text = value!;
                      },
                      labelText: "Mobile".tr,
                      hintText: "+971 50 000 0000".tr,
                      iconData: Icons.email,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.fax,
                      onSaved: (value) {
                        controller.fax.text = value!;
                      },
                      labelText: "Fax".tr,
                      hintText: "+971 50 000 0000".tr,
                      iconData: FontAwesomeIcons.fax,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      labelText: "Postal Code".tr,
                      onSaved: (value) {
                        controller.postalCode.text = value!;
                      },
                      hintText: "00000",
                      controller: controller.postalCode,
                      iconData: FontAwesomeIcons.codepen,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.tollFreePhone,
                      onSaved: (value) {
                        controller.tollFreePhone.text = value!;
                      },
                      labelText: "Toll Free Phone".tr,
                      hintText: "+971 50 000 0000".tr,
                      iconData: Icons.phone,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.employeesNumber,
                      onSaved: (value) {
                        controller.employeesNumber.text = value!;
                      },
                      labelText: "Employees Number".tr,
                      hintText: "10 , 5".tr,
                      iconData: Icons.phone,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.managerName,
                      onSaved: (value) {
                        controller.managerName.text = value!;
                      },
                      labelText: "Manager Name".tr,
                      hintText: "jhon Doe".tr,
                      iconData: Icons.person,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.busnessName,
                      labelText: "Business Name".tr,
                      onSaved: (value) {
                        controller.busnessName.text = value!;
                      },
                      hintText: "Social Marketing ..".tr,
                      iconData: Icons.person,
                      isFirst: false,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      controller: controller.date,
                      onSaved: (value) {
                        controller.date.text = value!;
                      },
                      onTap: () {
                        controller.selectDateCompany(context);
                      },
                      labelText: "Establishment year".tr,
                      redOnly: true,
                      hintText: "mm/ddd/yyyy",
                      iconData: Icons.date_range,
                      isFirst: false,
                      isLast: true,
                    ),
                    TextFieldWidget(
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        controller.desc.text = value!;
                      },
                      controller: controller.desc,
                      labelText: "Description".tr,
                      validator: (input) => input!.length < 3
                          ? "Should be more than 3 characters".tr
                          : null,
                      isFirst: true,
                      isLast: false,
                    ),
                    SizedBox(
                      height: Get.height / 4,
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: Row(
            children: [
              Expanded(
                child: BlockButtonWidget(
                  onPressed: () {
                    Get.to(BusinessInformationPage3());
//                      busnessName: controller.busnessName.text,
//                      description: controller.desc.text,
//                      email2: controller.email2.text,
//                      empNumber: controller.employeesNumber.text,
//                      estYear: controller.date.text,
//                      facebook: controller.facebook.text,
//                      fax: controller.fax.text,
//                      instagram: controller.instagram.text,
//                      linkedin: controller.linkedin.text,
//                      managerName: controller.managerName.text,
//                      mobile: controller.managerName.text,
//                      phone: controller.phone.text,
//                      pinterest: controller.pinterest.text,
//                      postalCode: controller.postalCode.text,
//                      snapchat: controller.snapchat.text,
//                      tollFree: controller.tollFreePhone.text,
//                      twitter: controller.twitter.text,
//                      website: controller.website.text,
//                      whatsapp: controller.whatsapp.text,
                  },
                  color: Get.theme.colorScheme.secondary,
                  text: Text(
                    "Save & Continue".tr,
                    style: Get.textTheme.headline6?.merge(TextStyle(
                        color: Get.isDarkMode
                            ? Get.theme.hintColor
                            : Get.theme.primaryColor,
                        fontSize: 13.0)),
                  ),
                ).paddingOnly(top: 15, bottom: 5, left: 20.0, right: 10.0),
              ),
              Expanded(
                child: BlockButtonWidget(
                  onPressed: () {
                    if (!controller.sharedPrefServices.sharedPreferences!
                        .containsKey("auth")) {
                      if (controller.sharedPrefServices.sharedPreferences!
                          .containsKey("api_token")) {
                        controller.sharedPrefServices.sharedPreferences!
                            .remove("api_token");
                      }
                      if (controller.sharedPrefServices.sharedPreferences!
                          .containsKey("place_id")) {
                        controller.sharedPrefServices.sharedPreferences!
                            .remove("place_id");
                      }
                      Get.toNamed(Routes.ROOT);
                    } else {
                      Get.back();
                    }
                  },
                  color: Color(0xff5cb85c),
                  text: Text(
                    "Skip".tr,
                    style: Get.textTheme.headline6?.merge(TextStyle(
                        color: Get.isDarkMode
                            ? Get.theme.hintColor
                            : Get.theme.primaryColor,
                        fontSize: 13.0)),
                  ),
                ).paddingOnly(top: 15, bottom: 5, left: 10.0, right: 20.0),
              ),
            ],
          ),
        ),
        onWillPop: Helper().onWillPop);
  }

  static Widget googleButtonRect(title, color, color_text, icon,
      {Function? onTap}) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        height: 35,
        width: 230,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.all(Radius.circular(0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 0, right: 0.0),
              child: Image.asset(
                'assets/img/google_icon.png',
                width: 16,
                height: 20,
              ), //   <--- image
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(title,
                  style: TextStyle(
                      color: color_text,
                      fontSize: 11,
                      fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      ),
    );
  }

  static Widget socialButtonRect(title, color, color_text, icon,
      {Function? onTap}) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        height: 35,
        width: 230,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.all(Radius.circular(0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: color_text,
            ),
            Container(
              margin: EdgeInsets.only(left: 18),
              child: Text(title,
                  style: TextStyle(
                      color: color_text,
                      fontSize: 11,
                      fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      ),
    );
  }

  void setSelected(values) {
    controller.listCatIdSelected = values;

    print(values);
  }

  void citySetSelected(value) {
    controller.city_selected.value = value;
    print(value);
  }

//  String cityVal = 'Dubai';

  // List of items in our dropdown menu

  @override
  Widget category(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
            "Category",
            style: Get.textTheme.bodyText1,
            textAlign: TextAlign.start,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => MultiSelectBottomSheetField(
                  buttonIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  listType: MultiSelectListType.LIST,
                  initialChildSize: 0.7,
                  maxChildSize: 0.95,
                  confirmText: Text("Ok"),
                  cancelText: Text("Cancel"),
                  title: const Text(
                    "Categories",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ).paddingSymmetric(horizontal: 10.0),
                  buttonText: Text(
                    "Select Categories",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  items: controller.categories
                      .map((e) => MultiSelectItem(e, e.name!))
                      .toList(),
                  searchable: true,
                  validator: (values) {
                    if (values!.isEmpty) {
                      return "Categories is required";
                    }
                    return null;
                  },
                  onSaved: (values) async {
                    controller.listCatIdSelected =
                        await values!.map((e) => e).toList();
                    Get.log(
                        "Selected Categories :  ${controller.listCatIdSelected}");
                  },
                  onConfirm: (values) async {
                    controller.listCatIdSelected =
                        await values.map((e) => e).toList();
                  },
                  chipDisplay: MultiSelectChipDisplay(
                      scrollBar: HorizontalScrollBar(isAlwaysShown: true),
                      textStyle:
                          const TextStyle(fontSize: 12.0, color: Colors.blue),
                      chipColor: Colors.white,
                      onTap: (item) {
                        print("run");
                      }),
                  onSelectionChanged: (values) async {
                    print(values);
                    controller.listCatIdSelected =
                        await values.map((e) => e).toList();
                    log("Selected Categories :  ${controller.listCatIdSelected}");
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
