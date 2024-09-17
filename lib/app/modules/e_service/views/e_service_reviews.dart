import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/auth_service.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/e_service_controller.dart';

import '../widgets/e_service_til_widget.dart';
import '../widgets/review_item_widget.dart';

class EServiceReviews extends GetView<EServiceController> {
  @override
  Widget build(BuildContext context) {
    // print(controller.eService.value.tags);





    return Obx(() {
      print('Get.find<AuthService>().user');
      print((Get.find<AuthService>().isAuth));
      var _eService = controller.eService.value;
      if(_eService.phone_description!.length ==0)
        _eService.phone_description="Call".tr;
      if(_eService.phone_description2!.length ==0)
        _eService.phone_description2="Call".tr;
      print('service desc');
      print( _eService.phone_description);
      print( _eService.phone_description2);
      print('service');
      // print( _eService.pic2.first);
      print( _eService.phone!.length);

      bool showAllReviews=false;
      var lim = 1;
      if (!_eService.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          // bottomNavigationBar: buildBottomWidget(_eService),
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshEService(showMessage: true);
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
//                  SliverToBoxAdapter(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: [
//                        // SizedBox(height: 10),
//                        EServiceTilWidget(
//                          title:  Text("Reviews".tr, style: Get.textTheme.subtitle2),
//                          // title: Text("Обзоры и рейтинги".tr, style: Get.textTheme.subtitle2),
//                          content: Column(
//                            children: [
//
//                              Obx(() {
//
//                                if (controller.reviews.isEmpty) {
//                                  return CircularLoadingWidget(height: 100);
//                                }
//                                return ListView.separated(
//                                  padding: EdgeInsets.all(0),
//                                  itemBuilder: (context, index) {
//                                    print('review');
//                                    print(controller.reviews.length);
//                                    return ReviewItemWidget(review: controller.reviews.elementAt(index));
//
//                                  },
//                                  separatorBuilder: (context, index) {
//                                    return Divider(height: 35, thickness: 1.3);
//
//                                  },
//                                  itemCount: controller.reviews.length,
//                                  primary: false,
//                                  shrinkWrap: true,
//                                );
//
//                              }),
//                              //     if(showAllReviews ==true)
//                              //     Obx(() {
//                              // {
//                              //         lim = controller.reviews.length;
//                              //         print('lim');
//                              //         print(lim);
//                              //       }
//                              //
//                              //
//                              //       if (controller.reviews.isEmpty) {
//                              //         return CircularLoadingWidget(height: 100);
//                              //       }
//                              //       return ListView.separated(
//                              //         padding: EdgeInsets.all(0),
//                              //         itemBuilder: (context, index) {
//                              //           print('review');
//                              //           print(controller.reviews.length);
//                              //           return ReviewItemWidget(review: controller.reviews.elementAt(index));
//                              //
//                              //         },
//                              //         separatorBuilder: (context, index) {
//                              //           return Divider(height: 35, thickness: 1.3);
//                              //
//                              //         },
//                              //         // itemCount: lim,
//                              //         itemCount: controller.reviews.length,
//                              //         primary: false,
//                              //         shrinkWrap: true,
//                              //       );
//                              //
//                              //     }
//                              //     ),
//
//
//
//
//                            ],
//                          ),
//                          actions: [
//                            // TODO view all reviews
//                          ],
//                        ),
//                      ],
//                    ),
//                  ),
                ],
              )),

        );
      }
    });
  }

}
