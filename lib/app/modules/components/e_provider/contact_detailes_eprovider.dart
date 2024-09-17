import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/e_provider/controllers/e_provider_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/app_routes.dart';

class ContactDetailsEProvider extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      //   spacing: 5,
      children: [
        SizedBox(
          height: 5,
        ),
        if (controller.eProvider.value.mobileNumber!.length > 6)
          SizedBox(
            width: 100, // <-- Your width
            height: 44, // <-- Your height
            child: MaterialButton(
              onPressed: () async {
                // launch("tel:${controller.eProvider.value.mobileNumber}");
                // if (Get.find<AuthService>().isAuth) {
                await launch("tel: ${controller.eProvider.value.mobileNumber}");

                // }
                // else
                //   Get.showSnackbar(Ui.defaultSnackBar(message: "Register to make this feature available".tr));
              },
              height: 44,
              minWidth: 44,
              padding: EdgeInsets.all(8),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Color(0xffc09868),
              // child: Icon(
              //   Icons.phone_android_outlined,
              //   color: Get.theme.colorScheme.secondary,
              // ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //Center Column contents vertically,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //Center Column contents horizontally,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          'call mobile'.tr,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ]),
              // child: Text( "Call".tr, style: TextStyle(
              //   color: Get.theme.colorScheme.secondary,
              // ),
              // ),
              elevation: 0,
            ),
          ),
        SizedBox(
          height: 5,
        ),
        if (controller.eProvider.value.phoneNumber!.length > 6)
          SizedBox(
            width: 100, // <-- Your width
            height: 30, // <-- Your height
            child: MaterialButton(
              onPressed: () async {
                // if (Get.find<AuthService>().isAuth) {
                await launch("tel: ${controller.eProvider.value.phoneNumber}");

                // }
                // else
                //   Get.showSnackbar(Ui.defaultSnackBar(message: "Register to make this feature available".tr));
              },
              height: 44,
              minWidth: 44,
              padding: EdgeInsets.all(8),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Color(0xffc09868),
              // child: Icon(
              //   Icons.call_outlined,
              //   color: Get.theme.colorScheme.secondary,
              // ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //Center Column contents vertically,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //Center Column contents horizontally,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          'call phone'.tr,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ]),
              // child: Text(controller.eProvider.value.phone_description ?? "Call".tr, style: TextStyle(
              //   color: Get.theme.colorScheme.secondary,
              // ),
              // ),

              elevation: 0,
            ),
          ),
        SizedBox(
          height: 5,
        ),
        if (controller.eProvider.value.email != null ||
            controller.eProvider.value.email!.length > 0 ||
            controller.eProvider.value.email!.isNotEmpty)
          SizedBox(
            width: 100, // <-- Your width
            height: 30, // <-- Your height
            child: MaterialButton(
              onPressed: () {
                Get.toNamed(Routes.Mail,
                    arguments: {'provider': controller.eProvider.value});
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Color(0xffc09868),
              padding: EdgeInsets.all(8),
              height: 10,
              minWidth: 10,
              // child: Icon(
              //   Icons.chat_outlined,
              //   color: Get.theme.colorScheme.secondary,
              // ),

              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //Center Column contents vertically,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //Center Column contents horizontally,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          "Email".tr,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ]),

              // child: Text("Send a message".tr, style: TextStyle(
              //   color: Get.theme.colorScheme.secondary,
              // ),
              // ),
              elevation: 0,
            ),
          ),

        // MaterialButton(
        //   onPressed: () {
        //     controller.startChat();
        //   },
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //   color: Get.theme.colorScheme.secondary.withOpacity(0.2),
        //   padding: EdgeInsets.zero,
        //   height: 44,
        //   minWidth: 44,
        //   child: Icon(
        //     Icons.chat_outlined,
        //     color: Get.theme.colorScheme.secondary,
        //   ),
        //   elevation: 0,
        // ),
      ],
    );
  }
}
