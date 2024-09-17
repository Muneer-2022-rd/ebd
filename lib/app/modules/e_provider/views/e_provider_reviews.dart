import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/media_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/e_provider_controller.dart';
import '../widgets/availability_hour_item_widget.dart';
import '../widgets/e_provider_til_widget.dart';
import '../widgets/e_provider_title_bar_widget.dart';
import '../widgets/featured_carousel_widget.dart';
import '../widgets/review_item_widget.dart';

class EProviderReviews extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    // print(controller.eService.value.tags);
    return Obx(() {
      var _eProvider = controller.eProvider.value;

        return Scaffold(
          // bottomNavigationBar: buildBottomWidget(_eService),
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                // controller.refreshEProvider(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 90,
                    elevation: 0,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]),
                        child: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      ),
                      onPressed: () => {Get.back()},
                    ),

                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background:
                      // Obx(() {
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Text("Reviews & Ratings".tr, style: Get.textTheme.subtitle2),


                          // CachedNetworkImage(
                          //   width: double.infinity,
                          //   height: 350,
                          //   fit: BoxFit.cover,
                          //   imageUrl: _eService.pic,
                          //   placeholder: (context, url) => Image.asset(
                          //     'assets/img/loading.gif',
                          //     fit: BoxFit.cover,
                          //     width: double.infinity,
                          //   ),
                          //   errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          // ),


                          // buildCarouselSlider(_eService),
                          // buildCarouselBullets(_eService),
                        ],
                      ),
                      // }),
                    )
                        // .marginOnly(bottom: 50),
                  ),

                  // WelcomeWidget(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // SizedBox(height: 10),
                        EProviderTilWidget(
                          title:  Text("Reviews".tr, style: Get.textTheme.subtitle2),
                          // title: Text("Обзоры и рейтинги".tr, style: Get.textTheme.subtitle2),
                          content: Column(
                            children: [

                              Obx(() {

                                if (controller.reviews.isEmpty) {
                                  return CircularLoadingWidget(height: 100);
                                }
                                return ListView.separated(
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    print('review');
                                    print(controller.reviews.length);
                                    return ReviewItemWidget(review: controller.reviews.elementAt(index));

                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(height: 35, thickness: 1.3);

                                  },
                                  itemCount: controller.reviews.length,
                                  primary: false,
                                  shrinkWrap: true,
                                );

                              }),
                              //     if(showAllReviews ==true)
                              //     Obx(() {
                              // {
                              //         lim = controller.reviews.length;
                              //         print('lim');
                              //         print(lim);
                              //       }
                              //
                              //
                              //       if (controller.reviews.isEmpty) {
                              //         return CircularLoadingWidget(height: 100);
                              //       }
                              //       return ListView.separated(
                              //         padding: EdgeInsets.all(0),
                              //         itemBuilder: (context, index) {
                              //           print('review');
                              //           print(controller.reviews.length);
                              //           return ReviewItemWidget(review: controller.reviews.elementAt(index));
                              //
                              //         },
                              //         separatorBuilder: (context, index) {
                              //           return Divider(height: 35, thickness: 1.3);
                              //
                              //         },
                              //         // itemCount: lim,
                              //         itemCount: controller.reviews.length,
                              //         primary: false,
                              //         shrinkWrap: true,
                              //       );
                              //
                              //     }
                              //     ),




                            ],
                          ),
                          actions: [
                            // TODO view all reviews
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),

        );
      }
  );
  }

}
