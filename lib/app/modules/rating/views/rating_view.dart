import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/e_service_model.dart';

import '../../../../common/ui.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/rating_controller.dart';

class RatingView extends GetView<RatingController> {
  // final String service_id;
  // RatingView(this.service_id);
  String? review;
  double rate = 1;
  @override
  Widget build(BuildContext context) {
    print('rating view');

    EService service = Get.arguments['service'];
    print(service);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leave a Review".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: ListView(
        primary: true,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 20),
        children: [
          Column(
            children: [
              Wrap(children: [
                Text("Hi,".tr),
                Text(
                  Get.find<AuthService>().user.value.name!,
                  style: Get.textTheme.bodyText2?.merge(
                      TextStyle(color: Get.theme.colorScheme.secondary)),
                )
              ]),
              SizedBox(height: 10),
              Text(
                "How do you feel this services?".tr,
                style: Get.textTheme.bodyText2,
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: Get.width,
            decoration: Ui.getBoxDecoration(),
            // child: Obx(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: service.firstpicUrl,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 160,
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  service.name!,
                  style: Get.textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "Click on the stars to rate this service".tr,
                  style: Get.textTheme.caption,
                ),
                SizedBox(height: 6),
                // Obx(() {
                // Obx(() {

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return InkWell(
                      onTap: () {
                        // print((index + 1).toDouble());
                        rate = (index + 1).toDouble();
                        // addReview();
                        controller.review.update((val) {
                          val!.rate = (index + 1).toDouble();
                        });
                        (context as Element).reassemble();
// addReview();
                      },
                      // child: index < rate
                      child: index < controller.review.value.rate!
                          ? Icon(Icons.star, size: 40, color: Color(0xFFFFB24D))
                          : Icon(Icons.star_border,
                              size: 40, color: Color(0xFFFFB24D)),
                    );
                  }),
                ),
                // }),

                SizedBox(height: 30)
              ],
            ),
            // )
          ),
          TextFieldWidget(
            labelText: "Write your review".tr,
            hintText: "Tell us somethings about this service".tr,
            iconData: Icons.description_outlined,
            onChanged: (text) {
              // controller.review.update((val) {
              //   val.review = text;
              // });
              review = text;
              // addReview();
            },
          ),
          BlockButtonWidget(
              text: Text(
                "Submit Review".tr,
                style: Get.textTheme.headline6
                    ?.merge(TextStyle(color: Get.theme.primaryColor)),
              ),
              color: Get.theme.colorScheme.secondary,
              onPressed: () {
                print('review');

                print(controller.review);
                controller.addReview2(rate, review!,
                    Get.find<AuthService>().user.value.id!, service.id!);
              }).marginSymmetric(vertical: 10, horizontal: 20)
        ],
      ),
    );
  }

  addReview() {
    print(review);
    print(rate);
    print(controller.review.value.rate);

    // setState(() {});
  }
}
