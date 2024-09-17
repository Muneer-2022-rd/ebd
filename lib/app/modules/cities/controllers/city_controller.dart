import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/data/remote/cites/cites_data.dart';
import 'package:emarates_bd/app/repositories/e_provider_repository.dart';
import 'package:emarates_bd/common/Functions/handeldata.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../common/ui.dart';
import '../../../models/city_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/tag_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/city_repository.dart';
import '../../../models/e_service_model.dart';

enum CategoryFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class CityController extends GetxController {
  RefreshController refreshController = RefreshController(initialRefresh: true);
  CitesData citesData = CitesData(Get.find());
  StatusRequest statusRequest = StatusRequest.non;

  final city = City().obs;
  final reviews = <Review>[].obs;
  final tags = <Tag>[].obs;
  final optionGroups = <OptionGroup>[].obs;
  final currentSlide = 0.obs;
  final quantity = 1.obs;
  final heroTag = ''.obs;
  final eServices = <EService>[].obs;

  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;

  List<ProviderModel> providersCity = [];
  int currentPage = 1;

  int totalPage = 0;

  late CityRepository _cityRepository;
  late EProviderRepository _eProviderRepository;

  ScrollController scrollController = ScrollController();

  CityController() {
    _cityRepository = new CityRepository();
    _eProviderRepository = new EProviderRepository();
  }

  // @override
  // void onInit() async {
  //   var arguments = Get.arguments as Map<String, dynamic>;
  //   city.value = arguments['city_id'] as City;
  //   // heroTag.value = arguments['heroTag'] as String;
  //   await refreshEServices();
  //   super.onInit();
  // }

  Future<void> onInit() async {
    city.value = Get.arguments as City;
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
    //     // loadEServicesOfCity(city.value.id);
    //     loadEProviderOfCity(city.value.id);
    //   }
    // });
    // await refreshEServices();
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshCity();
    super.onReady();
  }

  Future refreshEServices({bool? showMessage}) async {
    print('test id citycontroler');

    // print(city.value.id);
    // await loadEServicesOfCity(city.value.id);
    // await loadEProviderOfCity(city.value.id);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of cities refreshed successfully".tr));
    }
    await messageCheck();
  }

  // Future loadEServicesOfCity(String cityId) async {
  //   try {
  //
  //     // isLoading.value = true;
  //     isDone.value = false;
  //     this.page.value++;
  //     List<EService> _eServices = [];
  //     // switch (filter) {
  //     //   case CategoryFilter.ALL:
  //         _eServices = await _eServiceRepository.getAllWithPaginationCities(cityId, page: this.page.value);
  //     //     break;
  //     //   case CategoryFilter.FEATURED:
  //     //     _eServices = await _eServiceRepository.getFeatured(categoryId, page: this.page.value);
  //     //     break;
  //     //   case CategoryFilter.POPULAR:
  //     //     _eServices = await _eServiceRepository.getPopular(categoryId, page: this.page.value);
  //     //     break;
  //     //   case CategoryFilter.RATING:
  //     //     _eServices = await _eServiceRepository.getMostRated(categoryId, page: this.page.value);
  //     //     break;
  //     //   case CategoryFilter.AVAILABILITY:
  //     //     _eServices = await _eServiceRepository.getAvailable(categoryId, page: this.page.value);
  //     //     break;
  //     //   default:
  //     //     _eServices = await _eServiceRepository.getAllWithPagination(categoryId, page: this.page.value);
  //     // }
  //     if (_eServices.isNotEmpty) {
  //       this.eServices.addAll(_eServices);
  //     } else {
  //       isDone.value = true;
  //     }
  //   } catch (e) {
  //     this.isDone.value = true;
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //

  // Future loadEProviderOfCity(String cityId) async {
  //   try {
  //
  //     // isLoading.value = true;
  //     isDone.value = false;
  //     this.page.value++;
  //     List<EProvider> _eProvider = [];
  //
  //         _eProvider = await _eProviderRepository.getAllWithPaginationCities(cityId, page: this.page.value);
  //
  //     if (_eProvider.isNotEmpty) {
  //       // print('provider city');
  //       // print(_eProvider.length);
  //      // this.eProviders.addAll(_eProvider);
  //     } else {
  //       isDone.value = true;
  //     }
  //   } catch (e) {
  //     this.isDone.value = true;
  //     // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  getEProviderOfCity({bool isRefresh = false, required String cityId}) async {
    print("run");
    statusRequest = StatusRequest.loading;
    if (isRefresh) {
      print("refresh");
      refreshController.resetNoData();
      currentPage = 1;
      update();
    } else {
      if (currentPage > totalPage) {
        refreshController.loadNoData();
      }
    }
    var response =
        await citesData.getProviderOfCitesWithPagenation(currentPage, cityId);
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response["success"] == true) {
        List responseBody = response['data'];
        if (isRefresh) {
          providersCity
              .addAll(responseBody.map((e) => ProviderModel.fromJson(e)));
        } else {
          providersCity
              .addAll(responseBody.map((e) => ProviderModel.fromJson(e)));
        }
        currentPage = currentPage + 1;
        totalPage = response["total"];
        print("current Page : $currentPage");
        print("total pages : $totalPage");
        print("Providers Cites : $providersCity");
        update();
        return true;
      } else {
        statusRequest = StatusRequest.failure;
        print("false");
        return false;
      }
    }
    update();
  }

  Future messageCheck() async {
    if (this.isDone == true) {
      isLoading.value = false;
      if (eServices.isEmpty)
        Get.showSnackbar(
            Ui.SuccessSnackBar(message: "Not Found In This City".tr));
    }
    isLoading.value = false;
  }

  Future refreshCity({bool showMessage = false}) async {
    await getCity();

    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: city.value.name! + " " + "page refreshed successfully".tr));
    }
  }

  Future getCity() async {
    try {
      city.value = await _cityRepository.get(city.value.id!);
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
