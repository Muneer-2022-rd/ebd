import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';
import 'package:emarates_bd/app/models/event_model.dart';
import 'package:emarates_bd/app/repositories/e_provider_repository.dart';
import 'package:emarates_bd/app/repositories/event_repository.dart';
import 'package:emarates_bd/app/services/connectivity_checker_service.dart';
import 'package:emarates_bd/app/services/sheardPrefServices.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:ui' as ui;
import 'package:showcaseview/showcaseview.dart';
import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/city_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/slide_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/city_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../services/settings_service.dart';

class HomeController extends GetxController {
  ScrollController scrollController = ScrollController();
  int currentIndexToggle = 0;
  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(25.276987, 55.296249),
    zoom: 10.4746,
  );
  late RefreshController refreshController;

  List<String> bodyToggle = [
    "Sign up now and create your EmiratesBD account and get access to the full potential of the best business listing website in the UAE. Click here and join the rest of the UAE!",
    "Search for your business on the Emirates Business Directory. Did you find it? Click the Claim Listing button to gain control over it! Our team will contact you to verify and grant you access.",
    "Want your ads to appear on the EmiratesBD? Become a member to benefit from the free ad space available with each membership level.Or.. hit the request ads button and choose your ad package",
    "Your business is verified, and your ads are up and running. Now it’s time to see the results with the EmiratesBD. See the growth and post jobs applications to make it easier for people to find.Coming Soon.."
  ];

  late SliderRepository _sliderRepo;
  late CategoryRepository _categoryRepository;
  late CityRepository _cityRepository;
  late EventRepository _eventRepository;
  late EServiceRepository _eServiceRepository;
  late EProviderRepository _eproviderRepository;

  final addresses = <Address>[].obs;
  final slider = <Slide>[].obs;
  final sliderFront = <Slide>[].obs;
  final currentSlide = 0.obs;
  final currentSlider = 0.obs;

  final eServices = <EService>[].obs;
  final oServices = <EService>[].obs;
  final categories = <Category>[].obs;
  final cities = <City>[].obs;
  final events = <Event>[].obs;
  final featured = <Category>[].obs;
  final providers = <ProviderModel>[].obs;
  final featuredProviders = <ProviderModel>[].obs;

  ConnectivityCheckerService connectivityCheckerService = Get.find();

  bool loading = false;

  HomeController() {
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _cityRepository = new CityRepository();
    _eventRepository = new EventRepository();
    _eServiceRepository = new EServiceRepository();
    _eventRepository = new EventRepository();
    _eproviderRepository = new EProviderRepository();
  }

  initRefresh() {
    refreshController = RefreshController(initialRefresh: false);
  }

  SharedPrefServices sharedPrefServices = Get.find();

  @override
  Future<void> onInit() async {
    await refreshHome();
    super.onInit();
  }

  Future refreshHome({bool showMessage = false}) async {
    try {
      if (connectivityCheckerService.isConnected) {
        await getSlider();
        await getCategories();
        await getProviders();
        await getFeaturedProvider();
        await getCities();
        if (showMessage) {
          Get.showSnackbar(Ui.SuccessSnackBar(
              message: "Home page refreshed successfully".tr));
        }
      } else {
        refreshController.refreshFailed();
      }
    } catch (error) {}
  }

  Address get currentAddress {
    return Get.find<SettingsService>().address.value;
  }

  Future getSlider() async {
    try {
      slider.assignAll(await _sliderRepo.getHomeSlider());
      // slidertest=(await _sliderRepo.getHomeSlider2());
      print('slidertest');
      print(slider.length);
    } catch (e) {
      refreshController.refreshFailed();
      print('er');
      print(e);
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getSlideFront() async {
    try {
      await _sliderRepo.getHomeSlideFront().then((value) {
        sliderFront.value = value;
      });
    } catch (e) {
      refreshController.refreshFailed();
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      loading = true;
      update();
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      refreshController.refreshFailed();
      print('eee');
      print(categories.length);
      print(e.toString());
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCities() async {
    try {
      await _cityRepository.getAll().then((value) {
        cities.value = value;
        print("value : $value");
        if (value.length > 0 && value.isNotEmpty) {
          refreshController.refreshCompleted();
        } else {
          refreshController.refreshFailed();
        }
      }).catchError((error) {
//        Get.showSnackbar(Ui.ErrorSnackBar(message: "refresh Failed"));
        refreshController.refreshFailed();
      });
    } catch (e) {
      refreshController.refreshFailed();
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeatured() async {
    try {
      // featured.assignAll(await _categoryRepository.getFeatured());
      featured.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      refreshController.refreshFailed();
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getRecommendedEServices() async {
    try {
      eServices.assignAll(await _eServiceRepository.getRecommended());
    } catch (e) {
      refreshController.refreshFailed();
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getOfferWeekEServices() async {
    try {
      oServices.assignAll(await _eServiceRepository.getOffer());
    } catch (e) {
      refreshController.refreshFailed();
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEvents() async {
    try {
      events.assignAll(await _eventRepository.getAllEvents());
    } catch (e) {
      refreshController.refreshFailed();
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getProviders() async {
    try {
      providers.assignAll(await _eproviderRepository.getAllProvider());
    } catch (e) {
      refreshController.refreshFailed();
      print(e.toString());
    }
  }

  Future getFeaturedProvider() async {
    try {
      featuredProviders
          .assignAll(await _eproviderRepository.getFetauredProvider());
    } catch (e) {
      refreshController.refreshFailed();
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  onToggle(int index) {
    currentIndexToggle = index;
    update();
  }

  Future<bool> willPopExitApp() async {
    Get.defaultDialog(
        title: "Alert".tr,
        middleText: "Are you sure to exit ?".tr,
        middleTextStyle: TextStyle(color: Colors.black),
        content: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Are you sure to exit app ?".tr,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              exit(0);
            },
            child: Text("Yes".tr),
          ),
          MaterialButton(
            onPressed: () {
              Get.back();
            },
            child: Text("No".tr),
          ),
        ]);
    return true;
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

  Set<Marker> myMarker = {};

  setMarkerCustomImage(Marker newMarker) async {
    myMarker = {};
    update();
    myMarker.add(newMarker);
    update();
  }

//
// getLatestProviders()async {
//   statusRequest = StatusRequest.loading ;
//   var response = await homeData.getLatestProviders() ;
//   statusRequest =  handlingData(response);
//   if(StatusRequest.success == statusRequest){
//     if(response["success"] == true){
//       providers.addAll(response["data"]);
//       statusRequest = StatusRequest.failure ;
//       print("false") ;
//       return false ;
//     }
//   }
//   update();
// }
}
