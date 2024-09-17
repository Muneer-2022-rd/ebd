import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:emarates_bd/app/data/remote/Search/seearch_data.dart';
import 'package:emarates_bd/app/models/city_model.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';
import 'package:emarates_bd/app/modules/global_widgets/show_tost.dart';
import 'package:emarates_bd/app/repositories/city_repository.dart';
import 'package:emarates_bd/app/repositories/e_provider_repository.dart';
import 'package:emarates_bd/app/services/sheardPrefServices.dart';
import 'package:emarates_bd/common/Functions/handeldata.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../routes/app_routes.dart';

class CustomSearchController extends GetxController {
  SearchData searchData = SearchData(Get.find());
  StatusRequest searchStatusRequest = StatusRequest.non;
  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<Marker> markers = [];

  SharedPrefServices sharedPrefServices = Get.find();

  final heroTag = "".obs;
  final categories = <Category>[].obs;
  final cities = <City>[].obs;
  final selectedCategories = <String>[].obs;
  final selectedCity = <String>[].obs;
  TextEditingController textEditingController = TextEditingController();
  final isChecked = true.obs;

  String? cityId;

  final eServices = <EService>[].obs;
  List<ProviderModel> eProvider = [];
  int currentPage = 1;

  int totalPage = 0;

  late EServiceRepository _eServiceRepository;
  late EProviderRepository _eProviderRepository;
  late CategoryRepository _categoryRepository;
  late CityRepository _cityRepository;

  CustomSearchController() {
    _eServiceRepository = new EServiceRepository();
    _eProviderRepository = new EProviderRepository();
    _categoryRepository = new CategoryRepository();
    _cityRepository = new CityRepository();
    textEditingController = new TextEditingController();
  }

  @override
  void onInit() async {
    await refreshSearch();
    super.onInit();
  }

  @override
  void dispose() {
    eProvider.clear();
    eProvider = [];
    searchStatusRequest = StatusRequest.non;
    markers.clear();
    textEditingController.dispose();
    textEditingController.text = "";
    update();
    super.dispose();
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments ?? "";
    super.onReady();
  }

  Future refreshSearch({bool? showMessage}) async {
    // await getCategories();
    await getCities();
    // await searchEServices();
    // await searchEServicesByCities();
    // searchEProvidersByCities();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of Listings refreshed successfully".tr));
    }
  }

  // Future searchEServices({String keywords}) async {
  //   try {
  //     if (selectedCategories.isEmpty) {
  //       eServices.assignAll(await _eServiceRepository.search(keywords, categories.map((element) => element.id).toList()));
  //     } else {
  //       eServices.assignAll(await _eServiceRepository.search(keywords, selectedCategories.toList()));
  //     }
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  Future searchEServicesByCities({String? keywords}) async {
    try {
      if (selectedCity.isEmpty) {
        // selectedCity.add('0');
        eServices.assignAll(await _eServiceRepository.search(
            keywords!, cities.map((element) => element.id!).toList()));
        // eServices.assignAll(await _eServiceRepository.search(keywords, selectedCity.toList()));
      } else {
        eServices.assignAll(
            await _eServiceRepository.search(keywords!, selectedCity.toList()));
      }
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  searchProviders({bool isBannerSearch = false}) async {
    searchStatusRequest = StatusRequest.non;
    update();
    if (isBannerSearch) {
      eProvider.clear();
      markers.clear();
      markers = [];
      eProvider = [];
      searchStatusRequest = StatusRequest.loading;
      print("refresh");
      refreshController.resetNoData();
      currentPage = 1;
      update();
    } else {
      if (currentPage > totalPage) {
        refreshController.loadNoData();
      }
    }
    var response = await searchData.searchProviderWithCites(
        cityId ?? "", textEditingController.text, currentPage);
    searchStatusRequest = handlingData(response);
    if (StatusRequest.success == searchStatusRequest) {
      if (response["success"] == true) {
        List responseBody = response["data"];
        if (isBannerSearch) {
          eProvider.addAll(responseBody.map((e) => ProviderModel.fromJson(e)));
          update();
          await setMarkerSearch();
        } else {
          eProvider.addAll(responseBody.map((e) => ProviderModel.fromJson(e)));
          update();
        }
        currentPage = currentPage + 1;
        totalPage = response["total"];
        return true;
      } else {
        searchStatusRequest = StatusRequest.noData;
        update();
        print("false to search");
        return false;
      }
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    Uint8List value =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();
    return value;
  }

  setMarkerSearch() {
    eProvider.forEach(
      (eProvider) async {
        if (eProvider.lat!.isNotEmpty &&
            eProvider.lng!.isNotEmpty &&
            double.parse(eProvider.lat ?? '0').ceil() != 0 &&
            double.parse(eProvider.lng ?? '0').ceil() != 0) {
          markers.add(
            Marker(
              markerId: MarkerId(
                eProvider.id.toString(),
              ),
              infoWindow: InfoWindow(
                onTap: () {
                  Get.toNamed(Routes.E_PROVIDER, arguments: {
                    'eProvider': eProvider,
                    'heroTag': 'search_list'
                  });
                },
                title: "${eProvider.name}".tr,
                snippet: "${eProvider.city}",
              ),
              icon: BitmapDescriptor.fromBytes(
                  await getBytesFromAsset('assets/img/markerone.png', 100)),
              position: LatLng(
                double.parse(eProvider.lat!),
                double.parse(eProvider.lng!),
              ),
              onTap: () {},
            ),
          );
        }
        update();
      },
    );
  }

  //
  // Future searchEProvidersByCities({String keywords}) async {
  //   try {
  //     if (selectedCity.isEmpty) {
  //       // selectedCity.add('0');
  //       eProvider.assignAll(await _eProviderRepository.search(keywords, cities.map((element) => element.id).toList()));
  //       // eServices.assignAll(await _eServiceRepository.search(keywords, selectedCity.toList()));
  //
  //     } else {
  //       eProvider.assignAll(await _eProviderRepository.search(keywords, selectedCity.toList()));
  //     }
  //   } catch (e) {
  //     // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCities() async {
    try {
      cities.assignAll(await _cityRepository.getAll());
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isSelectedCategory(Category category) {
    return selectedCategories.contains(category.id);
  }

  bool isSelectedCity(City city) {
    return selectedCategories.contains(city.id);
  }

  void toggleCategory(bool value, Category category) {
    if (value) {
      selectedCategories.add(category.id!);
    } else {
      selectedCategories.removeWhere((element) => element == category.id);
    }
  }

  void toggleCity(bool value, City city) {
    selectedCity.clear();
    if (value) {
      cityId = city.id;
      selectedCity.add(city.id!);
    } else {
      cityId = "";
      selectedCity.removeWhere((element) => element == city.id);
    }
    Get.log("Select city  : ${selectedCity.toString()}");
    update();
  }

  void toggleSearchMethod(bool value) {
    isChecked.value = !isChecked.value;
    update();
  }

  resetPage() {
    eProvider.clear();
    searchStatusRequest = StatusRequest.non;
    markers.clear();
    textEditingController.text = "";
  }

  onChangeSearch(String value) {
    if (value.length == 0) {
      searchStatusRequest = StatusRequest.non;
      eProvider.clear();
      markers.clear();
      markers = [];
      eProvider = [];
      refreshController.refreshToIdle();
      update();
    }
  }
}
