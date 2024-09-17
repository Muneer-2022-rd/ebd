import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/category/controllers/category_controller.dart';
import 'package:emarates_bd/app/modules/home/widgets/providers_list_widget.dart';
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/home_search_bar_widget.dart';

class ProvidersViewAll extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {
    // print('CategoryView services');

    // print('controller.category.value.cover_back');
    // print(controller.category.value.cover_back);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          controller.onInit();

          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              expandedHeight: 240,
              elevation: 0.5,
              primary: true,
              // pinned: true,
              floating: true,
              iconTheme: IconThemeData(color: Get.theme.primaryColor),
              // title: Text(
              //   "Favorites".tr,
              //   style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
              // ),
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
                  background: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 75),
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Colors.orange.withOpacity(1),
                            Colors.orange.withOpacity(0.2)
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
                    child: Text(
                      controller.needs.tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline6?.merge(TextStyle(
                          color: Get.theme.primaryColor, fontSize: 25)),
                    ),
                  )).marginOnly(bottom: 42),
            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  ProvidersListWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
