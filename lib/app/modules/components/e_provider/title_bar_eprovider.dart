import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';

import '../../../../common/ui.dart';
import '../../e_provider/widgets/e_provider_title_bar_widget.dart';

class TitleEProvider extends StatelessWidget {
  ProviderModel providerModel;

  TitleEProvider(this.providerModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              decoration: Ui.getBoxDecoration(
                radius: 14,
                border: Border.all(width: 5, color: Get.theme.primaryColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child:
                    // Image.asset(
                    //   'assets/icon/icon.png',
                    //   fit: BoxFit.cover,
                    //   width: 50,
                    //   height: 50,
                    // ),
                    //
                    CachedNetworkImage(
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  // imageUrl: _provider.firstImageUrl,
                  imageUrl: providerModel.logo.toString(),
                  // imageUrl: _provider.pic2.first.url,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 100,
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline),
                ),
              ),
            ).marginOnly(right: 10),
            Expanded(
              child: Text(
                providerModel.name.toString() ?? '',
                style: Get.textTheme.headline5?.merge(TextStyle(height: 1.1)),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(height: 5),
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: List.from(
                    Ui.getStarsList(providerModel.rating!.toDouble() ?? 0.0))
                  ..addAll([
                    SizedBox(width: 5),
                  ]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
