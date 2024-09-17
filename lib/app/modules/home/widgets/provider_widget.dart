import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';
import 'package:emarates_bd/app/modules/components/e_provider/provider_item.dart';
import 'package:emarates_bd/app/modules/global_widgets/shocase_widget.dart';
import 'package:peek_and_pop_dialog/peek_and_pop_dialog.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/show_tost.dart';
import '../controllers/home_controller.dart';

class ProviderWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Get.theme.primaryColor,
      child: Obx(() {
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 10),
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.providers.length,
            itemBuilder: (_, index) {
              ProviderModel _provider = controller.providers.elementAt(index);
              return _provider.lat!.isNotEmpty &&
                      _provider.lng!.isNotEmpty &&
                      double.parse(_provider.lat ?? '0').ceil() != 0 &&
                      double.parse(_provider.lng ?? '0').ceil() != 0
                  ? PeekAndPopDialog(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.E_PROVIDER, arguments: {
                            'eProvider': controller.providers[index],
                            'heroTag': 'Newly Added'
                          });
                        },
                        child: ProviderItem(
                          providerModel: _provider,
                          indexItem: index,
                          heroTag: 'Newly Added',
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
                            return GoogleMap(
                                onMapCreated: (googleMapController) async {
                                  await controller.setMarkerCustomImage(
                                    Marker(
                                      markerId:
                                          MarkerId(_provider.id.toString()),
                                      visible: true,
                                      icon: BitmapDescriptor.fromBytes(
                                          await controller.getBytesFromAsset(
                                              'assets/img/markerone.png', 100)),
                                      position: LatLng(
                                          double.parse(_provider.lat!),
                                          double.parse(_provider.lng!)),
                                      infoWindow: InfoWindow(
                                          title: "${_provider.name}".tr,
                                          snippet: "${_provider.address}"),
                                      draggable: false,
                                    ),
                                  );
                                },
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(double.parse(_provider.lat!),
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
                        Get.toNamed(Routes.E_PROVIDER, arguments: {
                          'eProvider': controller.providers[index],
                          'heroTag': 'Newly Added'
                        });
                      },
                      onLongPress: () {
                        ShowToast.showToast(
                            ToastType.NORMAL,
                            "We are not provided with the location of the company on the map"
                                .tr);
                      },
                      child: ProviderItem(
                        providerModel: _provider,
                        indexItem: index,
                        heroTag: 'Newly Added',
                      ),
                    );
            });
      }),
    );
  }
}
