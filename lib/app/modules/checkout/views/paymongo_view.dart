import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/paymongo_controller.dart';

class PayMongoViewWidget extends GetView<PayMongoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "PayMongo Payment".tr,
          style: Get.textTheme.headline6?.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Obx(() {
            return WebView(
                debuggingEnabled: true,
                initialUrl: controller.url.value,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController _con) {
                  controller.webView = _con;
                },
                onPageStarted: (String url) {
                  controller.url.value = url;
                  controller.showConfirmationIfSuccess();
                },
                onPageFinished: (String url) {
                  controller.progress.value = 1;
                });
          }),
          Obx(() {
            if (controller.progress.value < 1) {
              return SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.2),
                ),
              );
            } else {
              return SizedBox();
            }
          })
        ],
      ),
    );
  }
}
