import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/data/remote/categories/categories_data.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';
import 'package:emarates_bd/app/repositories/e_provider_repository.dart';
import 'package:emarates_bd/common/Functions/handeldata.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../repositories/e_service_repository.dart';

enum CategoryFilter { ALL, RATING, FEATURED }
// enum CategoryFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class CategoryController extends GetxController {
  RefreshController refreshController = RefreshController(initialRefresh: true);
  CategoriesData categoriesData = CategoriesData(Get.find());
  StatusRequest statusRequest = StatusRequest.non;

  final category = new Category().obs;
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final eServices = <EService>[].obs;
  final providers = <ProviderModel>[].obs;
  final offerServices = <EService>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  String needs = '';
  late EServiceRepository _eServiceRepository;
  late EProviderRepository _eProviderRepository;
  ScrollController scrollController = ScrollController();

  List<ProviderModel> providersCategory = [];
  int currentPage = 1;

  int totalPage = 0;

  CategoryController() {
    _eServiceRepository = new EServiceRepository();
    _eProviderRepository = new EProviderRepository();
  }

  @override
  Future<void> onInit() async {
    // print('Get.runtimeType');
    // print(Get.arguments.runtimeType);
    // if(Get.arguments.runtimeType != String)
    //   category.value = Get.arguments as Category;
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
    //     loadEServicesOfCategory(category.value.id, filter: selected.value);
    //   }
    // });
    // print('Get.arguments.toString()');
    // print(Get.arguments.toString());
    // this.needs=Get.arguments.toString();
    // print('this.needs');
    // print('this.needs ' + this.needs);
    //
    // if(this.needs=='Offer of the week')
    //   await getOfferWeekEServices();
    // else
    // if(this.needs=='New Services')
    //   await getRecommendedEServices();
    // else
    // if(this.needs=='Providers')
    //   await getProvidersWithCategory(category.value.id);
    category.value = Get.arguments as Category;
    // await getProviders();
    // else
    //   await refreshEServices();
    // }
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshEServices({bool? showMessage}) async {
    await loadEServicesOfCategory(category.value.id!, filter: selected.value);
    messageCheck('EServices');
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of services refreshed successfully".tr));
    }
  }

  Future messageCheck(String services) async {
    if (services == 'EServices' &&
        this.isDone == true &&
        this.isLoading == false) {
      if (eServices.isEmpty && offerServices.isEmpty)
        Get.showSnackbar(Ui.SuccessSnackBar(message: "No Data Found".tr));
    }
  }

  Future getOfferWeekEServices() async {
    try {
      print('ctegory controller get offer');
      offerServices.assignAll(await _eServiceRepository.getOffer());
      // print('offers length :' + offerServices.length.toString());
      isLoading.value = false;
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getProviders() async {
    try {
      print('category controller get providers');
      providers.assignAll(await _eProviderRepository.getAllProvider());
      // print('provider length :' + providers.length.toString());
      isLoading.value = false;
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getProvidersWithCategoryWithFilter(String categoryId,
      {CategoryFilter? filter}) async {
    try {
      // print('category controller get providers w cat');
      providers.assignAll(await _eProviderRepository
          .getAllWithPagination(categoryId, page: this.page.value));
      // providers.assignAll(await _eProviderRepository.getAllProvider());
      // print('provider length :' + providers.length.toString());
      isLoading.value = false;
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  getEProviderOfCategoryWithOutFilter(
      {bool isRefresh = false, required String catId}) async {
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
    var response = await categoriesData.getProviderOfCategoriesWithPagenation(
        currentPage, catId);
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response["success"] == true) {
        List responseBody = response["data"];
        if (isRefresh) {
          providersCategory
              .addAll(responseBody.map((e) => ProviderModel.fromJson(e)));
        } else {
          providersCategory
              .addAll(responseBody.map((e) => ProviderModel.fromJson(e)));
        }
        currentPage = currentPage + 1;
        totalPage = response["total"];
        print("current Page : $currentPage");
        print("total pages : $totalPage");
        print("Providers category : $responseBody");
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

  Future getRecommendedEServices() async {
    try {
      offerServices.assignAll(await _eServiceRepository.getRecommended());
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    this.eServices.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadEServicesOfCategory(String categoryId,
      {CategoryFilter? filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<EService> _eServices = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _eServices = await _eServiceRepository
              .getAllWithPagination(categoryId, page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _eServices = await _eServiceRepository.getFeatured(categoryId,
              page: this.page.value);
          break;
        // case CategoryFilter.POPULAR:
        //   _eServices = await _eServiceRepository.getPopular(categoryId, page: this.page.value);
        //   break;
        case CategoryFilter.RATING:
          _eServices = await _eServiceRepository.getMostRated(categoryId,
              page: this.page.value);
          break;
        // case CategoryFilter.AVAILABILITY:
        //   _eServices = await _eServiceRepository.getAvailable(categoryId, page: this.page.value);
        //   break;
        default:
          _eServices = await _eServiceRepository
              .getAllWithPagination(categoryId, page: this.page.value);
      }

      if (_eServices.isNotEmpty) {
        this.eServices.addAll(_eServices);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
    await messageCheck('EServices');
  }
}
