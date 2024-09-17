import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:emarates_bd/app/modules/auth/controllers/auth_controller.dart';

class BusinessInformationPage3 extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Get.theme.focusColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5)),
                ],
                border: Border.all(
                  color: Get.theme.focusColor.withOpacity(0.05),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Set the company's location on the map".tr,
                    style: Get.textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: SizedBox(
                        height: Get.size.height / 2,
                        width: double.infinity,
                        child: GoogleMap(
                            mapToolbarEnabled: true,
                            padding: EdgeInsets.symmetric(),
                            mapType: MapType.normal,
                            onTap: (latLong) async {
                              controller.setMarkerCustomImage(
                                  Marker(
                                    markerId: MarkerId("1"),
                                    visible: true,
                                    icon: BitmapDescriptor.fromBytes(
                                        await controller.getBytesFromAsset(
                                            'assets/img/markerone.png', 100)),
                                    position: LatLng(
                                        latLong.latitude, latLong.longitude),
                                    infoWindow: InfoWindow(
                                        title: "Locate Your company".tr),
                                    draggable: false,
                                  ),
                                  latLong: latLong);
                            },
                            initialCameraPosition: controller.kGooglePlex,
                            markers: controller.myMarker)),
                  ),
                ],
              ),
            ),
            Spacer()
          ],
        );
      }),
    );
  }
}
