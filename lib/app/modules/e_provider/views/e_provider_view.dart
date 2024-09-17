import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/components/e_provider/address_eprovider.dart';
import 'package:emarates_bd/app/modules/components/e_provider/availability_hour_eprovider.dart';
import 'package:emarates_bd/app/modules/components/e_provider/contact_us_eprovider.dart';
import 'package:emarates_bd/app/modules/components/e_provider/cover_eprovider.dart';
import 'package:emarates_bd/app/modules/components/e_provider/description_eprovider.dart';
import 'package:emarates_bd/app/modules/components/e_provider/employee_number_eprovider.dart';
import 'package:emarates_bd/app/modules/components/e_provider/review_eprovider.dart';
import 'package:emarates_bd/app/modules/components/e_provider/title_bar_eprovider.dart';
import 'package:emarates_bd/app/modules/e_provider/widgets/shimmer_provider_detailis.dart';
import 'package:emarates_bd/app/modules/global_widgets/header_refresh.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../providers/laravel_provider.dart';
import '../../components/e_provider/galleries_eprovider.dart';
import '../controllers/e_provider_controller.dart';
import '../widgets/e_provider_title_bar_widget.dart';

class EProviderView extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    controller.initRefresh();
    var _eProvider = controller.eProvider.value;
    return Scaffold(
        body: SmartRefresher(
      controller: controller.refreshController,
      onRefresh: () async {
        Get.find<LaravelApiClient>().forceRefresh();
        await controller.refreshEProvider(showMessage: false);
        Get.find<LaravelApiClient>().unForceRefresh();
      },
      header: HeaderRefresh(),
      child: CustomScrollView(
        primary: true,
        shrinkWrap: false,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: 310,
            elevation: 0,
            floating: true,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
              onPressed: () => {Get.back()},
            ),
            bottom: EProviderTitleBarWidget(
              title: TitleEProvider(_eProvider),
            ),
            flexibleSpace: CoverEProvider(_eProvider, controller.heroTag)
                .marginOnly(bottom: 50),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                ContactUsEProvider(),
                DescriptionEProvider(),
                GetBuilder<EProviderController>(builder: (controller) {
                  return controller.statusRequest == StatusRequest.loading
                      ? ShimmerProviderDetails()
                      : Column(
                          children: [
                            AddressEProvider(),
                            GalleriesEProvider(),
                            AvailabilityHourEProvider(),
                            EmployeeNumberEProvider(),
                            ReviewEProvider()
                          ],
                        );
                }),
                //Single Provider
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
