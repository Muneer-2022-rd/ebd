import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../../profile/bindings/profile_binding.dart';
import '../../profile/views/profile_view.dart';
import '../bindings/settings_binding.dart';
import '../views/addresses_view.dart';
import '../views/language_view.dart';
import '../views/theme_mode_view.dart';

class SettingsController extends GetxController {
  late PageController pageController;
  int currentIndex = 0;
  final pages = <String>[
    Routes.SETTINGS_LANGUAGE,
    Routes.PROFILE,
    Routes.SETTINGS_ADDRESSES,
    Routes.SETTINGS_THEME_MODE
  ];
  final pages1 = <Widget>[
    LanguageView(
      hideAppBar: true,
    ),
    ThemeModeView(
      hideAppBar: true,
    ),
    if (Get.find<AuthService>().isAuth &&
        Get.find<AuthService>().user.value.email!.isNotEmpty)
      ProfileView(
        hideAppBar: true,
      )
  ];

  List<int> idChipWidget = [
    0,
    1,
    if (Get.find<AuthService>().isAuth &&
        Get.find<AuthService>().user.value.email!.isNotEmpty)
      2
  ];
  List<String> titleChip = [
    "Language",
    "Theme Mode",
    if (Get.find<AuthService>().isAuth &&
        Get.find<AuthService>().user.value.email!.isNotEmpty)
      "Profile"
  ];

  void changePage(int index) {
    currentIndex = index;
    update();
  }

  void intiallPageController() {
    pageController = PageController(initialPage: currentIndex);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == Routes.PROFILE) {
      if (!Get.find<AuthService>().isAuth) {
        currentIndex = 0;
        Get.find<TabBarController>(tag: 'settings').selectedId.value = '0';
        Get.toNamed(Routes.LOGIN);
      }
      return GetPageRoute(
        settings: settings,
        page: () => ProfileView(hideAppBar: true),
        binding: ProfileBinding(),
      );
    }
    if (settings.name == Routes.SETTINGS_ADDRESSES) {
      if (!Get.find<AuthService>().isAuth) {
        currentIndex = 0;
        Get.find<TabBarController>(tag: 'settings').selectedId.value = '0';
        Get.toNamed(Routes.LOGIN);
      }
      return GetPageRoute(
        settings: settings,
        page: () => AddressesView(hideAppBar: true),
        binding: SettingsBinding(),
      );
    }

    if (settings.name == Routes.SETTINGS_LANGUAGE)
      return GetPageRoute(
        settings: settings,
        page: () => LanguageView(hideAppBar: true),
        binding: SettingsBinding(),
      );

    if (settings.name == Routes.SETTINGS_THEME_MODE)
      return GetPageRoute(
        settings: settings,
        page: () => ThemeModeView(hideAppBar: true),
        binding: SettingsBinding(),
      );

    return null;
  }

  @override
  void onInit() {
    if (Get.isRegistered<TabBarController>(tag: 'settings')) {
      Get.find<TabBarController>(tag: 'settings').selectedId.value = '0';
    }
    currentIndex = 0;
    super.onInit();
  }
}
