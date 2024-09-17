import 'package:get/get.dart';
import 'package:emarates_bd/app/data/remote/eProvider/eProvider_data.dart';
import 'package:emarates_bd/app/models/singleProviderModel.dart';
import 'package:emarates_bd/app/services/connectivity_checker_service.dart';
import 'package:emarates_bd/common/Functions/handeldata.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../models/award_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/experience_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/e_provider_repository.dart';

class EProviderController extends GetxController {
  late RefreshController refreshController;

  StatusRequest statusRequest = StatusRequest.non;
  EproviderData eproviderData = EproviderData(Get.find());
  final eProvider = ProviderModel().obs;
  final reviews = <Review>[].obs;
  final awards = <Award>[].obs;
  final galleries = <Gallery>[].obs;
  final experiences = <Experience>[].obs;
  final featuredEServices = <EService>[].obs;
  final currentSlide = 0.obs;
  String heroTag = "";
  late EProviderRepository _eProviderRepository;
  final singleProviderModel = SingleProviderModel().obs;
  Map<String, String> workingHourEProvider = {};

  EProviderController() {
    _eProviderRepository = new EProviderRepository();
  }

  initRefresh() {
    refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    eProvider.value = arguments['eProvider'] as ProviderModel;
    heroTag = arguments['heroTag'] as String;
    super.onInit();
  }

  getEProviderDetails() async {
    statusRequest = StatusRequest.loading;
    update();
    print("Eprovider Id : ${eProvider.value.id}");
    var response =
        await eproviderData.getEProviderDetails(eProvider.value.id!.toString());
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response["success"] == true) {
        refreshController.refreshCompleted();
        Get.log(response["data"].toString());
        singleProviderModel.value =
            SingleProviderModel.fromJson(response["data"]);
        singleProviderModel.value.reviews?.forEach((element) {
          Get.log("name ${element.userDisplayName}");
        });
        if (singleProviderModel.value.workingHours == null) {
          statusRequest = StatusRequest.non;
          update();
        }
        update();
        return true;
      } else {
        refreshController.refreshFailed();
        statusRequest = StatusRequest.failure;
        print("false");
        return false;
      }
    }
    update();
  }

  String replaceFarsiNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], farsi[i]);
    }
    return input;
  }

  @override
  void onReady() async {
    await getEProviderDetails();
    // await getEProvider();
    super.onReady();
  }

  ConnectivityCheckerService connectivityCheckerService = Get.find();

  Future refreshEProvider({bool showMessage = false}) async {
    try {
      if (!connectivityCheckerService.isConnected) {
        refreshController.refreshFailed();
      } else {
        await getEProviderDetails();
      }
    } catch (error) {
      refreshController.refreshFailed();
    }
    // await getEproviderDetails();
    // await getFeaturedEServices();
    // await getAwards();
    // await getExperiences();
    // await getGalleries();
    // await getReviews();
    // if (showMessage) {
    //   Get.showSnackbar(Ui.SuccessSnackBar(message: eProvider.value.name + " " + "page refreshed successfully".tr));
    // }
  }

//  Future getEProvider() async {
//    try {
//      print("run");
//      print(eProvider.value.id);
//      statusRequest = StatusRequest.loading;
//      update() ;
//        await eproviderData.getEProvider(eProvider.value.id.toString()).then((value){
//          statusRequest = StatusRequest.success ;
//          update();
//        singleProviderModel = value! ;
//        print("Number Employee  ${singleProviderModel.employeesNumber})");
//      });
//    } catch (e) {
//      statusRequest = StatusRequest.failure;
//      print(e.toString());      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//    }
//  }

// Future getFeaturedEServices() async {
//   try {
//     featuredEServices.assignAll(await _eProviderRepository.getFeaturedEServices(eProvider.value.id, page: 1));
//   } catch (e) {
//     // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//   }
// }
//
// Future getReviews() async {
//   try {
//     reviews.assignAll(await _eProviderRepository.getReviews(eProvider.value.id));
//   } catch (e) {
//     // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//   }
// }
//
// Future getAwards() async {
//   try {
//     awards.assignAll(await _eProviderRepository.getAwards(eProvider.value.id));
//   } catch (e) {
//     // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//   }
// }
//
// Future getExperiences() async {
//   try {
//     experiences.assignAll(await _eProviderRepository.getExperiences(eProvider.value.id));
//   } catch (e) {
//     // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//   }
// }
//
// Future getGalleries() async {
//   try {
//     final _galleries = await _eProviderRepository.getGalleries(eProvider.value.id.toString());
//     galleries.assignAll(_galleries.map((e) {
//       e.image.name = e.description;
//       return e.image;
//     }));
//   } catch (e) {
//     // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//   }
// }
//
// void startChat() {
//   List<User> _employees = eProvider.value.employees.map((e) {
//     // e.avatar = eProvider.value.images[0];
//     return e;
//   }).toList();
//   Message _message = new Message(_employees, name: eProvider.value.name);
//   Get.toNamed(Routes.CHAT, arguments: _message);
// }
//
// launchCaller( String url) async {
//   try {
//     eProvider.value = await _eProviderRepository.callJustProvider(eProvider.value.id);
//   } catch (e) {
//     // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//   }
//   // var number = "tel:"+ url;
//   // if (await canLaunch(number)) {
//   //   await launch(number);
//   // } else {
//   //   // throw 'Could not launch $url';
//   // }
// }
}
