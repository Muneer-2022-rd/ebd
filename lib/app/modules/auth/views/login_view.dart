import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/global_widgets/custom_positioned.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';
import 'package:rive/rive.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
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

class LoginView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    final socialController = Get.put(AuthController());
    Get.put(FireBaseMessagingService());
    controller.loginFormKey = GlobalKey<FormState>(debugLabel: "login");
    return GetBuilder<AuthController>(
      builder: (controller) => WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Login".tr,
                style: Get.textTheme.headline6?.merge(TextStyle(
                    color: Get.isDarkMode
                        ? Get.theme.hintColor
                        : context.theme.primaryColor)),
              ),
              centerTitle: true,
              backgroundColor: Get.theme.colorScheme.secondary,
              automaticallyImplyLeading: false,
              elevation: 0,
              leading: controller.statusRequestLogin == StatusRequest.loading
                  ? SizedBox()
                  : IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Get.theme.primaryColor),
                      onPressed: () {
                        Get.back();
                      },
                    ),
            ),
            body: controller.statusRequestLogin == StatusRequest.loading
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
                : Form(
                    key: controller.loginFormKey,
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
                                      color:
                                          Get.theme.focusColor.withOpacity(0.2),
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
                                      style: Get.textTheme.caption?.merge(
                                          TextStyle(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                          print(controller.currentUser.value.id);
                          if (controller.loading.isTrue &&
                              controller.currentUser.value.id != null)
                            return CircularLoadingWidget(height: 300);
                          else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFieldWidget(
                                  labelText: "Email Address".tr,
                                  hintText: "johndoe@gmail.com".tr,
                                  onSaved: (input) => controller
                                      .currentUser.value.email = input,
                                  controller: controller.email,
                                  onFieldSubmitted: (input) {
                                    controller.passwordNode.requestFocus();
                                    return null;
                                  },
                                  validator: (input) => !input!.contains('@')
                                      ? "Should be a valid email".tr
                                      : null,
                                  iconData: Icons.alternate_email,
                                  marginBottom: 0,
                                ),
                                Obx(() {
                                  return TextFieldWidget(
                                    labelText: "Password".tr,
                                    focusNode: controller.passwordNode,
                                    hintText: "••••••••••••".tr,
                                    controller: controller.password,
                                    onSaved: (input) => controller
                                        .currentUser.value.password = input,
                                    validator: (input) => input!.length < 6
                                        ? "Should be more than 6 characters".tr
                                        : null,
                                    obscureText: controller.hidePassword.value,
                                    iconData: Icons.lock_outline,
                                    keyboardType: TextInputType.visiblePassword,
                                    onFieldSubmitted: (input) {
                                      controller.login();
                                      return null;
                                    },
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(Routes.FORGOT_PASSWORD);
                                      },
                                      child: Text(
                                        "Forgot Password?".tr,
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                  ],
                                ).paddingSymmetric(horizontal: 20),
                                BlockButtonWidget(
                                  onPressed: () async {
                                    await controller.login();
                                  },
                                  color: Get.theme.colorScheme.secondary,
                                  text: Text(
                                    "Login".tr,
                                    style: Get.textTheme.headline6?.merge(
                                        TextStyle(
                                            color: Get.isDarkMode
                                                ? Get.theme.hintColor
                                                : Get.theme.primaryColor)),
                                  ),
                                ).paddingSymmetric(vertical: 8, horizontal: 20),

                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(Routes.REGISTER);
                                      },
                                      child: Text(
                                        "don't have account?".tr,
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                  ],
                                ),
                                // BlockButtonWidget(
                                //   onPressed: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(builder: (context) => MyApp()),
                                //     );
                                //     },
                                //   color: Get.theme.colorScheme.secondary,
                                //   text: Text(
                                //     "Login vk".tr,
                                //     style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                                //   ),
                                // ).paddingSymmetric(vertical: 10, horizontal: 20),

                                // Google login

                                // IconButton(
                                //   icon: const Icon(Icons.volume_up),
                                //   tooltip: 'Increase volume by 10',
                                //   onPressed: () {
                                //
                                //     }),
                                //
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // SignInButtonBuilder(
                                      //   icon:  FontAwesomeIcons.whatsapp,
                                      //   text: "Ignored for mini button",
                                      //   mini: true,
                                      //   onPressed: () {
                                      //     // _showButtonPressDialog(context, 'Email (mini)');
                                      //   },
                                      //   backgroundColor: Colors.cyan,
                                      // ),

                                      // SignInButton(
                                      //   Buttons.Facebook,
                                      //   text: 'Sign in with Facebook'.tr,
                                      //   // mini: true,
                                      //   onPressed: () {
                                      //     socialController.facebookLogin();
                                      //   },
                                      // ),

                                      // SignInButton(
                                      //   Buttons.Email,
                                      //   text: 'Sign in with Yandex'.tr,
                                      //   // mini: true,
                                      //   onPressed: () {
                                      //     // launchURL('https://kakdoma.online/admin/login/yandex');
                                      //         Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(builder: (context) => Yandex()),
                                      //         );
                                      //   },
                                      // ),

                                      // googleButtonRect(
                                      //     "Sign in with Google".tr,
                                      //     Colors.white,
                                      //     Colors.black,
                                      //     FontAwesomeIcons.google,
                                      //     onTap: () async {
                                      //   await controller
                                      //       .googleRegisterFullOperation();
                                      // }),

                                      // googleButtonRect(
                                      //    "Sign in with Google".tr, Colors.white,Colors.black, FontAwesomeIcons.google,
                                      //     onTap: () {
                                      //       socialController.googleRegisterFullOperation();

                                      //     }),

//                                          socialButtonRect(
//                                              'Sign in with Facebook'.tr,
//                                              Color(0xff4063ac),
//                                              Colors.white,
//                                              FontAwesomeIcons.facebookF,
//                                              onTap: () async {
//                                            socialController.facebookLogin();
//                                          }),
//
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 20.0),
                                      //   child: SocialLoginButton(
                                      //     borderRadius: 10.0,
                                      //     fontSize:
                                      //         Get.locale.toString() == "ar"
                                      //             ? 12.0
                                      //             : 14,
                                      //     height: 40.0,
                                      //     text: "Sign in with Google".tr,
                                      //     buttonType:
                                      //         SocialLoginButtonType.google,
                                      //     onPressed: () async {
                                      //       await socialController
                                      //           .googleRegisterFullOperation();
                                      //     },
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: 20.0,
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 20.0),
                                      //   child: SocialLoginButton(
                                      //     borderRadius: 10.0,
                                      //     height: 40.0,
                                      //     fontSize:
                                      //         Get.locale.toString() == "ar"
                                      //             ? 12.0
                                      //             : 14,
                                      //     text: "Sign in with Facebook".tr,
                                      //     buttonType:
                                      //         SocialLoginButtonType.facebook,
                                      //     onPressed: () {
                                      //       socialController
                                      //           .facebookLoginFullOperation();
                                      //     },
                                      //   ),
                                      // ),

                                      // if(Platform.isIOS)
                                      // SizedBox(
                                      //   height: 20.0,
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 20.0),
                                      //   child: SocialLoginButton(
                                      //     borderRadius: 10.0,
                                      //     height: 40.0,
                                      //     fontSize:
                                      //         Get.locale.toString() == "ar"
                                      //             ? 12.0
                                      //             : 14,
                                      //     text: "Sign in with Apple".tr,
                                      //     buttonType:
                                      //         SocialLoginButtonType.appleBlack,
                                      //     onPressed: () {
                                      //       socialController
                                      //           .appleRegister();
                                      //     },
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: 20.0,
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                      ],
                    ),
                  ),
          ),
          onWillPop: controller.statusRequestLogin == StatusRequest.loading
              ? () async => false
              : Helper().onWillPop),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Widget socialButtonCircle(color, icon, {iconColor, Function? onTap}) {
    return InkWell(
      onTap: () {
        // onTap!();
      },
      child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Icon(
            icon,
            color: iconColor,
          )), //
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

//  launchURL(String url) async {
//    if (await canLaunch(url)) {
//      await launch(url, forceWebView: true);
//
//      socialController.YandexLogin();
//      Timer(const Duration(seconds: 10), () async {
//        await closeWebView();
//      });
//    } else {
//      throw 'Could not launch $url';
//    }
//  }
}
