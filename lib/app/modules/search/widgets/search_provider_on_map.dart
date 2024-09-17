import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/search/controllers/search_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;
import 'package:lottie/lottie.dart';

import '../../../../common/Functions/stutsrequest.dart';

class SearchProviderOnMap extends GetView<CustomSearchController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomSearchController>(
      builder: (controller) {
        return controller.searchStatusRequest == StatusRequest.loading &&
                controller.eProvider.isEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height / 4),
                child: Center(
                  child: Lottie.asset("assets/img/loading.json",
                      width: 170.0, height: 170.0),
                ),
              )
            : controller.searchStatusRequest == StatusRequest.non &&
                    controller.eProvider.isEmpty
                ? SizedBox()
                : SizedBox(
                    width: double.infinity,
                    height: Get.height / 1.5,
                    child: googleMap.GoogleMap(
                        mapType: googleMap.MapType.normal,
                        initialCameraPosition: googleMap.CameraPosition(
                          target: googleMap.LatLng(25.276987, 55.296249),
                          zoom: 7,
                        ),
                        markers: controller.markers.toSet()),
                  );
      },
    );
  }
}
