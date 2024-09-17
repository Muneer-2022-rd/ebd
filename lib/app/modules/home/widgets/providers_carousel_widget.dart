import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';
import 'package:emarates_bd/app/modules/home/controllers/home_controller.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../routes/app_routes.dart';

class ProvidersCarouselWidget extends StatelessWidget {
  final List<EProvider>? provider;

  const ProvidersCarouselWidget({Key? key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 345,
      child: ListView.builder(
          padding: EdgeInsets.only(bottom: 10),
          primary: false,
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: provider!.length,
          itemBuilder: (_, index) {
            var _provider = provider!.elementAt(index);
            // print('featured');
            // print(_provider.cover,);

            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.E_PROVIDER, arguments: {
                  'eProvider': _provider,
                  'heroTag': 'e_service_details'
                });
              },
              child: Container(
                width: 220,
                margin: EdgeInsetsDirectional.only(
                    end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Get.theme.focusColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5)),
                  ],
                ),
                child: Column(
                  //alignment: AlignmentDirectional.topStart,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        // imageUrl: _service.firstImageUrl,
                        imageUrl: _provider.cover!,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            _provider.name!,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            style: Get.textTheme.bodyText2
                                ?.merge(TextStyle(color: Get.theme.hintColor)),
                          ),

                          SizedBox(height: 5),
                          Wrap(
                            spacing: 1,
                            alignment: WrapAlignment.center,
                            direction: Axis.horizontal,
                            children: Ui.getStarsList(_provider.rate!),
                          ),

                          // SizedBox(height: 5),
                          // Wrap(
                          //
                          //     // Even Padding On All Sides
                          //
                          //   spacing: 5,
                          //   alignment: WrapAlignment.end,
                          //   direction: Axis.horizontal,
                          //   children: [
                          //     if(_provider != null)
                          //     for (var i = 0; i < _provider.price_level; i++)
                          //       Text(
                          //         '\$',
                          //         style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                          //
                          //       ),
                          //    // child: Ui.getStarsList(_service.rate),
                          //
                          //   ],
                          //
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
