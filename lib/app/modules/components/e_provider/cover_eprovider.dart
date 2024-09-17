import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';

class CoverEProvider extends StatelessWidget {
  ProviderModel providerModel;
  String heroTag;
  CoverEProvider(this.providerModel, this.heroTag);
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      background:
          // Obx(() {
          Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Hero(
            tag: heroTag + providerModel.id.toString(),
            child: CachedNetworkImage(
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
              imageUrl: providerModel.cover!,
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            ),
          ),

          // buildCarouselSlider(_eProvider),
          // buildCarouselBullets(_eProvider),
        ],
      ),

      // }),
    );
  }
}
