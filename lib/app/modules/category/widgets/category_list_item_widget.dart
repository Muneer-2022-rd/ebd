import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../routes/app_routes.dart';

class CategoryListItemWidget extends StatelessWidget {
  final Category? category;
  final String? heroTag;
  final bool? expanded;

  CategoryListItemWidget({Key? key, this.category, this.heroTag, this.expanded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: Ui.getBoxDecoration(
          border: Border.all(color: Color(0xffc09868)),
          gradient: new LinearGradient(
              // colors: [category.color.withOpacity(0.6), category.color.withOpacity(0.1)],
              colors: [
                Get.theme.colorScheme.secondary,
                Get.theme.colorScheme.secondary.withOpacity(0.8)
              ],
              begin: AlignmentDirectional.topStart,
              //const FractionalOffset(1, 0),
              end: AlignmentDirectional.topEnd,
              stops: [0.0, 0.5],
              tileMode: TileMode.clamp)),
      child: Theme(
        data: Get.theme.copyWith(dividerColor: Colors.transparent),
        child:
            // ExpansionTile(
            //   initiallyExpanded: this.expanded!,
            //   // collapsedIconColor: Color(0xffc09868).withOpacity(.8),
            //   // iconColor: Color(0xffc09868),
            //   expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            //   title:
            InkWell(
          highlightColor: Colors.transparent,
          splashColor: Get.theme.colorScheme.secondary.withOpacity(0.08),
          onTap: () {
            Get.toNamed(Routes.CATEGORY, arguments: category);
            //Navigator.of(context).pushNamed('/Details', arguments: RouteArgument(id: '0', param: market.id, heroTag: heroTag));
          },
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 0.0, bottom: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      width: 60,
                      height: 60,
                      child:
                          // (category.image.url.toLowerCase().endsWith('.svg')
                          // // child: (category.image.url.toLowerCase().endsWith('.svg')
                          //     ? SvgPicture.network(
                          //   // category.image.url,
                          //   category.svg,
                          //   color: category.color,
                          //   height: 100,
                          // )
                          //     :
                          CachedNetworkImage(
                        fit: BoxFit.contain,
                        // imageUrl: category.image.url,
                        imageUrl: category!.svg!,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline),
                      )
                      // ),
                      ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      category!.name!,
                      overflow: TextOverflow.fade,
                      softWrap: false,

                      // style: Get.textTheme.bodyText2,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  // TODO get service for each category
                  // Text(
                  //   "(" + category.services.length.toString() + ")",
                  //   overflow: TextOverflow.fade,
                  //   softWrap: false,
                  //   style: Get.textTheme.caption,
                  // ),
                ],
              )),
        ),
        // children: List.generate(category!.subCategories?.length ?? 0,
        //     (index) {
        //   var _category = category!.subCategories!.elementAt(index);
        //   return GestureDetector(
        //     onTap: () {
        //       Get.toNamed(Routes.CATEGORY, arguments: _category);
        //     },
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        //       child: Text(_category.name!, style: Get.textTheme.bodyText1),
        //       decoration: BoxDecoration(
        //         color: Get.theme.scaffoldBackgroundColor.withOpacity(0.2),
        //         border: Border(
        //             top: BorderSide(
        //                 color: Get.theme.scaffoldBackgroundColor
        //                     .withOpacity(0.3))
        //             //color: Get.theme.focusColor.withOpacity(0.2),
        //             ),
        //       ),
        //     ),
        //   );
        // }

        // children: List.generate(5,(index) {
        //   // var _category = category.subCategories.elementAt(index);
        //   return GestureDetector(
        //     onTap: () {
        //       // Get.toNamed(Routes.CATEGORY, arguments: _category);
        //     },
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        //       child: Text('Companies', style: Get.textTheme.bodyText1),
        //       decoration: BoxDecoration(
        //         color: Get.theme.scaffoldBackgroundColor.withOpacity(0.2),
        //         border: Border(top: BorderSide(color: Get.theme.scaffoldBackgroundColor.withOpacity(0.3))
        //           //color: Get.theme.focusColor.withOpacity(0.2),
        //         ),
        //       ),
        //     ),
        //   );
        //
        // }

        // ),
        // ),
      ),
    );
  }
}
