/*
 * Copyright (c) 2020 .
 */
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/data/remote/auth/logout.dart';
import 'package:emarates_bd/app/modules/events/controllers/events_controller.dart';
import 'package:emarates_bd/app/modules/events/views/events_view.dart';
import 'package:emarates_bd/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:emarates_bd/app/modules/home/controllers/home_controller.dart';
import 'package:emarates_bd/app/services/connectivity_checker_service.dart';
import 'package:emarates_bd/app/services/sheardPrefServices.dart';
import 'package:emarates_bd/common/Functions/handeldata.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../common/ui.dart';
import '../../../models/custom_page_model.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../account/views/account_view.dart';
import '../../global_widgets/show_tost.dart';
import '../../home/views/home2_view.dart';

class RootController extends GetxController {
  LogoutData logoutData = LogoutData(Get.find());
  ConnectivityCheckerService connectivityCheckerService = Get.find();

  HomeController homeController = Get.find<HomeController>();
  StatusRequest statusRequestLogout = StatusRequest.non;
  final isActive = true.obs;

  final currentIndex = 0.obs;
  final notificationsCount = 0.obs;
  final customPages = <CustomPage>[].obs;
  late NotificationRepository _notificationRepository;
  late CustomPageRepository _customPageRepository;

  SharedPrefServices sharedPrefServices = Get.find();

  late Menu selectedSideMenu;

  RootController() {
    _notificationRepository = new NotificationRepository();
    _customPageRepository = new CustomPageRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    // await getCustomPages();
  }

  selectMenu(Menu menu) {
    selectedSideMenu = menu;
    update();
  }

  Widget get currentPage => [
        ShowCaseWidget(
            onFinish: () {
              print("Finish");
              homeController.scrollController.animateTo(0.0,
                  duration: Duration(seconds: 1), curve: Curves.easeOut);
              sharedPrefServices.sharedPreferences!
                  .setBool("click show case", true);
            },
            autoPlay: true,
            autoPlayDelay: Duration(seconds: 5),
            enableAutoScroll: true,
            scrollDuration: Duration(milliseconds: 700),
            builder: Builder(builder: (context) => Home2View())),
        // BookingsView(),
        EventsViews(),
        // MessagesView(),
        // FavoritesView(),
        // FavoritesTabView(),
        AccountView(),
      ][currentIndex.value];

  /**
   * change page in route
   * */
  Future<void> changePageInRoot(int _index) async {
    if ((!Get.find<AuthService>().isAuth ||
            Get.find<AuthService>().user.value.email!.isEmpty) &&
        _index > 1) {
      await Get.toNamed(Routes.LOGIN);
    } else {
      currentIndex.value = _index;
      await refreshPage(_index);
    }
  }

  Future<void> changePageOutRoot(int _index) async {
    if ((!Get.find<AuthService>().isAuth ||
            Get.find<AuthService>().user.value.email!.isEmpty) &&
        _index > 1) {
      await Get.toNamed(Routes.LOGIN);
    }
    currentIndex.value = _index;
    await refreshPage(_index);
    await Get.offNamedUntil(Routes.ROOT, (Route route) {
      if (route.settings.name == Routes.ROOT) {
        return true;
      }
      return false;
    }, arguments: _index);
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.ROOT) {
      await changePageInRoot(_index);
    } else {
      await changePageOutRoot(_index);
    }
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<HomeController>().refreshHome();
          break;
        }
      case 1:
        {
          // await Get.find<BookingsController>().refreshBookings();
          await Get.find<EventsController>().refreshEvents();
          break;
        }
      // case 2:
      //   {
      //     await Get.find<MessagesController>().refreshMessages();
      //     break;
      //   }
      case 2:
        {
          // print('fav roor case');
          // await Get.find<FavoritesController>().refreshFavorites();
          await Get.put(FavoritesController());
          // await Get.lazyPut(()=>FavoritesController());
          // await Get.offAndToNamed(Routes.FAVORITES);
          break;
        }
    }
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }

  bool isBusinessOwner() {
    if (Get.find<AuthService>().user.value.userType != null) {
      if (Get.find<AuthService>().user.value.userType == 2) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Loading sign out ...".tr)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(onWillPop: () async => false, child: alert);
      },
    );
  }

  logOut(BuildContext context) async {
    if (connectivityCheckerService.isConnected) {
      statusRequestLogout = StatusRequest.loading;
      Get.back();
      showLoaderDialog(context);
      update();
      var response =
          await logoutData.logout(Get.find<AuthService>().user.value.apiToken!);
      statusRequestLogout = handlingData(response);
      print("$statusRequestLogout =====================");
      if (response["success"] == true) {
        await Get.find<AuthService>().removeCurrentUser();
        Get.back();
        Get.log("${response['message']}");
        ShowToast.showToast(ToastType.SUCCESS, "${response["message"]}");
        await Get.find<RootController>().changePage(0);
      } else {
        statusRequestLogout = StatusRequest.failure;
        Get.back();
        ShowToast.showToast(ToastType.ERROR, "${response["message"]}");
      }
    } else if (!Get.isSnackbarOpen &&
        connectivityCheckerService.isConnected == false) {
      Get.showSnackbar(Ui.NoInternetBar());
    }
    update();
  }
}

class Menu {
  final int index;

  final String text;
  final IconData icon;

  final void Function(BuildContext context) changePage;

  Menu(
      {required this.index,
      required this.text,
      required this.icon,
      required this.changePage});
}
