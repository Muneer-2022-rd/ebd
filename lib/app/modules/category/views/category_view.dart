import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/category/widgets/providers_list_widget.dart';
import 'package:emarates_bd/app/modules/global_widgets/header_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../global_widgets/home_search_bar_widget.dart';
import '../controllers/category_controller.dart';
import '../widgets/shimmer_provider_list_widget.dart';

class CategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('CategoryView services');

    // print('controller.category.value.cover_back');
    return Scaffold(body: GetBuilder<CategoryController>(builder: (controller) {
      return SmartRefresher(
        enablePullUp: true,
        footer: ClassicFooter(
          loadingText: 'Loading ...'.tr,
          noDataText: 'No more data'.tr,
        ),
        header: HeaderRefresh(),
        controller: controller.refreshController,
        onRefresh: () async {
          final result = await controller.getEProviderOfCategoryWithOutFilter(
              isRefresh: true, catId: controller.category.value.id!);
          if (result == true) {
            controller.refreshController.refreshCompleted();
          } else {
            controller.refreshController.refreshFailed();
          }
          // Get.find<LaravelApiClient>().forceRefresh();
          // controller.refreshEServices(showMessage: true);
          // Get.find<LaravelApiClient>().unForceRefresh();
          // controller.getProvidersWithCategory(controller.category.value.id, filter: controller.selected.value);
        },
        onLoading: () async {
          final result = await controller.getEProviderOfCategoryWithOutFilter(
              isRefresh: false, catId: controller.category.value.id!);
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
              // pinned: true,
              floating: true,
              iconTheme: IconThemeData(color: Get.theme.primaryColor),
              title: Text(
                controller.category.value.name!,
                style: Get.textTheme.headline6?.merge(TextStyle(
                    color: Get.isDarkMode
                        ? Get.theme.hintColor
                        : Get.theme.primaryColor)),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios,
                    color: Get.theme.primaryColor),
                onPressed: () => {Get.back()},
              ),
              bottom: HomeSearchBarWidget(),
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Container(
                          width: double.infinity,
                          height: double.infinity,

                          // padding: EdgeInsets.only(top: 75, bottom: 115),

                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                                colors: [
                                  Get.theme.colorScheme.primary.withOpacity(1),
                                  Get.theme.colorScheme.secondary
                                ],
                                begin: AlignmentDirectional.topStart,
                                //const FractionalOffset(1, 0),
                                end: AlignmentDirectional.bottomEnd,
                                stops: [0.1, 0.9],
                                tileMode: TileMode.clamp),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                          ),
                          child:
                              // (controller.category.value.image.url.toLowerCase().endsWith('.svg')
                              //     ? SvgPicture.network(
                              //         controller.category.value.svg,
                              //         // controller.category.value.cover_img.url,
                              //         // controller.category.value.svg,
                              //         // color: controller.category.value.color,
                              //     fit: BoxFit.fill
                              //       )
                              //     :
                              CachedNetworkImage(
                            // fit: BoxFit.fitHeight,
                            width: 30,
                            height: 30,
                            imageUrl: controller.category.value.svg!,
                            // imageUrl: controller.category.value.cover_img.url,
                            // imageUrl: controller.category.value.image.url,
                            placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.fill),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          )),
                      // ),

                      // AddressWidget().paddingOnly(bottom: 75),
                    ],
                  )).marginOnly(bottom: 42),
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
                  //       children: List.generate(CategoryFilter.values.length, (index) {
                  //         var _filter = CategoryFilter.values.elementAt(index);
                  //         return Obx(() {
                  //           return Padding(
                  //             padding: const EdgeInsetsDirectional.only(start: 20),
                  //             child: RawChip(
                  //               elevation: 0,
                  //               label: Text(_filter.toString().tr),
                  //               labelStyle: controller.isSelected(_filter) ? Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)) : Get.textTheme.bodyText2,
                  //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  //               backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
                  //               selectedColor: controller.category.value.color,
                  //               selected: controller.isSelected(_filter),
                  //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  //               showCheckmark: true,
                  //               checkmarkColor: Get.theme.primaryColor,
                  //               onSelected: (bool value) {
                  //                 controller.toggleSelected(_filter);
                  //                 controller.loadEServicesOfCategory(controller.category.value.id, filter: controller.selected.value);
                  //               },
                  //             ),
                  //           );
                  //         });
                  //       })),
                  // ),

                  controller.providersCategory.isNotEmpty
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
    }));
  }
}
