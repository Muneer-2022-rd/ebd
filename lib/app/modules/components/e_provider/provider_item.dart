import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';
import '../../../../common/ui.dart';

class ProviderItem extends StatelessWidget {
  ProviderModel providerModel;
  String heroTag;
  int indexItem;

  ProviderItem(
      {required this.providerModel,
      required this.indexItem,
      required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      // height: 240,
      margin: EdgeInsetsDirectional.only(
          end: 20, start: indexItem == 0 ? 20 : 0, top: 20),
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(3, 5)),
        ],
      ),
      child: Column(
        //alignment: AlignmentDirectional.topStart,
        children: [
          Hero(
            tag: heroTag + providerModel.id.toString(),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: CachedNetworkImage(
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                // imageUrl: _provider.firstImageUrl,
                imageUrl: providerModel.media!.url!,
                // imageUrl: _provider.pic2.first.url,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 100,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(children: [
                    Text(
                      providerModel.name ?? '',
                      maxLines: 2,
                      style: Get.textTheme.bodyText2!
                          .merge(TextStyle(color: Get.theme.hintColor)),
                    ),
                  ]),
                ),

                // SizedBox(height: 5),
                // if(_provider.award.length >0)
                // Row(
                //   // alignment: WrapAlignment.start,
                //   children: [
                //     Image.asset('assets/img/awards.png',width: 30,),
                //     Flexible(
                //       child:FittedBox(
                //         fit: BoxFit.contain,
                //         child: Text(
                //           _provider.award[0].title ,
                //           // _provider.name ,
                //           maxLines: 2,
                //           // style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                //           style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                //rating
                Wrap(
                  alignment: WrapAlignment.center,
                  children: Ui.getStarsList(
                      size: 20, providerModel.rating!.toDouble()),
                ),
                // SizedBox(height: 5),
                // Wrap(
                //   spacing: 5,
                //   alignment: WrapAlignment.end,
                //   direction: Axis.horizontal,
                //   children: [
                //     if(_provider !=null)
                //     for (var i = 0; i < _provider.price_level; i++)
                //       Text(
                //         '\$',
                //         style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                //       ),
                //
                //     // Text(
                //     //   "Start from".tr,
                //     //   style: Get.textTheme.caption,
                //     // ),
                //     // Ui.getPrice(
                //     //   _provider.price,
                //     //   style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                //     //   unit: _provider.getUnit,
                //     // ),
                //   ],
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
