import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../routes/app_routes.dart';

class CategoryGridItemWidget extends StatelessWidget {
  final Category? category;
  final String? heroTag;

  CategoryGridItemWidget({Key? key, this.category, this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Get.theme.colorScheme.secondary.withOpacity(0.08),
      onTap: () {
        Get.toNamed(Routes.CATEGORY, arguments: category);
      },
      child: Container(
        decoration: Ui.getBoxDecoration(
            color: Get.theme.colorScheme.secondary,
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
        child: Wrap(
          children: <Widget>[
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.symmetric(vertical: 10),
            //   decoration: new BoxDecoration(
            //     gradient: new LinearGradient(
            //         colors: [category.color.withOpacity(1), category.color.withOpacity(0.1)],
            //         begin: AlignmentDirectional.topStart,
            //         //const FractionalOffset(1, 0),
            //         end: AlignmentDirectional.bottomEnd,
            //         stops: [0.1, 0.9],
            //         tileMode: TileMode.clamp),
            //     borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            //   ),
            //   child: (category.image.url.toLowerCase().endsWith('.svg')
            //       ? SvgPicture.network(
            //           category.image.url,
            //           color: category.color,
            //           height: 100,
            //         )
            //       : CachedNetworkImage(
            //           fit: BoxFit.cover,
            //           // imageUrl: category.image.url,
            //       imageUrl: category.cover_back,
            //           placeholder: (context, url) => Image.asset(
            //             'assets/img/loading.gif',
            //             fit: BoxFit.cover,
            //           ),
            //           errorWidget: (context, url, error) => Icon(Icons.error_outline),
            //         )),
            // ),
            Container(
              height: 140,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CachedNetworkImage(
                    width: 60,
                    height: 55,
                    fit: BoxFit.contain,
                    // imageUrl: category.image.url,
                    imageUrl: category!.svg!,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    category!.name ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Get.theme.primaryColor, fontSize: 15),
                    softWrap: false,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
