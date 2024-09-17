import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class CategoriesCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 15),
      child: Obx(() {
        return ListView.builder(
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (_, index) {
              var _category = controller.categories.elementAt(index);

              // print('_category.image.url');
              // print(_category.svg);
              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.CATEGORY, arguments: _category);
                  // print( Get.toNamed(Routes.CATEGORY, arguments: _category));
                  // print('ss');
                },
                child: Container(
                  width: 100,
                  height: 500,
                  margin: EdgeInsetsDirectional.only(
                      end: 20, start: index == 0 ? 20 : 0),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: new BoxDecoration(
                    gradient:  LinearGradient(
                        colors: [
                          Get.theme.colorScheme.secondary,
                          Get.theme.colorScheme.secondary.withOpacity(.6)
                        ],
                        end: AlignmentDirectional.bottomEnd,
                        stops: [0.1, 0.9],
                        tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Padding(
                        // padding: EdgeInsetsDirectional.only(start: 16, top: 13,end: 16,bottom: 21),
                        padding: EdgeInsetsDirectional.only(
                            start: 5, top: 0, end: 4, bottom: 5),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 5, bottom: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child:
                              // (_category.image.url.toLowerCase().endsWith('.svg')
                              //     ? SvgPicture.network(
                              //         _category.image.url,
                              //         color: _category.color,
                              //       )
                              //
                              //     :
                              CachedNetworkImage(
                            //
                            fit: BoxFit.contain,
                            width: 45,
                            height: 45,
                            imageUrl: _category.svg!,
                            // imageUrl:SvgPicture.network(_category.svg,),

                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                          // ),
                        ),
                      ),
                      //
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.only(start: 0, top: 50),
                        //   child: Center(
                        //   child: Text(
                        //     _category.name,
                        //     maxLines: 2,
                        //     overflow: TextOverflow.ellipsis,
                        //     softWrap: true,
                        //     style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor,fontSize: 8.5,)),
                        //
                        //   ),
                        //
                        // ),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: new Container(
                                padding: new EdgeInsets.fromLTRB(3, 2, 3, 0),
                                child: new Text(
                                  _category.name!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style:
                                      Get.textTheme.bodyText2?.merge(TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Get.theme.primaryColor,
                                    fontSize: 10,
                                  )),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //   // child:Flexible(
                        //   //
                        //   //   flex: 1,
                        //   //   child: new Container(
                        //   //     padding: new EdgeInsets.all(3),
                        //   //     child: new Text(
                        //   //       _category.name,
                        //   //       overflow: TextOverflow.ellipsis,
                        //   //       maxLines: 3,
                        //   //       style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor,fontSize: 8.5,)),
                        //   //       softWrap: true,
                        //   //       textAlign: TextAlign.center,
                        //   //
                        //   //     ),
                        //   //   ),
                        //   // ),
                        //
                        //
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
