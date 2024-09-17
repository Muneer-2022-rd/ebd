import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/components/home/Footer_home.dart';
import 'package:emarates_bd/app/modules/components/home/menu_icon_home.dart';
import 'package:emarates_bd/app/modules/components/home/slider_home.dart';
import 'package:emarates_bd/app/modules/components/home/title_card_home.dart';
import 'package:emarates_bd/app/modules/components/home/title_home.dart';
import 'package:emarates_bd/app/modules/global_widgets/header_refresh.dart';
import 'package:emarates_bd/app/modules/global_widgets/shocase_widget.dart';
import 'package:emarates_bd/app/modules/home/widgets/featured_provider_widget.dart';
import 'package:emarates_bd/app/modules/home/widgets/provider_widget.dart';
import 'package:emarates_bd/app/modules/home/widgets/shimmer_categories_carousel_widget.dart';
import 'package:emarates_bd/app/modules/home/widgets/shimmer_cities_carousel_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/cities_carousel_widget.dart';
import '../widgets/shimmer_provider_widget.dart';

class Home2View extends StatefulWidget {
  @override
  State<Home2View> createState() => _Home2ViewState();
}

class _Home2ViewState extends State<Home2View> {
  HomeController controller = Get.put(HomeController());
  GlobalKey one = GlobalKey();
  GlobalKey tow = GlobalKey();
  GlobalKey three = GlobalKey();
  GlobalKey four = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ShowCaseWidget.of(context).startShowCase([one, tow, three, four]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Categories : ${controller.categories}");
    controller.initRefresh();
    return WillPopScope(
      onWillPop: controller.willPopExitApp,
      child: Scaffold(
        body: SmartRefresher(
            controller: controller.refreshController,
            onRefresh: () async {
              Get.find<LaravelApiClient>().forceRefresh();
              await controller.refreshHome(showMessage: false);
              Get.find<LaravelApiClient>().unForceRefresh();
            },
            header: HeaderRefresh(),
            child: CustomScrollView(
              controller: controller.scrollController,
              primary: false,
              shrinkWrap: false,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  expandedHeight: 320,
                  elevation: 0.5,
                  floating: true,
                  iconTheme:
                      IconThemeData(color: Theme.of(context).primaryColor),
                  title: TitleHome(),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: controller.sharedPrefServices.sharedPreferences!
                          .containsKey("click show case")
                      ? MenuIconHome(context)
                      : ShowCaseView(
                          globalKey: one,
                          title: "Menu".tr,
                          description: "Click here to see menu options".tr,
                          child: MenuIconHome(context)),
                  // actions: [NotificationsButtonWidget()],
                  bottom: HomeSearchBarWidget(
                    globalKeyOne: tow,
                    globalKeyTow: three,
                  ),
                  flexibleSpace: SliderHome().marginOnly(bottom: 42),
                ),
                SliverToBoxAdapter(
                  child: Wrap(
                    children: [
                      //Cities
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        child: TitleCardHome(
                          title: "Cities",
                          showViewAll: true,
                          onPressedViewAll: () {
                            Get.toNamed(Routes.all_cities);
                          },
                        ),
                      ),
                      Obx(() {
                        return controller.cities.isNotEmpty
                            ? CitiesCarouselWidget()
                            : ShimmerCitiesCarouselWidget();
                      }),
                      // AddressWidget(),
                      Padding(
                        padding: EdgeInsets.only(left: 20, bottom: 20),
                        child: TitleCardHome(
                          title: "Categories",
                          showViewAll: true,
                          onPressedViewAll: () {
                            Get.toNamed(Routes.CATEGORIES);
                          },
                        ),
                      ),
                      Obx(() {
                        return controller.categories.isNotEmpty
                            ? CategoriesCarouselWidget()
                            : ShimmerCategoriesCarouselWidget();
                      }),

                      Container(
                          color: Get.theme.primaryColor,
                          padding: EdgeInsets.only(left: 20),
                          child: TitleCardHome(
                            title: "Newly Added",
                            showViewAll: true,
                            onPressedViewAll: () {
                              Get.toNamed(Routes.all_newly_added);
                            },
                          )),
                      Obx(() {
                        return controller.providers.isNotEmpty
                            ? ProviderWidget()
                            : ShimmerProviderWidget();
                      }),

                      Container(
                        color: Get.theme.primaryColor,
                        padding: EdgeInsets.only(left: 20),
                        child: TitleCardHome(
                          title: "Featured Companies",
                          showViewAll: true,
                          onPressedViewAll: () {
                            Get.toNamed(Routes.all_featured);
                          },
                        ),
                      ),
                      Obx(() {
                        return controller.featuredProviders.isNotEmpty
                            ? FeaturedProviderWidget(
                                keyShowCase: four,
                              )
                            : ShimmerProviderWidget();
                      }),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: FooterHome(),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
