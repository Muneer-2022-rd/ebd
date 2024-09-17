import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../providers/laravel_provider.dart';
import '../../global_widgets/header_refresh.dart';
import '../controllers/home_controller.dart';
import '../widgets/featured_provider_widget.dart';
import '../widgets/shimmer_provider_widget.dart';
import 'all_featured_widget.dart';

class AllFeaturedScreen extends StatefulWidget {
  const AllFeaturedScreen({super.key});

  @override
  State<AllFeaturedScreen> createState() => _AllFeaturedScreenState();
}

class _AllFeaturedScreenState extends State<AllFeaturedScreen> {
  GlobalKey four = GlobalKey();
  HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          //   SafeArea(
          // child: SmartRefresher(
          //   controller: controller.refreshController,
          //   onRefresh: () async {
          //     Get.find<LaravelApiClient>().forceRefresh();
          //     await controller.refreshHome(showMessage: false);
          //     Get.find<LaravelApiClient>().unForceRefresh();
          //   },
          //   header: HeaderRefresh(),
          //   child:
          CustomScrollView(
              controller: controller.scrollController,
              primary: false,
              shrinkWrap: false,
              slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: new IconButton(
                icon:
                    new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                onPressed: () => {Get.back()},
              ),
              centerTitle: true,
              title: Text(
                "Featured Companies",
                style: Get.textTheme.headline6,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Obx(() {
                    return controller.featuredProviders.isNotEmpty
                        ? AllFeaturedProviderWidget(
                            // keyShowCase: GlobalKey(),
                            )
                        : ShimmerProviderWidget();
                  }),
                ],
              ),
            ),
          ]),
    );
  }
}
