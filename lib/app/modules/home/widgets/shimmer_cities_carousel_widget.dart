// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
//
// import '../../../routes/app_routes.dart';
// import '../controllers/home_controller.dart';
//
// class CitiesCarouselWidget extends GetWidget<HomeController> {
//   @override
//   Widget build(BuildContext context) {
//     print( controller.cities.length);
//     print( 'ji');
//     return Container(
//       height: 130,
//       margin: EdgeInsets.only(bottom: 15),
//       child: Obx(() {
//         return ListView.builder(
//             primary: false,
//             shrinkWrap: false,
//             scrollDirection: Axis.horizontal,
//             itemCount: controller.cities.length,
//
//             itemBuilder: (_, index) {
//               var _city = controller.cities.elementAt(index);
//               return InkWell(
//                 onTap: () {
//                   Get.toNamed(Routes.CITIES, arguments: _city);
//                 },
//                 child: Container(
//                   width: 100,
//                   height: 100,
//                   margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0),
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   decoration: new BoxDecoration(
//                     // gradient: new LinearGradient(
//                     //     // colors: [_city.color.withOpacity(1), _city.color.withOpacity(0.1)],
//                     //     begin: AlignmentDirectional.topStart,
//                     //     //const FractionalOffset(1, 0),
//                     //     end: AlignmentDirectional.bottomEnd,
//                     //     stops: [0.1, 0.9],
//                     //     tileMode: TileMode.clamp),
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   child: Stack(
//                     alignment: AlignmentDirectional.topStart,
//                     children: [
//                       Padding(
//                         padding: EdgeInsetsDirectional.only(start: 30, top: 30),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                           child: (_city.image.url.toLowerCase().endsWith('.svg')
//                               ? SvgPicture.network(
//                             _city.image.url,
//                                   // color: _city.color,
//                                 )
//                               : CachedNetworkImage(
//                                   fit: BoxFit.cover,
//                                   imageUrl: _city.image.url,
//                                   placeholder: (context, url) => Image.asset(
//                                     'assets/img/loading.gif',
//                                     fit: BoxFit.cover,
//                                   ),
//                                   errorWidget: (context, url, error) => Icon(Icons.error_outline),
//                                 )),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsetsDirectional.only(start: 10, top: 0),
//                         child: Text(
//                           _city.name,
//                           maxLines: 2,
//                           style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             });
//       }),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class ShimmerCitiesCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    // print( controller.cities.value.length);
    // print('city');
    return Container(
      height: 200,
      color: Get.theme.primaryColor,
      child: ListView.builder(
          padding: EdgeInsets.only(bottom: 10),
          primary: false,
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (_, index) {
            // print(_city.cover);
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 180,
                margin: EdgeInsetsDirectional.only(
                    end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Get.theme.colorScheme.secondary.withOpacity(.5),
                ),
                child: SizedBox(),
              ),
            );
          }),
    );
  }
}
