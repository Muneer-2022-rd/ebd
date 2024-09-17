import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/auth/widgets/imageFiledAuth.dart';
import 'package:emarates_bd/app/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../../helper/image_cropper.dart';
import '../../../../helper/image_picker.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class BusinessInformationPage1 extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    controller.quickListingKey1 =
        GlobalKey<FormState>(debugLabel: "quick listing");
    if (controller.currentIndex == 0) {
      controller.get_categories();
      controller.getCities();
    }
    return GetBuilder<AuthController>(builder: (controller) {
      return Scaffold(
        body: Form(
          key: controller.quickListingKey1,
          child: ListView(
            physics: BouncingScrollPhysics(),
            primary: true,
            children: [
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    !Get.find<AuthService>().isAuth ||
                            Get.find<AuthService>().user.value.email!.isEmpty
                        ? Column(
                            children: [
                              TextFieldWidget(
                                controller: controller.fName,
                                labelText: "First Name".tr,
                                hintText: "John Doe".tr,
                                onSaved: (input) =>
                                    controller.currentUser.value.name = input,
                                validator: (input) => input!.length < 3
                                    ? "Should be more than 3 characters".tr
                                    : null,
                                iconData: Icons.person_outline,
                                onFieldSubmitted: (input) {
                                  controller.lastNameNode.requestFocus();
                                  return null;
                                },
                                isFirst: true,
                                isLast: false,
                              ),
                              TextFieldWidget(
                                controller: controller.lName,
                                focusNode: controller.lastNameNode,
                                labelText: "Last Name".tr,
                                hintText: "John Doe".tr,
                                onSaved: (input) =>
                                    controller.currentUser.value.lname = input,
                                validator: (input) => input!.length < 3
                                    ? "Should be more than 3 characters".tr
                                    : null,
                                iconData: Icons.person_outline,
                                onFieldSubmitted: (input) {
                                  controller.emailNode.requestFocus();
                                  return null;
                                },
                                isFirst: false,
                                isLast: false,
                              ),
                              TextFieldWidget(
                                controller: controller.email,
                                focusNode: controller.emailNode,
                                labelText: "Email Address".tr,
                                hintText: "johndoe@gmail.com".tr,
                                onSaved: (input) =>
                                    controller.currentUser.value.email = input,
                                validator: (input) => !input!.contains('@')
                                    ? "Should be a valid email".tr
                                    : null,
                                iconData: Icons.alternate_email,
                                onFieldSubmitted: (input) {
                                  controller.mobileNode.requestFocus();
                                  return null;
                                },
                                isFirst: false,
                                isLast: false,
                              ),
                              TextFieldWidget(
                                controller: controller.mobile,
                                focusNode: controller.mobileNode,
                                labelText: "Mobile".tr,
                                hintText: "+971 50 000 0000".tr,
                                validator: (input) => input!.length < 6
                                    ? "Should be a valid number".tr
                                    : null,
                                onSaved: (input) => controller
                                    .currentUser.value.phoneNumber = input,
                                iconData: Icons.phone_android,
                                onFieldSubmitted: (input) {
                                  controller.passwordNode.requestFocus();
                                  return null;
                                },
                                isFirst: false,
                                isLast: false,
                                keyboardType: TextInputType.phone,
                              ),
                              Obx(() {
                                return TextFieldWidget(
                                  controller: controller.password,
                                  focusNode: controller.passwordNode,
                                  labelText: "Password".tr,
                                  hintText: "••••••••••••".tr,
                                  onSaved: (input) => controller
                                      .currentUser.value.password = input,
                                  validator: (input) => input!.length < 6
                                      ? "Should be more than 6 characters".tr
                                      : null,
                                  obscureText: controller.hidePassword.value,
                                  iconData: Icons.lock_outline,
                                  onFieldSubmitted: (input) {
                                    return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  isLast: true,
                                  isFirst: false,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.hidePassword.value =
                                          !controller.hidePassword.value;
                                    },
                                    color: Theme.of(context).focusColor,
                                    icon: Icon(controller.hidePassword.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                  ),
                                );
                              }),
                            ],
                          )
                        : SizedBox(),
                    Center(
                      child: Column(
                        children: [
                          Get.find<AuthService>().isAuth
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 100,
                                )
                              : SizedBox(),
                          TextFieldWidget(
                            controller: controller.coName,
                            labelText: "Company Name".tr,
                            hintText: "Company Name".tr,
                            onSaved: (input) =>
                                controller.currentUser.value.coname = input,
                            validator: (input) => input!.length < 3
                                ? "Should be more than 3 characters".tr
                                : null,
                            iconData: Icons.business,
                            isFirst: true,
                            isLast: false,
                          ),
                          TextFieldWidget(
                            controller: controller.coAddress,
                            labelText: "Company Address".tr,
                            hintText: "Company Address".tr,
                            onSaved: (input) =>
                                controller.currentUser.value.coaddress = input,
                            validator: (input) => input!.length < 3
                                ? "Should be more than 3 characters".tr
                                : null,
                            iconData: FontAwesomeIcons.locationArrow,
                            isFirst: false,
                            isLast: false,
                          ),
                          TextFieldWidget(
                            controller: controller.coEmail,
                            labelText: "Company Email".tr,
                            hintText: "company@bussiness.com".tr,
                            onSaved: (input) =>
                                controller.currentUser.value.coemail = input,
                            validator: (input) => !input!.contains('@')
                                ? "Should be a valid email".tr
                                : null,
                            iconData: Icons.alternate_email,
                            isFirst: false,
                            isLast: false,
                          ),
                          category(context),
                          city(context),
                          ImageFiledAuth(
                            label: "Company Cover".tr,
                            imageFile: controller.coverCompany,
                            onTap: () async {
                              final pickedImage =
                                  await Picker.showPickImageDialog(context,
                                      Get.textTheme.bodyText1, 1600, 900);
                              if (pickedImage != null) {
                                final croppedImage =
                                    await AppImageCropper.cropImage(
                                        pickedImage, 1600, 900);
                                if (croppedImage != null) {
                                  controller.coverCompany = croppedImage;
                                  Get.find<AuthController>().update();
                                }
                              }
                            },
                          ),
                          ImageFiledAuth(
                            label: "Company Logo".tr,
                            imageFile: controller.logoCompany,
                            onTap: () async {
                              final pickedImage =
                                  await Picker.showPickImageDialog(context,
                                      Get.textTheme.bodyText1, 500, 500);
                              if (pickedImage != null) {
                                final croppedImage =
                                    await AppImageCropper.cropImage(
                                        pickedImage, 500, 500);
                                if (croppedImage != null) {
                                  controller.logoCompany = croppedImage;
                                  Get.find<AuthController>().update();
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: Get.size.height / 2.8,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              })
            ],
          ),
        ),
//        bottomNavigationBar: controller.statusRequestQuickListing ==
//            StatusRequest.loading
//            ? Center(
//          child: CircularProgressIndicator(),
//        )
//            : Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            Wrap(
//              crossAxisAlignment: WrapCrossAlignment.center,
//              direction: Axis.vertical,
//              children: [
//                SizedBox(
//                  width: Get.width,
//                  child: BlockButtonWidget(
//                    onPressed: () async {
//                      if (controller.sharedPrefServices.sharedPreferences!
//                          .containsKey("auth")){
//                        await controller.registerCompany();
//                      } else {
//                        await controller.registerQuickListing();
//                      }
//                    },
//                    color: Get.theme.colorScheme.secondary,
//                    text: Text(
//                      "Save & Continue".tr,
//                      style: Get.textTheme.headline6?.merge(TextStyle(
//                          color: Get.isDarkMode
//                              ? Get.theme.hintColor
//                              : Get.theme.primaryColor)),
//                    ),
//                  ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
//                ),
//              ],
//            ),
//          ],
//        ),
      );
    });
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

  // List of items in our dropdown menu

  @override
  Widget category(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
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
            "Category".tr,
            style: Get.textTheme.bodyText1,
            textAlign: TextAlign.start,
          ),
          controller.categories.isEmpty
              ? SizedBox(
                  height: 45.0,
                  child: CupertinoActivityIndicator(
                    radius: 10.0,
                    animating: true,
                  ),
                )
              : MultiSelectBottomSheetField(
                  buttonIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  listType: MultiSelectListType.LIST,
                  initialChildSize: 0.7,
                  maxChildSize: 0.95,
                  confirmText: Text("Ok".tr),
                  cancelText: Text("Cancel".tr),
                  title: Text(
                    "Categories".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ).paddingSymmetric(horizontal: 10.0),
                  buttonText: Text(
                    "Select Categories".tr,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  items: controller.categories
                      .map((e) => MultiSelectItem(e, e.name!))
                      .toList(),
                  searchable: true,
                  selectedColor: Get.theme.colorScheme.secondary,
                  selectedItemsTextStyle: TextStyle(
                      color: Get.isDarkMode
                          ? Get.theme.hintColor
                          : Colors.grey[600]),
                  itemsTextStyle: TextStyle(
                      color: Get.isDarkMode
                          ? Get.theme.hintColor
                          : Colors.grey[600]),
                  validator: (values) {
                    if (values == null || values.isEmpty) {
                      return "Categories is Required".tr;
                    }
                    print(values);
                    controller.listCatIdSelected = values;
                    return null;
                  },
                  onSaved: (values) {
                    controller.listCatIdSelected = values!;
                  },
                  onConfirm: (values) {
                    controller.listCatIdSelected = values;
                  },
                  chipDisplay: MultiSelectChipDisplay(
                      textStyle: TextStyle(
                          fontSize: 10.0,
                          color: Get.theme.colorScheme.secondary),
                      chipColor: Colors.grey[100],
                      onTap: (item) {
                        print(item);
                      }),
                  onSelectionChanged: (values) {
                    controller.listCatIdSelected = values;
                  },
                )
        ],
      ),
    );
  }

  @override
  Widget city(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: 0),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
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
            "City".tr,
            style: Get.textTheme.bodyText1,
            textAlign: TextAlign.start,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => DropdownButtonFormField(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey[500],
                  ).paddingSymmetric(horizontal: 10),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  // Initial Value
                  value: controller.city_selected.value,
                  hint: Text("Choose an City".tr),
                  // Down Arrow Icon

                  // Array list of items
                  items: controller.cities.map((items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Center(
                        child: Text(
                          items.name!.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Get.isDarkMode
                                  ? Get.theme.hintColor
                                  : Colors.grey[600]),
                        ),
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (newValue) {
                    // setState(() {
                    citySetSelected(newValue);
                    // cityVal = newValue;
                    // });
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
