import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';
import 'package:emarates_bd/common/ui.dart';
import '../../../../common/Functions/stutsrequest.dart';
import '../../e_provider/controllers/e_provider_controller.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;

import '../../e_provider/widgets/e_provider_til_widget.dart';

class AddressEProvider extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    ProviderModel _eProvider = controller.eProvider.value;

    Get.log("Lat : ${controller.singleProviderModel.value.lat.toString()}");
    return EProviderTilWidget(
      title: Text("Address".tr,
          style: Get.textTheme.subtitle2!
              .copyWith(color: Get.theme.colorScheme.secondary)),
      content: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(_eProvider.address ?? '', style: Get.textTheme.bodyText1),
                if (controller.singleProviderModel.value.lat != null &&
                    controller.singleProviderModel.value.long != null)
                  if (controller.singleProviderModel.value.lat!.isNotEmpty &&
                      controller.singleProviderModel.value.long!.isNotEmpty)
                    if (double.parse(controller.singleProviderModel.value.lat!)
                                .ceil() !=
                            0 &&
                        double.parse(controller.singleProviderModel.value.long!)
                                .ceil() !=
                            0)
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.orangeAccent),
                        ),
                        onPressed: () {
                          openMapsSheet(
                              controller.singleProviderModel.value.lat!,
                              controller.singleProviderModel.value.long!,
                              context);
                        },
                        child: Text(
                          'Get direction'.tr,
                          style: Get.textTheme.subtitle1,
                        ),
                      )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          // Text(_eService.duration, style: Get.textTheme.headline6),
        ],
      ),
    );
  }

  openMapsSheet(String lat, String long, BuildContext context) async {
    try {
      final coords = launcher.Coords(double.parse(lat), double.parse(long));
      final availableMaps = await launcher.MapLauncher.installedMaps;
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showDirections(
                          directionsMode: launcher.DirectionsMode.driving,
                          destination: coords,
                        ),
                        title:
                            Text(map.mapName, style: Get.textTheme.bodyText2),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
