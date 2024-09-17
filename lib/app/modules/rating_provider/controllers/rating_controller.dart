import 'dart:async';

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../services/auth_service.dart';
import '../../root/controllers/root_controller.dart';

class RatingProviderController extends GetxController {
  final booking = Booking().obs;
  final review = new Review(rate: 0).obs;
  late BookingRepository _bookingRepository;
  final loading = false.obs;
  String textReview = '';
  double rate=1;
  RatingProviderController() {
    _bookingRepository = new BookingRepository();
  }

  @override
  void onInit() {
    review.value.user = Get.find<AuthService>().user.value;
    review.value.eService = booking.value.eService;
    super.onInit();
  }

  Future addReview() async {

    try {
      if (review.value.rate! < 1) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please rate this service by clicking on the stars".tr));
        return;
      }
      if (review.value.review == null || review.value.review!.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Tell us somethings about this service".tr));
        return;
      }

      // await _bookingRepository.addReview(review.value);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Thank you! your review has been added".tr));
      print('review.value');
      // print(review.value.rate);
      Timer(Duration(seconds: 2), () {
        Get.find<RootController>().changePage(0);
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future addReview2(double rate, String review , String user_id, String service_id) async {

    try {
      if (rate < 1) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please rate this service by clicking on the stars".tr));
        return;
      }
      if (review == null || review.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Tell us somethings about this service".tr));
        return;
      }

      await _bookingRepository.addReviewwithoutbooking( rate, review,user_id,service_id);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Thank you! your review has been added".tr));
      // print('review.value');
      // print(rate);
      Timer(Duration(seconds: 2), () {
        Get.find<RootController>().changePage(0);
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future addReviewEProvider(double rate, String review , String apiToken, String providerId) async {
    try {
      print('rate ${rate}');
      Get.log('review ${review}');
      print('apiToken ${apiToken}');
      print('service_id ${providerId}');
      loading.value = true ;
      update();
      if (rate < 1) {
        loading.value = false ;
        update();
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please rate this service by clicking on the stars".tr));
        return;
      }
      if (textReview.isEmpty) {
        loading.value = false ;
        update();
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Tell us somethings about this service".tr));
        return;
      }
      await _bookingRepository.addReviewProviderwithoutbooking(rate, review,apiToken,providerId).then((value){
        if(value == true) {
          loading.value = false;
          update();
          Get.back();
          Get.showSnackbar(Ui.SuccessSnackBar(message: "Thank you! your review has been added".tr));
        }
      }).catchError((error){
        loading.value =false ;
        update();
        Get.showSnackbar(Ui.ErrorSnackBar(message: error.toString()));
      });

    } catch (e) {
      loading.value = false ;
      update();
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  onChangeTextFilde(String value){
    textReview = value ;
    update();
  }
}
