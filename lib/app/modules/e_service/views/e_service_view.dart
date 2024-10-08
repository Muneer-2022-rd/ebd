import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/media_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/e_service_controller.dart';
import '../widgets/e_provider_item_widget.dart';
import '../widgets/e_service_til_widget.dart';
import '../widgets/e_service_title_bar_widget.dart';
import '../widgets/option_group_item_widget.dart';
import '../widgets/review_item_widget.dart';

class EServiceView extends GetView<EServiceController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print('Get.find<AuthService>().user');
      print((Get.find<AuthService>().isAuth));
      var _eService = controller.eService.value;
      if(_eService.phone_description!.length ==0)
        _eService.phone_description="Call".tr;
      if(_eService.phone_description2!.length ==0)
        _eService.phone_description2="Call".tr;
      print('service desc');
      print( _eService.phone_description);
      print( _eService.phone_description2);
      print('service');
      // print( _eService.pic2.first);
      print( _eService.phone!.length);

      bool showAllReviews=false;
      var lim = 1;
      if (!_eService.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          // bottomNavigationBar: buildBottomWidget(_eService),
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshEService(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]),
                        child: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      ),
                      onPressed: () => {Get.back()},
                    ),
                    actions: [
                      new IconButton(
                        icon: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Get.theme.primaryColor.withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ]),
                          child: (_eService?.isFavorite ?? false) ? Icon(Icons.favorite, color: Colors.orangeAccent) : Icon(Icons.favorite_outline, color: Get.theme.hintColor),
                        ),
                        onPressed: () {
                          if (!Get.find<AuthService>().isAuth) {
                            Get.toNamed(Routes.LOGIN);
                          } else {
                            if (_eService?.isFavorite ?? false) {
                              controller.removeFromFavorite();
                            } else {
                              controller.addToFavorite();
                            }
                          }
                        },
                      ).marginSymmetric(horizontal: 10),
                    ],
                    bottom: buildEServiceTitleBarWidget(_eService),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background:
                      // Obx(() {
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[



                          CachedNetworkImage(
                            width: double.infinity,
                            height: 350,
                            fit: BoxFit.cover,
                            imageUrl: _eService.pic!,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          ),


                          // buildCarouselSlider(_eService),
                          // buildCarouselBullets(_eService),
                        ],
                      ),
                      // }),
                    ).marginOnly(bottom: 50),
                  ),

                  // WelcomeWidget(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        buildContactUs(_eService),
                        SizedBox(height: 10),
                        buildCategories(_eService),
                        EServiceTilWidget(
                          // title: Text("Описание".tr, style: Get.textTheme.subtitle2),
                          title: Text("Description".tr, style: Get.textTheme.subtitle2),
                          content: Ui.applyHtml(_eService.description!, style: Get.textTheme.bodyText1),
                        ),
                        // buildDuration(_eService),
                        if (_eService.addresses!.isNotEmpty)
                          buildAddress(),
                        if (_eService.tags!.isNotEmpty)
                          buildTags(_eService),
                        // buildOptions(),
                        buildServiceProvider(_eService),
                        if (_eService.images!.isNotEmpty)
                          EServiceTilWidget(
                            horizontalPadding: 0,
                            // title: Text("Галерея".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
                            title: Text("Galleries".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
                            content: Container(
                              height: 120,
                              child: ListView.builder(
                                  primary: false,
                                  shrinkWrap: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _eService.gallery!.length,
                                  itemBuilder: (_, index) {
                                    var _media = _eService.gallery!.elementAt(index);
                                    return InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.GALLERY, arguments: {'media': _eService.gallery, 'current': _media, 'heroTag': 'e_services_galleries'});
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 10, bottom: 10),
                                        child: Stack(
                                          alignment: AlignmentDirectional.topStart,
                                          children: [
                                            Hero(
                                              tag: 'e_services_galleries' + (_media?.id ?? ''),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                child: CachedNetworkImage(
                                                  height: 100,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  imageUrl: _media.thumb!,
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
                                            // Padding(
                                            //   padding: const EdgeInsetsDirectional.only(start: 12, top: 8),
                                            //   child: Text(
                                            //     _media.name ?? '',
                                            //     maxLines: 2,
                                            //     style: Get.textTheme.bodyText2.merge(TextStyle(
                                            //       color: Get.theme.primaryColor,
                                            //       shadows: <Shadow>[
                                            //         Shadow(
                                            //           offset: Offset(0, 1),
                                            //           blurRadius: 6.0,
                                            //           color: Get.theme.hintColor.withOpacity(0.6),
                                            //         ),
                                            //       ],
                                            //     )),
                                            //   ),
                                            // ),

                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            actions: [
                              // TODO View all galleries
                            ],
                          ),

//                        EServiceTilWidget(
//                          title: Text("Reviews & Ratings".tr, style: Get.textTheme.subtitle2),
//                          // title: Text("Обзоры и рейтинги".tr, style: Get.textTheme.subtitle2),
//                          content: Column(
//                            children: [
//                              Text(_eService.rate.toString(), style: Get.textTheme.headline1),
//                              Wrap(
//                                children: Ui.getStarsList(_eService.rate!, size: 32),
//                              ),
//
//                              new GestureDetector(
//                                onTap: () {
//                                  if (!controller.reviews.isEmpty)
//                                  Get.toNamed(Routes.SERVICESREVIEW);
//                                },
//                                child: new
//                                Text(
//                                  // "Отзывы (%s)".trArgs([_eService.totalReviews.toString()]),
//                                  "Reviews (%s)".trArgs([_eService.totalReviews.toString()]),
//                                  style: Get.textTheme.caption,
//                                ).paddingOnly(top: 10),
//                              ),
//
//
//                              Divider(height: 35, thickness: 1.3),
//                              // if(showAllReviews ==false)
//                              Obx(() {
//                                if(showAllReviews ==true){
//                                  lim = controller.reviews.length;
//                                  print('lim');
//                                  print(lim);
//                                }
//
//
//                                if (controller.reviews.isEmpty) {
//                                  return CircularLoadingWidget(height: 100);
//                                }
//                                return ListView.separated(
//                                  padding: EdgeInsets.all(0),
//                                  itemBuilder: (context, index) {
//                                    print('review');
//                                    print(controller.reviews.length);
//                                    return ReviewItemWidget(review: controller.reviews.elementAt(index));
//
//                                  },
//                                  separatorBuilder: (context, index) {
//                                    return Divider(height: 35, thickness: 1.3);
//
//                                  },
//                                  itemCount: controller.reviews.length < 2 ? controller.reviews.length : 2,
//                                  // itemCount: controller.reviews.length,
//                                  primary: false,
//                                  shrinkWrap: true,
//                                );
//
//                              }),
//
//
//                              SizedBox(height: 20),
//                              BlockButtonWidget(
//                                  text: Stack(
//                                    alignment: AlignmentDirectional.centerEnd,
//                                    children: [
//                                      SizedBox(
//                                        width: double.infinity,
//                                        child: Text(
//                                          "Leave a Review".tr,
//                                          textAlign: TextAlign.center,
//                                          style: Get.textTheme.headline6?.merge(
//                                            TextStyle(color: Get.theme.primaryColor),
//                                          ),
//                                        ),
//                                      ),
//                                      Icon(Icons.star_outlined, color: Get.theme.primaryColor, size: 22)
//                                    ],
//                                  ),
//                                  color: Get.theme.colorScheme.secondary,
//                                  onPressed: () {
//                                    Get.toNamed(Routes.RATING, arguments: {
//                                      'service': _eService
//                                    });
//                                  }),
//
//
//
//                            ],
//                          ),
//                          actions: [
//                            // TODO view all reviews
//                          ],
//                        ),
                      ],
                    ),
                  ),
                ],
              )),

        );
      }
    });
  }

  Container buildContactUs(EService _eService) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("Связаться с нами".tr, style: Get.textTheme.subtitle2),
                Text("Contact us".tr, style: Get.textTheme.subtitle2),
                // Text("Если у вас есть какие-либо вопросы!".tr, style: Get.textTheme.caption),
                Text("If your have any question!".tr, style: Get.textTheme.caption),
              ],
            ),
          ),

          Column(
            // children: [
            // Wrap(
            //   spacing: 5,
            children: [
              if(_eService.phone != null && _eService.phone!.length >6)
                SizedBox(
                  width: 140, // <-- Your width
                  height: 44, // <-- Your height
                  child:
                  MaterialButton(
                    onPressed: () {
                      // launch("tel:${controller.eProvider.value.mobileNumber}");
                      if (Get.find<AuthService>().isAuth) {
                        controller.launchCaller(_eService.phone!);
                        launch("tel:${_eService.phone}");
                      }
                      else
                        Get.showSnackbar(Ui.defaultSnackBar(message: "Register to make this feature available".tr));

                    },
                    height: 44,
                    minWidth: 44,
                    padding: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    // color: Get.theme.colorScheme.primary,
                    // color: Colors.green,
                    color: Color.fromARGB(255,246, 164, 44),
                    // child: Icon(
                    //   Icons.phone_android_outlined,
                    //   color: Get.theme.colorScheme.secondary,
                    // ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center ,//Center Column contents vertically,
                        crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                        children:[
                          Flexible(
                            child:
                            FittedBox(
                              fit: BoxFit.cover,
                              child:Text(_eService.phone_description! ,  style: TextStyle( fontSize: 10,color: Colors.black),),
                            ),
                          ),
                        ]),
                    // child: Text(_eService.phone_description, style: TextStyle(
                    //   color: Get.theme.colorScheme.secondary,
                    // ),
                    // ),
                    elevation: 0,
                  ),
                ),
              SizedBox(height: 5,),
              if(_eService.phone2 != null && _eService.phone2!.length >6)
                SizedBox(
                  width: 140, // <-- Your width
                  height: 44, // <-- Your height
                  child:
                  MaterialButton(
                    onPressed: () {
                      if (Get.find<AuthService>().isAuth) {
                        controller.launchCaller(_eService.phone!);
                        launch("tel:${_eService.phone2}");
                      }
                      else
                        Get.showSnackbar(Ui.defaultSnackBar(message: "Register to make this feature available".tr));


                    },
                    height: 44,
                    minWidth: 44,
                    padding: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Color.fromARGB(255,246, 164, 44),
                    // child: Icon(
                    //   Icons.call_outlined,
                    //   color: Get.theme.colorScheme.secondary,
                    // ),
                    child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center ,//Center Column contents vertically,
                        crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                        children:[
                          Flexible(
                            child:
                            FittedBox(
                              fit: BoxFit.cover,
                              child:
                              Text(_eService.phone_description2! ,  style: TextStyle( fontSize: 10,color:  Colors.black,), textAlign: TextAlign.center,),
                            ),
                          ),
                          // child: Text(_eService.phone_description2 ?? "Call".tr, style: TextStyle(
                          //   color: Get.theme.colorScheme.secondary,
                          // ),
                          // ),
                        ]),
                    elevation: 0,
                  ),
                ),
              SizedBox(height: 5,),
              SizedBox(
                width: 140, // <-- Your width
                height: 44, // <-- Your height
                child:  MaterialButton(
                  onPressed: () {
                    Get.toNamed(Routes.Mail, arguments: {
                      'service': _eService
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  color: Color.fromARGB(255,246, 164, 44),
                  padding: EdgeInsets.all(8),
                  height: 44,
                  minWidth: 44,
                  // child: Icon(
                  //   Icons.chat_outlined,
                  //   color: Get.theme.colorScheme.secondary,
                  // ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center ,//Center Column contents vertically,
                      crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
                      children:[
                        Flexible(
                          child:
                          FittedBox(
                            fit: BoxFit.cover,
                            child:Text("Send a message".tr,  style: TextStyle( fontSize: 10,color:  Colors.black,),),
                          ),
                        ),
                      ]),

                  // Text("Send a message".tr, style: TextStyle(
                  //   color: Get.theme.colorScheme.secondary,
                  // ),
                  // ),
                  elevation: 0,
                ),
              )

              //
              // MaterialButton(
              //   onPressed: () {
              //     controller.startChat();
              //   },
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //   color: Get.theme.colorScheme.secondary.withOpacity(0.2),
              //   padding: EdgeInsets.zero,
              //   height: 44,
              //   minWidth: 44,
              //   child: Icon(
              //     Icons.chat_outlined,
              //     color: Get.theme.colorScheme.secondary,
              //   ),
              //   elevation: 0,
              // ),
            ],
            // )
            // ],
          )

        ],
      ),
    );
  }

  Widget buildOptions() {
    return Obx(() {
      if (controller.optionGroups.isEmpty) {
        return SizedBox(height: 0);
      }
      return EServiceTilWidget(
        horizontalPadding: 0,
        title: Text("Options".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
        // title: Text("Опции".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
        content: ListView.separated(
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return OptionGroupItemWidget(optionGroup: controller.optionGroups.elementAt(index));
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 6);
          },
          itemCount: controller.optionGroups.length,
          primary: false,
          shrinkWrap: true,
        ),
      );
    });
  }

  Container buildDuration(EService _eService) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                // Text("Duration".tr, style: Get.textTheme.subtitle2),
                Text("Продолжительность".tr, style: Get.textTheme.subtitle2),
                // Text("This service can take up to ".tr, style: Get.textTheme.bodyText1),
                Text("Эта услуга может занимать до".tr, style: Get.textTheme.bodyText1),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          Text(_eService.duration!, style: Get.textTheme.headline6),
        ],
      ),
    );
  }


  Container buildTags(EService _eService) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                // Text("Тэги     ".tr, style: Get.textTheme.subtitle2),
                Text("Tags".tr, style: Get.textTheme.subtitle2),
                // Text("This service can take up to ".tr, style: Get.textTheme.bodyText1),
                Text(Tags_text(_eService),style: Get.textTheme.bodyText1 ),
                // Text("Эта услуга может занимать до".tr, style: Get.textTheme.bodyText1),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          // Text(_eService.duration, style: Get.textTheme.headline6),
        ],
      ),
    );
  }




  CarouselSlider buildCarouselSlider(EService _eService) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,

        autoPlayInterval: Duration(seconds: 7),
        height: 370,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _eService.images?.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag.value + _eService.id!,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                imageUrl: _eService.pic!,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(EService _eService) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _eService.images!.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value == _eService.images!.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  EServiceTitleBarWidget buildEServiceTitleBarWidget(EService _eService) {
    return EServiceTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _eService.name ?? '',
                  style: Get.textTheme.headline5!.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              if (_eService.eProvider == null)
                Container(
                  child: Text("  .  .  .  ".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyText2!.merge(
                        TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              if (_eService.eProvider != null && _eService.eProvider!.available!)
                Container(
                  // child: Text("Доступный".tr,
                  child: Text("Available".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyText2?.merge(
                        TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              // if (_eService.eProvider != null && !_eService.eProvider.available)
              //   Container(
              //     // child: Text("Не в сети".tr,
              //         child: Text("Offline".tr,
              //         maxLines: 1,
              //         style: Get.textTheme.bodyText2.merge(
              //           TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
              //         ),
              //         softWrap: false,
              //         textAlign: TextAlign.center,
              //         overflow: TextOverflow.fade),
              //     decoration: BoxDecoration(
              //       color: Colors.grey.withOpacity(0.2),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              //     margin: EdgeInsets.symmetric(vertical: 3),
              //   ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: List.from(Ui.getStarsList(_eService.rate!))
                    ..addAll([
                      SizedBox(width: 5),
                      Text(
                        "Reviews (%s)".trArgs([_eService.totalReviews.toString()]),
                        // "Отзывы (%s)".trArgs([_eService.totalReviews.toString()]),
                        style: Get.textTheme.caption,
                      ),
                    ]),
                ),
              ),
              if(_eService.eProvider !=null)
                for (var i = 0; i < _eService.eProvider!.price_level!; i++)
                  Text(
                    '\$',
                    style: Get.textTheme.headline3?.merge(TextStyle(color: Get.theme.colorScheme.secondary)),

                  ),
              // Ui.getPrice(
              //   _eService.getPrice,
              //   style: Get.textTheme.headline3.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
              //   unit: _eService.getUnit,
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategories(EService _eService) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: List.generate(_eService.categories!.length, (index) {
          var _category = _eService.categories!.elementAt(index);
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(_category.name!, style: Get.textTheme.bodyText1?.merge(TextStyle(color: _category.color))),
            decoration: BoxDecoration(
                color: _category.color!.withOpacity(0.2),
                border: Border.all(
                  color: _category.color!.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          );
        }) +
            List.generate(_eService.subCategories!.length, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_eService.subCategories!.elementAt(index).name!, style: Get.textTheme.caption),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    border: Border.all(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }),
      ),
    );
  }

  Widget buildServiceProvider(EService _eService) {
    if (_eService.eProvider?.hasData ?? false) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.E_PROVIDER, arguments: {'eProvider': _eService.eProvider, 'heroTag': 'e_service_details'});
        },
        child: EServiceTilWidget(
          // title: Text("Поставщик услуг".tr, style: Get.textTheme.subtitle2),
          title: Text("Service Provider".tr, style: Get.textTheme.subtitle2),
          content: EProviderItemWidget(provider: _eService.eProvider!),
          actions: [
            // Text("Посмотреть больше".tr, style: Get.textTheme.subtitle1),
            Text("View More".tr, style: Get.textTheme.subtitle1),
          ],
        ),
      );
    } else {
      return EServiceTilWidget(
        title: Text("Service Provider".tr, style: Get.textTheme.subtitle2),
        content: SizedBox(
          height: 60,
        ),
        actions: [],
      );
    }
  }

  static Future<void> openMap( double latitude, double longitude) async {

    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Container buildAddress() {
    var  _eService = controller.eService.value ;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(

            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric( vertical: 15), //apply padding horizontal or vertical only
                  child:                Text("Address".tr, style: Get.textTheme.subtitle2),
                ),

                if(_eService.addresses!.length >0)
                  Text(_eService.addresses![0].address ?? '', style: Get.textTheme.bodyText1),
                // Text("Эта услуга может занимать до".tr, style: Get.textTheme.bodyText1),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                  ),
                  onPressed: (){

                    openMap(_eService.addresses![0].latitude! ,_eService.addresses![0].longitude!);

                  },
                  child: Text('Get direction'.tr,
                    style :Get.textTheme.subtitle1,
                  ),

                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          // Text(_eService.duration, style: Get.textTheme.headline6),
        ],
      ),
    );
  }



  Widget? buildBottomWidget(EService _eService) {
    if(_eService.phone!.length > 0 )
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
            if (_eService.priceUnit == 'fixed')
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    // MaterialButton(
                    //   height: 24,
                    //   minWidth: 46,
                    //   onPressed: controller.decrementQuantity,
                    //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    //   color: Get.theme.colorScheme.secondary,
                    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(10))),
                    //   child: Icon(Icons.remove, color: Get.theme.primaryColor, size: 28),
                    //   elevation: 0,
                    // ),
                    // SizedBox(
                    //   width: 38,
                    //   child: Obx(() {
                    //     return Text(
                    //       controller.quantity.toString(),
                    //       textAlign: TextAlign.center,
                    //       style: Get.textTheme.subtitle2.merge(
                    //         TextStyle(color: Get.theme.colorScheme.secondary),
                    //       ),
                    //     );
                    //   }),
                    // ),
                    // MaterialButton(
                    //   onPressed: controller.incrementQuantity,
                    //   height: 24,
                    //   minWidth: 46,
                    //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    //   color: Get.theme.colorScheme.secondary,
                    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(10))),
                    //   child: Icon(Icons.add, color: Get.theme.primaryColor, size: 28),
                    //   elevation: 0,
                    // ),
                  ],
                ),
              ),
            // if (_eService.priceUnit == 'fixed') SizedBox(width: 10),
            // Expanded(
            //   child: BlockButtonWidget(
            //       text: Container(
            //         height: 24,
            //         alignment: Alignment.center,
            //         child: Text(
            //           "Позвоните, чтобы забронировать".tr,
            //           // "Call To Book".tr,
            //           textAlign: TextAlign.center,
            //           style: Get.textTheme.headline6.merge(
            //             TextStyle(color: Get.theme.primaryColor),
            //           ),
            //         ),
            //       ),
            //       color: Get.theme.colorScheme.secondary,
            //       onPressed: () {
            //         Get.toNamed(Routes.BOOK_E_SERVICE, arguments: {'eService': _eService, 'options': controller.getCheckedOptions(), 'quantity': controller.quantity.value});
            //       }),
            //
            // ),

            // if(_eService.phone.length > 0 )
            Row(
                children:[
                  Expanded(
                    child: BlockButtonWidget(
                        text: Container(
                          height: 24,
                          alignment: Alignment.center,
                          child: Text(
                            // "Позвоните, чтобы забронировать".tr,
                            "Call Now".tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline6?.merge(
                              TextStyle(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                        color: Get.theme.colorScheme.secondary,

                        onPressed: () {
                          launch("tel:${_eService.phone}");
                          // controller.launchCaller(_eService.phone);
                        }),

                  ),
                ]),

            /////////////////////   call button
            // MaterialButton(
            //   onPressed: () {
            //     controller.launchCaller(_eService.phone);
            //
            //   },
            //   // _launchCaller(),
            //   height: 24,
            //   minWidth: 46,
            //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            //   color: Get.theme.colorScheme.secondary,
            //   // shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all( Radius.circular(10))),
            //   child: Icon(Icons.phone , color: Get.theme.primaryColor, size: 28),
            //   elevation: 0,
            // ),
          ],
        ).paddingOnly(right: 20, left: 20),
      );
  }
  String Tags_text (EService _eService){
    var tags_word='';
    for(var i = 0; i < _eService.tags!.length; i++)
      if (i==0)
        tags_word +=  _eService.tags![i].tag!;
      else
        tags_word += ' - ' +_eService.tags![i].tag!;
    return tags_word;
  }
}
