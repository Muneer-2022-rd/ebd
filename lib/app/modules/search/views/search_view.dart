import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/global_widgets/show_tost.dart';
import 'package:emarates_bd/app/modules/search/widgets/search_provider_list_widget.dart';
import 'package:emarates_bd/app/modules/search/widgets/search_provider_on_map.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../common/Functions/stutsrequest.dart';
import '../../../../common/ui.dart';
import '../../global_widgets/filter_bottom_sheet_widget.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<CustomSearchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search".tr,
          style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () {
            Get.back();
            controller.resetPage();
          },
        ),
        elevation: 0,
      ),
      body: GetBuilder<CustomSearchController>(
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              Get.back();
              controller.resetPage();
              return true;
            },
            child: SmartRefresher(
              controller: controller.refreshController,
              footer: ClassicFooter(
                loadingText: "Loading...".tr,
                noDataText: "No more data".tr,
              ),
              enablePullDown: false,
              enablePullUp: true,
              onLoading: () async {
                if (controller.textEditingController.text.length > 0) {
                  final result =
                      await controller.searchProviders(isBannerSearch: false);
                  if (result == true) {
                    if (controller.currentPage > controller.totalPage) {
                      controller.refreshController.loadNoData();
                    } else {
                      controller.refreshController.loadComplete();
                    }
                  } else {
                    controller.refreshController.loadFailed();
                  }
                }
              },
              child: ListView(
                physics: !controller.isChecked.value
                    ? NeverScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                children: [
                  buildSearchBar(),
                  // SearchServicesListWidget(services: controller.eServices),
                  controller.isChecked.value
                      ? SearchProvidersListWidget()
                      : SearchProviderOnMap(),
                  SizedBox(
                    height: 15.0,
                  ),
                  controller.searchStatusRequest == StatusRequest.noData
                      ? Center(child: Text("No Data Found"))
                      : SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchBar() {
    return Hero(
      tag: "Hero",
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            border: Border.all(
              color: Get.theme.focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color: Get.theme.colorScheme.secondary),
            ),
            Expanded(
              child: Material(
                color: Get.theme.primaryColor,
                child: TextField(
                  controller: controller.textEditingController,
                  style: Get.textTheme.bodyText2,
                  onSubmitted: (value) async {
                    if (controller.textEditingController.text.isNotEmpty) {
                      await controller.searchProviders(isBannerSearch: true);
                    } else {
                      ShowToast.showToast(
                          ToastType.NORMAL,
                          "Please type the name of the company you want to search for"
                              .tr);
                    }
                    // controller.searchEServices(keywords: value);
                    // controller.searchEServicesByCities(keywords: value);
                    // controller.searchEProvidersByCities(keywords: value);
                  },
                  onChanged: (value) {
                    controller.onChangeSearch(value);
                  },
                  autofocus: true,
                  cursorColor: Get.theme.focusColor,
                  decoration: Ui.getInputDecoration(
                      hintText: "Search for companies...".tr),
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  FilterBottomSheetWidget(),
                  isScrollControlled: true,
                );
              },
              child: Container(
                padding: const EdgeInsets.only(
                    right: 10, left: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Get.theme.focusColor.withOpacity(0.1),
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    Text(
                      "Filter".tr,
                      style: Get.textTheme
                          .bodyText2, //TextStyle(color: Get.theme.hintColor),
                    ),
                    Icon(
                      Icons.filter_list,
                      color: Get.theme.hintColor,
                      size: 21,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
