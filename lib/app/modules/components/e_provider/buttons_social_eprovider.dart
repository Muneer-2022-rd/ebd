import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/e_provider/controllers/e_provider_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ButtonsSocialEProvider extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if (controller.eProvider.value.website!.length > 0)
          MaterialButton(
            onPressed: () async {
              if (await canLaunch(controller.eProvider.value.website!)) {
                await launch("${controller.eProvider.value.website}");
              } else {}
            },
            height: 10,
            minWidth: 10,
            padding: EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color(0xffc09868),
            child: FaIcon(Icons.web, size: 15, color: Colors.white),
            elevation: 0,
          ),

        if (controller.eProvider.value.whatsapp!.length > 0)
          MaterialButton(
            onPressed: () async {
              print(controller.eProvider.value.whatsapp);
              var whatsappUrl =
                  "whatsapp://send?phone=${controller.eProvider.value.whatsapp}";
              try {
                await launch(whatsappUrl);
              } catch (e) {
                print("Error lunching whatsapp");
              }
            },
            height: 10,
            minWidth: 10,
            padding: EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color(0xffc09868),
            child: FaIcon(FontAwesomeIcons.whatsapp,
                size: 15, color: Colors.white),
            elevation: 0,
          ),

        if (controller.eProvider.value.instagram!.length > 0)
          MaterialButton(
            onPressed: () async {
              // launch("tel:${controller.eProvider.value.mobileNumber}");
              print(controller.eProvider.value.instagram!.length);
              if (await canLaunch(controller.eProvider.value.instagram!)) {
                await launch(
                  controller.eProvider.value.instagram!,
                  universalLinksOnly: true,
                );
              }
            },
            height: 10,
            minWidth: 10,
            padding: EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color(0xffc09868),
            child: FaIcon(FontAwesomeIcons.instagram,
                size: 15, color: Colors.white),
            elevation: 0,
          ),

        // if(controller.eProvider.value.facebook.length>0)
        if (controller.eProvider.value.facebook!.length > 0)
          MaterialButton(
            onPressed: () async {
//                        if (await canLaunch(
////                            controller.eProvider.value.facebook!)) {
////                          await launch(controller.eProvider.value.facebook!,
////                              universalLinksOnly: true);
////                        }
              var url =
                  'fb://facewebmodal/f?href=${controller.eProvider.value.facebook}';
              if (await canLaunch(url)) {
                await launch(
                  url,
                  universalLinksOnly: true,
                );
              } else {
                throw 'There was a problem to open the url: $url';
              }
            },
            height: 10,
            minWidth: 10,
            padding: EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color(0xffc09868),
            child: FaIcon(FontAwesomeIcons.facebook,
                size: 15, color: Colors.white),
            elevation: 0,
          ),
      ],
    );
  }
}
