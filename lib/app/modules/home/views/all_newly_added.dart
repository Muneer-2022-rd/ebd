import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../providers/laravel_provider.dart';
import '../../global_widgets/header_refresh.dart';
import '../controllers/home_controller.dart';
import '../widgets/provider_widget.dart';
import '../widgets/shimmer_provider_widget.dart';
import 'all_newly_added_widget.dart';

class AllNewlyAddedScreen extends StatefulWidget {
  const AllNewlyAddedScreen({super.key});

  @override
  State<AllNewlyAddedScreen> createState() => _AllNewlyAddedScreenState();
}

class _AllNewlyAddedScreenState extends State<AllNewlyAddedScreen> {
  HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // SmartRefresher(
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
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: Text(
                "Newly Added",
                style: Get.textTheme.headline6,
              ),
              leading: new IconButton(
                icon:
                    new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                onPressed: () => {Get.back()},
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return controller.providers.isNotEmpty
                        ? AllNewlyWidget()
                        : ShimmerProviderWidget();
                  }),
                ],
              ),
            ),
          ]),
    );
  }
}
