import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/favorite_model.dart';
import '../../../repositories/e_service_repository.dart';

class FavoritesController extends GetxController {
  final favorites = <Favorite>[].obs;
 late  EServiceRepository _eServiceRepository;
  ScrollController scrollController = ScrollController();
  FavoritesController() {
    _eServiceRepository = new EServiceRepository();
  }

  @override
  void onInit() async {
    await refreshFavorites();
    super.onInit();
  }


  void initScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
         // refreshFavorites();
      }
    });
  }


  Future refreshFavorites({bool? showMessage}) async {
    print('refresh');
    await getFavorites();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of Services refreshed successfully".tr));
    }
  }




  Future getFavorites() async {
    try {
       favorites.assignAll(await _eServiceRepository.getFavorites());
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
