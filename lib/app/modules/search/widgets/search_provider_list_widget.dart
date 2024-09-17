import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;
import 'package:emarates_bd/app/models/e_provider_model.dart';
import 'package:emarates_bd/app/modules/category/widgets/provider_list_item_widget.dart';
import 'package:emarates_bd/app/modules/search/controllers/search_controller.dart';
import 'package:emarates_bd/app/routes/app_routes.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';
import 'package:lottie/lottie.dart';
import 'package:peek_and_pop_dialog/peek_and_pop_dialog.dart';

import '../../global_widgets/show_tost.dart';
import '../../home/controllers/home_controller.dart';

class SearchProvidersListWidget extends GetView<CustomSearchController> {
  SearchProvidersListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.searchStatusRequest == StatusRequest.loading &&
            controller.eProvider.isEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height / 4),
            child: Center(
              child: Lottie.asset("assets/img/loading.json",
                  width: 170.0, height: 170.0),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.only(bottom: 10, top: 10),
            primary: false,
            shrinkWrap: true,
            itemCount: controller.eProvider.length,
            itemBuilder: ((_, index) {
              ProviderModel _provider = controller.eProvider.elementAt(index);
              return _provider.lat!.isNotEmpty &&
                      _provider.lng!.isNotEmpty &&
                      double.parse(_provider.lat ?? '0').ceil() != 0 &&
                      double.parse(_provider.lng ?? '0').ceil() != 0
                  ? PeekAndPopDialog(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.E_PROVIDER, arguments: {
                            'eProvider': controller.eProvider[index],
                            'heroTag': 'search_list'
                          });
                        },
                        child: ProviderListItemWidget(
                          provider: _provider,
                          heroTag: "search_list",
                        ),
                      ),
                      dialog: Container(
                        width: double.infinity,
                        height: 300.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: GetBuilder<HomeController>(
                          builder: (controller) {
                            return googleMap.GoogleMap(
                                onMapCreated: (googleMapController) async {
                                  await controller.setMarkerCustomImage(
                                    googleMap.Marker(
                                      markerId: googleMap.MarkerId(
                                          _provider.id.toString()),
                                      visible: true,
                                      icon: googleMap.BitmapDescriptor
                                          .fromBytes(await controller
                                              .getBytesFromAsset(
                                                  'assets/img/markerone.png',
                                                  100)),
                                      position: googleMap.LatLng(
                                          double.parse(_provider.lat!),
                                          double.parse(_provider.lng!)),
                                      infoWindow: googleMap.InfoWindow(
                                          title: "${_provider.name}".tr,
                                          snippet: "${_provider.address}"),
                                      draggable: false,
                                    ),
                                  );
                                },
                                mapType: googleMap.MapType.normal,
                                initialCameraPosition: googleMap.CameraPosition(
                                  target: googleMap.LatLng(
                                      double.parse(_provider.lat!),
                                      double.parse(_provider.lng!)),
                                  zoom: 11,
                                ),
                                markers: controller.myMarker);
                          },
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        // print('ServicesListItemWidget - eservice widget');
                        Get.toNamed(Routes.E_PROVIDER, arguments: {
                          'eProvider': _provider,
                          'heroTag': 'search_list'
                        });
                      },
                      onLongPress: () {
                        ShowToast.showToast(
                            ToastType.NORMAL,
                            "We are not provided with the location of the company on the map"
                                .tr);
                      },
                      child: ProviderListItemWidget(
                        provider: _provider,
                        heroTag: "search_list",
                      ),
                    );
            }),
          );
  }
}
