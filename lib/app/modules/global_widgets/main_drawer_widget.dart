/*
 * Copyright (c) 2020 .
 */

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/settings_service.dart';
import '../root/controllers/root_controller.dart' show Menu, RootController;
import 'drawer_link_widget.dart';

class MainDrawerWidget extends StatefulWidget {
  @override
  State<MainDrawerWidget> createState() => _MainDrawerWidgetState();
}

class _MainDrawerWidgetState extends State<MainDrawerWidget> {
  //          CustomPageDrawerLinkWidget(),
//          Get.find<AuthService>().isAuth &&
//                  Get.find<AuthService>().user.value.apiToken != null &&
//                  Get.find<AuthService>().user.value.email!.isNotEmpty
//              ? DrawerLinkWidget(
//                  icon: Icons.logout,
//                  text: "Logout",
//                  onTap: (e) async {

//                  },
//                )
//              : SizedBox(),
  List<Menu> menuList = [
    Menu(
        index: 0,
        text: "Home".tr,
        icon: Icons.home_outlined,
        changePage: (context) async {
          Timer(Duration(milliseconds: 300), () async {
            Get.back();
            await Get.find<RootController>().changePage(0);
          });
        }),
    Menu(
        index: 1,
        text: 'Categories'.tr,
        icon: Icons.folder_special_outlined,
        changePage: (context) {
          Timer(Duration(milliseconds: 300), () {
            Get.offAndToNamed(Routes.CATEGORIES);
          });
        }),
    Menu(
        index: 2,
        text: 'Cities'.tr,
        icon: Icons.location_city,
        changePage: (context) {
          Timer(Duration(milliseconds: 300), () {
            Get.offAndToNamed(Routes.all_cities);
          });
        }),
    // Menu(
    //     index: 3,
    //     text: 'Newly Added'.tr,
    //     icon: Icons.person,
    //     changePage: (context) {
    //       Timer(Duration(milliseconds: 300), () {
    //         Get.offAndToNamed(Routes.all_newly_added);
    //       });
    //     }),
    // Menu(
    //     index: 4,
    //     text: 'Featured Companies'.tr,
    //     icon: Icons.factory,
    //     changePage: (context) {
    //       Timer(Duration(milliseconds: 300), () {
    //         Get.offAndToNamed(Routes.all_featured);
    //       });
    //     }),
    if (Get.find<AuthService>().isAuth &&
        Get.find<AuthService>().user.value.apiToken != null &&
        Get.find<RootController>().isBusinessOwner() &&
        Get.find<AuthService>().user.value.email!.isNotEmpty)
      Menu(
        index: 5,
        text: "Add Listing".tr,
        icon: Icons.add_business,
        changePage: (context) {
          Timer(Duration(milliseconds: 300), () {
            Get.back();
            Get.toNamed(Routes.QUICK_LISTING);
          });
        },
      ),
    Menu(
      index: 6,
      text: 'Account'.tr,
      icon: Icons.folder_special_outlined,
      changePage: (context) {
        Timer(Duration(milliseconds: 300), () {
          Get.back();
          Get.find<RootController>().changePageInRoot(2);
        });
      },
    ),
    Menu(
      index: 7,
      text: "Settings".tr,
      icon: Icons.settings_outlined,
      changePage: (context) async {
        Timer(Duration(milliseconds: 300), () async {
          await Get.offAndToNamed(Routes.SETTINGS);
        });
      },
    ),
    // Menu(
    //   index: 8,
    //   text: 'Languages'.tr,
    //   icon: Icons.translate_outlined,
    //   changePage: (context) async {
    //     Timer(Duration(milliseconds: 300), () async {
    //       await Get.offAndToNamed(Routes.SETTINGS_LANGUAGE);
    //     });
    //   },
    // ),
    // Menu(
    //   index: 9,
    //   text: Get.isDarkMode ? "Light Theme".tr : "Dark Theme".tr,
    //   icon: Icons.brightness_6_outlined,
    //   changePage: (context) async {
    //     Timer(Duration(milliseconds: 300), () async {
    //       await Get.offAndToNamed(Routes.SETTINGS_THEME_MODE);
    //     });
    //   },
    // ),
    if (Get.find<AuthService>().isAuth &&
        Get.find<AuthService>().user.value.apiToken != null &&
        Get.find<AuthService>().user.value.email!.isNotEmpty)
      Menu(
        index: 10,
        text: "Logout".tr,
        icon: Icons.logout,
        changePage: (context) async {
          Timer(Duration(milliseconds: 300), () async {
            Get.closeCurrentSnackbar().then((value) async {
              await Get.find<RootController>().logOut(context);
            });
          });
        },
      ),
  ];

  @override
  void initState() {
    Get.find<RootController>().selectedSideMenu = menuList.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Obx(() {
            if (Get.find<AuthService>().isAuth &&
                Get.find<AuthService>().user.value.apiToken != null &&
                Get.find<AuthService>().user.value.email!.isNotEmpty) {
              return GestureDetector(
                onTap: () async {
                  Get.toNamed(Routes.PROFILE);
                },
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  accountName: Text(
                    "${Get.find<AuthService>().user.value.name} ${Get.find<AuthService>().user.value.lname}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  accountEmail: Text(
                    "${Get.find<AuthService>().user.value.email}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  currentAccountPicture: Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                          child: CachedNetworkImage(
                            height: 80,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: Get.find<AuthService>().user.value.img!,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 80,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                          //                          child: Image.network(
                          //                            Get.find<AuthService>().user.value.img!,
                          //                            height: 80,
                          //                            width: double.infinity,
                          //                            fit: BoxFit.cover,
                          //                            errorBuilder: (BuildContext context,
                          //                                Object exception, StackTrace? stackTrace) {
                          //                              return Icon(Icons.error_outline);
                          //                            },
                          //                            loadingBuilder: (BuildContext context, Widget child,
                          //                                ImageChunkEvent? loadingProgress) {
                          //                              return loadingProgress == null
                          //                                  ? child
                          //                                  : Image.asset(
                          //                                      'assets/img/loading.gif',
                          //                                      fit: BoxFit.cover,
                          //                                      width: double.infinity,
                          //                                      height: 80,
                          //                                    );
                          //                            },
                          //                          ),
                        ),
                      ),
                      //   right: 0,
                      // Positioned(
                      //   top: 0,
                      //   child: Get.find<AuthService>().user.value.verifiedPhone ?? false ? Icon(Icons.check_circle, color: Get.theme.colorScheme.secondary, size: 24) : SizedBox(),
                      // )
                    ],
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.LOGIN);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      top: 40.0, left: 15, right: 15, bottom: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome".tr,
                          style: Get.textTheme.headline5?.merge(TextStyle(
                              color: Get.theme.colorScheme.secondary))),
                      SizedBox(height: 5),
                      Text("Login account or create new one for free".tr,
                          style: Get.textTheme.bodyText1),
                      SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.LOGIN);
                            },
                            color: Get.theme.colorScheme.secondary,
                            height: 40,
                            elevation: 0,
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.exit_to_app_outlined,
                                    color: Get.isDarkMode
                                        ? Get.theme.hintColor
                                        : Get.theme.primaryColor,
                                    size: 24),
                                Text(
                                  "Login".tr,
                                  style: Get.textTheme.subtitle1?.merge(
                                      TextStyle(
                                          color: Get.isDarkMode
                                              ? Get.theme.hintColor
                                              : Get.theme.primaryColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            color: Get.theme.colorScheme.secondary,
                            height: 40,
                            elevation: 0,
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.exit_to_app_outlined,
                                    color: Get.isDarkMode
                                        ? Get.theme.hintColor
                                        : Get.theme.primaryColor,
                                    size: 24),
                                Text(
                                  "Register".tr,
                                  style: Get.textTheme.subtitle1?.merge(
                                      TextStyle(
                                          color: Get.isDarkMode
                                              ? Get.theme.hintColor
                                              : Get.theme.primaryColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(),
                          ),
                          MaterialButton(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            height: 40,
                            elevation: 0,
                            onPressed: () {
                              Get.toNamed(Routes.QUICK_LISTING);
                            },
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.person_add_outlined,
                                    color: Get.theme.hintColor, size: 24),
                                Text(
                                  "Quick Listing".tr,
                                  style: Get.textTheme.subtitle1?.merge(
                                      TextStyle(color: Get.theme.hintColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(),
                          ),
                        ],
                      ),
                      // SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            }
          }),
          SizedBox(
            height: Get.find<AuthService>().isAuth &&
                    Get.find<AuthService>().user.value.email != ""
                ? Get.size.height / 1.39
                : Get.size.height / 1.7,
            width: double.infinity,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                return GetBuilder<RootController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        DrawerLinkWidget(
                          menu: menuList[index],
                          selectedMenu: controller.selectedSideMenu,
                          onTap: (e) {
                            controller.selectMenu(menuList[index]);
                            menuList[index].changePage(context);
                          },
                          text: menuList[index].text,
                          icon: menuList[index].icon,
                        ),
                        if (index == 2)
                          ListTile(
                            dense: true,
                            title: Text(
                              "Application preferences".tr,
                              style: Get.textTheme.caption,
                            ),
                            trailing: Icon(
                              Icons.remove,
                              color: Get.theme.focusColor.withOpacity(0.3),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          //          SizedBox(height: 20),
          //          DrawerLinkWidget(
          //            icon: Icons.home_outlined,
          //            text: "Home",
          //            isActive:  true,
          //            onTap: (e) async {
          //              Get.back();
          //              controller.menuList[0].changePage() ;
          //            },
          //          ),
          //          DrawerLinkWidget(
          //            icon: Icons.folder_special_outlined,
          //            isActive: false,
          //            text: "Categories",
          //            onTap: (e) {
          //              Get.offAndToNamed(Routes.CATEGORIES);
          //            },
          //          ),
          //          // DrawerLinkWidget(
          //          //   icon: Icons.assignment_outlined,
          //          //   text: "Bookings",
          //          //   onTap: (e) async {
          //          //     Get.back();
          //          //     await Get.find<RootController>().changePage(1);
          //          //   },
          //          // ),
          //          // DrawerLinkWidget(
          //          //   icon: Icons.notifications_none_outlined,
          //          //   text: "Notifications",
          //          //   onTap: (e) {
          //          //     Get.offAndToNamed(Routes.NOTIFICATIONS);
          //          //   },
          //          // ),
          //          // DrawerLinkWidget(
          //          //   icon: Icons.favorite_outline,
          //          //   text: "Favorites",
          //          //   onTap: (e) async {
          //          //     await Get.offAndToNamed(Routes.FAVORITES);
          //          //   },
          //          // ),
          //          // DrawerLinkWidget(
          //          //   icon: Icons.chat_outlined,
          //          //   text: "Messages",
          //          //   onTap: (e) async {
          //          //     Get.back();
          //          //     await Get.find<RootController>().changePage(2);
          //          //   },
          //          // ),
          //          ListTile(
          //            dense: true,
          //            title: Text(
          //              "Application preferences".tr,
          //              style: Get.textTheme.caption,
          //            ),
          //            trailing: Icon(
          //              Icons.remove,
          //              color: Get.theme.focusColor.withOpacity(0.3),
          //            ),
          //          ),
          //          // DrawerLinkWidget(
          //          //   icon: Icons.account_balance_wallet_outlined,
          //          //   text: "Wallets",
          //          //   onTap: (e) async {
          //          //     await Get.offAndToNamed(Routes.WALLETS);
          //          //   },
          //          // ),
          //          Get.find<AuthService>().isAuth &&
          //                  Get.find<AuthService>().user.value.apiToken != null &&
          //                  controller.isBusinessOwner() &&
          //                  Get.find<AuthService>().user.value.email!.isNotEmpty
          //              ? DrawerLinkWidget(
          //            isActive:  false,
          //                  icon: Icons.add_business,
          //                  text: "Add Listing".tr,
          //                  onTap: (e) {
          //                    Get.toNamed(Routes.QUICK_LISTING);
          //                  },
          //                )
          //              : SizedBox(),
          //          DrawerLinkWidget(
          //            icon: Icons.person_outline,
          //            text: "Account",
          //            isActive: false,
          //            onTap: (e) async {
          //              Get.back();
          //              controller.changePageInRoot(2);
          ////              await Get.offAndToNamed(Routes.PROFILE);
          //            },
          //          ),
          //          DrawerLinkWidget(
          //            isActive: false,
          //            icon: Icons.settings_outlined,
          //            text: "Settings",
          //            onTap: (e) async {
          //              await Get.offAndToNamed(Routes.SETTINGS);
          //            },
          //          ),
          //          DrawerLinkWidget(
          //            isActive: false,
          //            icon: Icons.translate_outlined,
          //            text: "Languages",
          //            onTap: (e) async {
          //              await Get.offAndToNamed(Routes.SETTINGS_LANGUAGE);
          //            },
          //          ),
          //          DrawerLinkWidget(
          //            isActive: false,
          //            icon: Icons.brightness_6_outlined,
          //            text: Get.isDarkMode ? "Light Theme" : "Dark Theme",
          //            onTap: (e) async {
          //              await Get.offAndToNamed(Routes.SETTINGS_THEME_MODE);
          //            },
          //          ),
          //          ListTile(
          //            dense: true,
          //            title: Text(
          //              "Help & Privacy".tr,
          //              style: Get.textTheme.caption,
          //            ),
          //            trailing: Icon(
          //              Icons.remove,
          //              color: Get.theme.focusColor.withOpacity(0.3),
          //            ),
          //          ),
          //          DrawerLinkWidget(
          //            icon: Icons.help_outline,
          //            text: "Help & FAQ",
          //            onTap: (e) async {
          //              await Get.offAndToNamed(Routes.HELP);
          //            },
          //          ),
          //          CustomPageDrawerLinkWidget(),
          //          Get.find<AuthService>().isAuth &&
          //                  Get.find<AuthService>().user.value.apiToken != null &&
          //                  Get.find<AuthService>().user.value.email!.isNotEmpty
          //              ? DrawerLinkWidget(
          //                  icon: Icons.logout,
          //                  text: "Logout",
          //                  onTap: (e) async {
          //                    Get.closeCurrentSnackbar().then((value) async {
          //                      await controller.logOut(context);
          //                    });
          //                  },
          //                )
          //              : SizedBox(),
          Get.find<AuthService>().isAuth &&
                  Get.find<AuthService>().user.value.email != ""
              ? SizedBox()
              : Spacer(),
          if (Get.find<SettingsService>().setting.value.enableVersion!)
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 2, left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Version".tr +
                        " " +
                        Get.find<SettingsService>().setting.value.appVersion!,
                    style: Get.textTheme.caption,
                  ),
                  Icon(
                    Icons.remove,
                    color: Get.theme.focusColor.withOpacity(0.3),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
