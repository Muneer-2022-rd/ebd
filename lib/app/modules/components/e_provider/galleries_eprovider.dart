import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/e_provider/controllers/e_provider_controller.dart';
import '../../../routes/app_routes.dart';
import '../../e_provider/widgets/e_provider_til_widget.dart';

class GalleriesEProvider extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    return controller.singleProviderModel.value.gallery != null
        ? EProviderTilWidget(
            horizontalPadding: 0,
            conditionValue:
                controller.singleProviderModel.value.gallery!.isNotEmpty,
            // title: Text("Галерея".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
            title: Text("Galleries".tr,
                    style: Get.textTheme.subtitle2!
                        .copyWith(color: Get.theme.colorScheme.secondary))
                .paddingSymmetric(horizontal: 20),
            content: Container(
              height: 120,
              child: ListView.builder(
                  primary: false,
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      controller.singleProviderModel.value.gallery!.length,
                  itemBuilder: (_, index) {
                    var _media = controller.singleProviderModel.value.gallery!
                        .elementAt(index);
                    return InkWell(
                      onTap: () {
                        Get.toNamed(Routes.GALLERY, arguments: {
                          'media': controller.singleProviderModel.value.gallery,
                          'current': _media,
                          'heroTag': 'e_provide_galleries'
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsetsDirectional.only(
                            end: 20,
                            start: index == 0 ? 20 : 0,
                            top: 10,
                            bottom: 10),
                        child: Stack(
                            alignment: AlignmentDirectional.topStart,
                            children: [
                              Hero(
                                tag: 'e_provide_galleries' +
                                    _media.imgId.toString(),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: CachedNetworkImage(
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageUrl: _media.imgUrlThumb!,
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
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 12, top: 8),
                                child: Text(
                                  _media.dataTitle ?? '',
                                  maxLines: 2,
                                  style: Get.textTheme.bodyText2?.merge(
                                      TextStyle(color: Get.theme.primaryColor)),
                                ),
                              ),
                            ]),
                      ),
                    );
                  }),
            ),
          )
        : SizedBox();
  }
}
