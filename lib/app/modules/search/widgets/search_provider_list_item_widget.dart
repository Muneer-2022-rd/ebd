/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../routes/app_routes.dart';

class SearchProviderListItemWidget extends StatelessWidget {
  const SearchProviderListItemWidget({
    Key? key,
    required EProvider service,
  })  : _provider = service,
        super(key: key);

  final EProvider _provider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.E_PROVIDER, arguments: {'EProvider': _provider, 'heroTag': 'search_list'});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Hero(
                  tag: 'search_list' + _provider.id!,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: _provider.logo!,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 80,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                ),
                // if (_provider.available)
                //   Container(
                //     width: 80,
                //     child: Text("Available".tr,
                //         maxLines: 1,
                //         style: Get.textTheme.bodyText2.merge(
                //           TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
                //         ),
                //         softWrap: false,
                //         textAlign: TextAlign.center,
                //         overflow: TextOverflow.fade),
                //     decoration: BoxDecoration(
                //       color: Colors.green.withOpacity(0.2),
                //       borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                //   ),
                // if (!_provider.available)
                //   Container(
                //     width: 80,
                //     child: Text("Offline".tr,
                //         maxLines: 1,
                //         style: Get.textTheme.bodyText2.merge(
                //           TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                //         ),
                //         softWrap: false,
                //         textAlign: TextAlign.center,
                //         overflow: TextOverflow.fade),
                //     decoration: BoxDecoration(
                //       color: Colors.grey.withOpacity(0.2),
                //       borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                //   ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Wrap(
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        _provider.name ?? '',
                        style: Get.textTheme.bodyText2,
                        maxLines: 3,
                        // textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  // Divider(height: 8, thickness: 1),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Wrap(
                  //       crossAxisAlignment: WrapCrossAlignment.center,
                  //       spacing: 5,
                  //       children: [
                  //         SizedBox(
                  //           height: 32,
                  //           child: Chip(
                  //             padding: EdgeInsets.all(0),
                  //             label: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: <Widget>[
                  //                 Icon(
                  //                   Icons.star,
                  //                   color: Get.theme.colorScheme.secondary,
                  //                   size: 18,
                  //                 ),
                  //                 Text(_provider.rate.toString(), style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary, height: 1.4))),
                  //               ],
                  //             ),
                  //             backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.15),
                  //             shape: StadiumBorder(),
                  //           ),
                  //         ),
                  //         Text(
                  //           "From (%s)".trArgs([_provider.totalReviews.toString()]),
                  //           style: Get.textTheme.bodyText1,
                  //         ),
                  //       ],
                  //     ),
                  //     Ui.getPrice(_provider.price, style: Get.textTheme.headline6),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.build_circle_outlined,
                  //       size: 18,
                  //       color: Get.theme.focusColor,
                  //     ),
                  //     SizedBox(width: 5),
                  //     Flexible(
                  //       child: Text(
                  //         _provider.eProvider.name,
                  //         maxLines: 1,
                  //         overflow: TextOverflow.fade,
                  //         softWrap: false,
                  //         style: Get.textTheme.bodyText1,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.place_outlined,
                  //       size: 18,
                  //       color: Get.theme.focusColor,
                  //     ),
                  //     SizedBox(width: 5),
                  //     Flexible(
                  //       child: Text(
                  //         _provider.eProvider.firstAddress,
                  //         maxLines: 1,
                  //         overflow: TextOverflow.fade,
                  //         softWrap: false,
                  //         style: Get.textTheme.bodyText1,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Divider(height: 8, thickness: 1),
                  // Wrap(
                  //   spacing: 5,
                  //   children: List.generate(_provider.subCategories.length, (index) {
                  //     return Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  //       child: Text(_provider.subCategories.elementAt(index).name, style: Get.textTheme.caption.merge(TextStyle(fontSize: 10))),
                  //       decoration: BoxDecoration(
                  //           color: Get.theme.primaryColor,
                  //           border: Border.all(
                  //             color: Get.theme.focusColor.withOpacity(0.2),
                  //           ),
                  //           borderRadius: BorderRadius.all(Radius.circular(20))),
                  //     );
                  //   }),
                  //   runSpacing: 5,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
