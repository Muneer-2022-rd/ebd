import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/category/widgets/shimmer_provider_list_widget.dart';
import 'package:emarates_bd/app/modules/cities/widgets/providers_list_widget.dart';
import 'package:emarates_bd/app/modules/global_widgets/header_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../controllers/city_controller.dart';

class CityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print('CityView providers length');
    // print( controller.eProviders.toList());

    return Scaffold(
      body: GetBuilder<CityController>(
        builder: (controller) {
          return SmartRefresher(
            enablePullUp: true,
            footer: ClassicFooter(
              loadingText: "Loading...".tr,
              noDataText: "No more data".tr,
            ),
            header: HeaderRefresh(),
            controller: controller.refreshController,
            onRefresh: () async {
              final result = await controller.getEProviderOfCity(
                  isRefresh: true, cityId: controller.city.value.id!);
              if (result == true) {
                controller.refreshController.refreshCompleted();
              } else {
                controller.refreshController.refreshFailed();
              }
            },
            onLoading: () async {
              final result = await controller.getEProviderOfCity(
                  isRefresh: false, cityId: controller.city.value.id!);
              if (result == true) {
                if (controller.currentPage > controller.totalPage) {
                  controller.refreshController.loadNoData();
                } else {
                  controller.refreshController.loadComplete();
                }
              } else {
                controller.refreshController.loadFailed();
              }
            },
            child: CustomScrollView(
              controller: controller.scrollController,
              shrinkWrap: false,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Get.theme.scaffoldBackgroundColor,
                  expandedHeight: 280,
                  elevation: 0.5,
                  primary: true,
                  pinned: true,
                  floating: true,
                  iconTheme: IconThemeData(color: Get.theme.primaryColor),
                  title: Text(
                    controller.city.value.name!,
                    style: Get.textTheme.headline5,
                    // style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back_ios,
                        color: Get.theme.primaryColor),
                    onPressed: () => {Get.back()},
                  ),
                  // bottom: HomeSearchBarWidget(),

                  flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Hero(
                            tag: controller.heroTag.value +
                                controller.city.value.id.toString(),
                            child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                // padding: EdgeInsets.only(top: 75, bottom: 115),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: controller.city.value.cover!,
                                  // imageUrl: controller.category.value.cover_img.url,
                                  // imageUrl: controller.category.value.image.url,
                                  placeholder: (context, url) => Image.asset(
                                      'assets/img/loading.gif',
                                      fit: BoxFit.fill),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error_outline),
                                )),
                          ),
                          // AddressWidget().paddingOnly(bottom: 75),
                        ],
                      )).marginOnly(bottom: 0),

                  //
                  // flexibleSpace: FlexibleSpaceBar(
                  //     collapseMode: CollapseMode.parallax,
                  //     background: Stack(
                  //       alignment: AlignmentDirectional.bottomCenter,
                  //       children: [
                  //         Container(
                  //           width: double.infinity,
                  //           padding: EdgeInsets.only(top: 75, bottom: 115),
                  //           decoration: new BoxDecoration(
                  //
                  //
                  //
                  //             // gradient: new LinearGradient(
                  //             //   //  colors: [controller.city.value.color.withOpacity(1), controller.category.value.color.withOpacity(0.2)],
                  //             //     begin: AlignmentDirectional.topStart,
                  //             //     //const FractionalOffset(1, 0),
                  //             //     end: AlignmentDirectional.bottomEnd,
                  //             //     stops: [0.1, 0.9],
                  //             //     tileMode: TileMode.clamp),
                  //             borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                  //           ),
                  //
                  //           child: ClipRRect(
                  //             borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                  //             child: CachedNetworkImage(
                  //               height: 180,
                  //               width: double.infinity,
                  //               fit: BoxFit.cover,
                  //               imageUrl: controller.city.value.firstImageUrl,
                  //               placeholder: (context, url) => Image.asset(
                  //                 'assets/img/loading.gif',
                  //                 fit: BoxFit.cover,
                  //                 width: double.infinity,
                  //                 height: 100,
                  //               ),
                  //               errorWidget: (context, url, error) => Icon(Icons.error_outline),
                  //             ),
                  //           ),
                  //
                  //           // child: (controller.city.value.images.first.url.toLowerCase().endsWith('.svg')
                  //           //     ? SvgPicture.network(
                  //           //   controller.city.value.images.first.url,
                  //           //   // color: controller.category.value.color,
                  //           // )
                  //           //     : CachedNetworkImage(
                  //           //   fit: BoxFit.fitHeight,
                  //           //   imageUrl: controller.city.value.images.first.url,
                  //           //   placeholder: (context, url) => Image.asset(
                  //           //     'assets/img/loading.gif',
                  //           //     fit: BoxFit.fitHeight,
                  //           //   ),
                  //           //   errorWidget: (context, url, error) => Icon(Icons.error_outline),
                  //           // )),
                  //         ),
                  //         // AddressWidget().paddingOnly(bottom: 75),
                  //       ],
                  //     )
                  //
                  // ).marginOnly(bottom: 42),
                ),
                SliverToBoxAdapter(
                  child: Wrap(
                    children: [
                      // Container(
                      //   height: 60,
                      //   child: ListView(
                      //       primary: false,
                      //       shrinkWrap: true,
                      //       scrollDirection: Axis.horizontal,
                      //       children: List.generate(controller.eServices.length, (index) {
                      //         var _filter = controller.eServices.elementAt(index);
                      //         return Obx(() {
                      //           return Padding(
                      //             // padding: const EdgeInsetsDirectional.only(start: 20),
                      //             child: RawChip(
                      //               elevation: 0,
                      //               label: Text(_filter.toString().tr),
                      //               // labelStyle: controller.isSelected(_filter) ? Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)) : Get.textTheme.bodyText2,
                      //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      //               backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
                      //               // selectedColor: controller.category.value.color,
                      //               // selected: controller.isSelected(_filter),
                      //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      //               showCheckmark: true,
                      //               checkmarkColor: Get.theme.primaryColor,
                      //               onSelected: (bool value) {
                      //                 // controller.toggleSelected(_filter);
                      //                 controller.loadEServicesOfCity(controller.city.value.id);
                      //               },
                      //             ),
                      //           );
                      //         });
                      //       })),
                      // ),
                      controller.providersCity.isNotEmpty
                          ? ProvidersListWidget()
                          : ShimmerProvidersListWidget(),
                      SizedBox(
                        height: 60.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
