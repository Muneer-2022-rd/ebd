import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../providers/laravel_provider.dart';
import '../../cities/controllers/city_controller.dart';
import '../../components/home/title_card_home.dart';
import '../../components/home/title_home.dart';
import '../../global_widgets/header_refresh.dart';
import '../controllers/home_controller.dart';
import '../widgets/cities_carousel_widget.dart';
import '../widgets/shimmer_cities_carousel_widget.dart';
import 'all_cities_widget.dart';

class AllCities extends StatefulWidget {
  const AllCities({Key? key}) : super(key: key);

  @override
  State<AllCities> createState() => _AllCitiesState();
}

class _AllCitiesState extends State<AllCities> {
  HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          //   SmartRefresher(
          // controller: city_controller.refreshController,
          // onRefresh: () async {
          //   Get.find<LaravelApiClient>().forceRefresh();
          //   await city_controller.refreshEServices(showMessage: false);
          //   Get.find<LaravelApiClient>().unForceRefresh();
          // },
          // header: HeaderRefresh(),
          // child:
          CustomScrollView(
              controller: controller.scrollController,
              primary: false,
              shrinkWrap: false,
              slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: new IconButton(
                icon:
                    new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                onPressed: () => {Get.back()},
              ),
              title: Text("All Cities", style: Get.textTheme.headline6),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Obx(() {
                    return controller.cities.isNotEmpty
                        ? CitiesCarouselScreen()
                        : ShimmerCitiesCarouselWidget();
                  }),
                ],
              ),
            ),
          ]),
    );
  }
}
