import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/global_widgets/custom_positioned.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';
import 'package:rive/rive.dart';
import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    Get.put(FireBaseMessagingService());
    controller.registerKey = GlobalKey<FormState>(debugLabel: "register");
    return GetBuilder<AuthController>(
      builder: (controller) {
        return WillPopScope(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "Register".tr,
                  style: Get.textTheme.headline6?.merge(TextStyle(
                      color: Get.isDarkMode
                          ? Get.theme.hintColor
                          : context.theme.primaryColor)),
                ),
                centerTitle: true,
                backgroundColor: Get.theme.colorScheme.secondary,
                automaticallyImplyLeading: false,
                elevation: 0,
                leading: controller.statusRequestNormalRegister ==
                            StatusRequest.loading ||
                        controller.loading.value
                    ? SizedBox()
                    : IconButton(
                        icon: new Icon(Icons.arrow_back_ios,
                            color: Get.theme.primaryColor),
                        onPressed: () => {Get.back()},
                      ),
              ),
              body: Form(
                key: controller.registerKey,
                child: ListView(
                  primary: true,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          height: 180,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Get.theme.colorScheme.secondary,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 50),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  _settings.appName!,
                                  style: Get.textTheme.headline6?.merge(
                                      TextStyle(
                                          color: Get.isDarkMode
                                              ? Get.theme.hintColor
                                              : Get.theme.primaryColor,
                                          fontSize: 24)),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Welcome to the best service provider system!"
                                      .tr,
                                  style: Get.textTheme.caption?.merge(TextStyle(
                                      color: Get.isDarkMode
                                          ? Get.theme.hintColor
                                          : Get.theme.primaryColor)),
                                  textAlign: TextAlign.center,
                                ),
                                // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: Ui.getBoxDecoration(
                            radius: 14,
                            border: Border.all(
                                width: 5, color: Get.theme.primaryColor),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.asset(
                              'assets/icon/icon.png',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (controller.loading.isTrue) {
                        return CircularLoadingWidget(height: 300);
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 15.0,
                            ),
//                            Text(
//                              "I AM".tr,
//                              style: TextStyle(
//                                  color: Get.isDarkMode
//                                      ? Get.theme.hintColor
//                                      : Get.theme.colorScheme.secondary,
//                                  fontSize: 15.0),
//                              textAlign: TextAlign.center,
//                            ),
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: [
//                                Text('Individual'.tr),
//                                Radio(
//                                  value: 1,
//                                  groupValue: controller.radioSelected,
//                                  activeColor: Get.theme.colorScheme.secondary,
//                                  onChanged: (value) {
//                                    controller
//                                        .changeRadioSelected(value as int);
//                                    print(controller.radioSelected);
//                                  },
//                                ),
//                                Text('Business Owner'.tr),
//                                Radio(
//                                  value: 2,
//                                  groupValue: controller.radioSelected,
//                                  activeColor: Get.theme.colorScheme.secondary,
//                                  onChanged: (value) {
//                                    controller
//                                        .changeRadioSelected(value as int);
//                                    print(controller.radioSelected);
//                                  },
//                                ),
//                              ],
//                            ),''
                            Text(
                              "I AM".tr,
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Get.theme.hintColor
                                      : Get.theme.colorScheme.secondary,
                                  fontSize: 15.0),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.changeUserType(1);
                                  },
                                  child: Container(
                                    width: 130.0,
                                    height: 45.0,
                                    decoration: BoxDecoration(
                                      color: controller.userType == 1
                                          ? Get.theme.colorScheme.secondary
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Individual".tr,
                                        style: TextStyle(
                                            color: controller.userType == 1
                                                ? Colors.white
                                                : Get.theme.colorScheme
                                                    .secondary),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.changeUserType(2);
                                  },
                                  child: Container(
                                    width: 130.0,
                                    height: 45.0,
                                    decoration: BoxDecoration(
                                      color: controller.userType == 2
                                          ? Get.theme.colorScheme.secondary
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Business Owner".tr,
                                        style: TextStyle(
                                            color: controller.userType == 2
                                                ? Colors.white
                                                : Get.theme.colorScheme
                                                    .secondary),
                                      ),
                                    ),
                                  ),
                                ),

//                                Text('Individual'.tr),
//                                Radio(
//                                  value: 1,
//                                  groupValue: radioSelected,
//                                  activeColor: Get.theme.colorScheme.secondary,
//                                  onChanged: (value) {
//                                    changeRadioSelected(value as int);
//                                    print(radioSelected);
//                                  },
//                                ),
//                                Text('Business Owner'.tr),
//                                Radio(
//                                  value: 2,
//                                  groupValue: radioSelected,
//                                  activeColor: Get.theme.colorScheme.secondary,
//                                  onChanged: (value) {
//                                    changeRadioSelected(value as int);
//                                    print(radioSelected);
//                                  },
//                                ),
                              ],
                            ),
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
                              onSaved: (input) => controller
                                  .currentUser.value.phoneNumber = input,
                              validator: (input) => input!.length < 13 ||
                                      input.length > 13
                                  ? "Should be (+) - country code - phone number with"
                                      .tr
                                  : null,
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
                                keyboardType: TextInputType.visiblePassword,
                                isLast: true,
                                isFirst: false,
                                suffixIcon: IconButton(
                                  onPressed: () async {
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
                            controller.userType == 1
                                ? TextFieldWidget(
                                    controller: controller.fileCv,
                                    labelText: "Choose Cv".tr,
                                    hintText: "Press To Choose Cv".tr,
                                    iconData: FontAwesomeIcons.file,
                                    isFirst: false,
                                    isLast: false,
                                    redOnly: true,
                                    onTap: () {
                                      controller.pickedPdfFile(context);
                                    },
                                  )
                                : SizedBox(),
                            controller.userType == 1
                                ? TextFieldWidget(
                                    controller: controller.jobTitle,
                                    labelText: "Jop title".tr,
                                    hintText:
                                        "Marketing manager, accountant ...".tr,
                                    iconData: Icons.account_box_outlined,
                                    isFirst: false,
                                    isLast: true,
                                  )
                                : SizedBox(),
                          ],
                        );
                      }
                    })
                  ],
                ),
              ),
              bottomNavigationBar: controller.statusRequestNormalRegister ==
                          StatusRequest.loading ||
                      controller.loading.value == true
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPositioned(
                          child: RiveAnimation.asset(
                            'assets/rive/check.riv',
                            fit: BoxFit.cover,
                            onInit: controller.onCheckRiveInit,
                          ),
                        ),
                        controller.isShowConfetti
                            ? CustomPositioned(
                                scale: 6,
                                child: RiveAnimation.asset(
                                  "assets/rive/confetti.riv",
                                  onInit: controller.onConfettiRiveInit,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            SizedBox(
                              width: Get.width,
                              child: BlockButtonWidget(
                                onPressed: () async {
                                  // controller.register();
                                  if (controller.userType == 1) {
                                    await controller.registerNormal();
                                  } else {
                                    await controller.checkAccount();
                                  }
//                          await FirebaseAuth.instance.verifyPhoneNumber(
//                            phoneNumber: controller.mobile.text,
//                            verificationCompleted: (PhoneAuthCredential credential) {},
//                            verificationFailed: (FirebaseAuthException e) {
//                              Get.defaultDialog(title: e.toString());
//                              print(e.toString());
//                            },
//                            codeSent: (String verificationId, int? resendToken) {
//                              Get.to(PhoneVerificationView(verificationId: verificationId,));
//                            },
//                            codeAutoRetrievalTimeout: (String verificationId) {},
//                          );
                                  // controller.checkAccount();

                                  //Get.offAllNamed(Routes.PHONE_VERIFICATION);
                                },
                                color: Get.theme.colorScheme.secondary,
                                text: Text(
                                  "Register".tr,
                                  style: Get.textTheme.headline6?.merge(
                                      TextStyle(
                                          color: Get.isDarkMode
                                              ? Get.theme.hintColor
                                              : Get.theme.primaryColor)),
                                ),
                              ).paddingOnly(
                                  top: 15, bottom: 5, right: 20, left: 20),
                            ),
                            // googleButtonRect(
                            //     "Sign in with Google".tr, Colors.white,Colors.black, FontAwesomeIcons.google,
                            //     onTap: () {
                            //       socialController.googleRegisterFullOperation();

                            //     }),
                            //
                            // socialButtonRect(
                            //     'Sign in with Facebook'.tr, Color(0xff4063ac),Colors.white, FontAwesomeIcons.facebookF,
                            //     onTap: () {
                            //       socialController.facebookLogin();
                            //     }),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.LOGIN);
                              },
                              child: Text(
                                "You already have an account?".tr,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.QUICK_LISTING);
                              },
                              child: Text(
                                "Quick Listing".tr,
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ).paddingOnly(bottom: 10),
                          ],
                        ),
                      ],
                    ),
            ),
            onWillPop: controller.statusRequestNormalRegister ==
                        StatusRequest.loading ||
                    controller.loading.value
                ? () async => false
                : Helper().onWillPop);
      },
    );
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
}
