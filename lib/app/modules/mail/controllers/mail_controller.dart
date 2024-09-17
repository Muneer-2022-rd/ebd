import 'dart:async';
import 'package:get/get.dart';
import 'package:emarates_bd/app/providers/laravel_provider.dart';
import '../../../../common/ui.dart';
import '../../../models/media_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';

class MailController extends GetxController {
  var user = new User().obs;
  var avatar = new Media().obs;
  final hidePassword = true.obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  final loading = false.obs;
  // GlobalKey<FormState> profileForm;
  late UserRepository _userRepository;
  final authService = Get.find<AuthService>();

  LaravelApiClient _laravelApiClient = new LaravelApiClient();

  MailController() {
    _userRepository = new UserRepository();
  }

  @override
  void onInit() {
    // user.value = Get.find<AuthService>().user.value;
    // avatar.value = new Media(thumb: user.value.avatar.thumb);
    super.onInit();
  }

  //
  Future refreshProfile({bool? showMessage}) async {
    await getUser();
    if (showMessage == true) {
      // Get.showSnackbar(Ui.SuccessSnackBar(message: "List of faqs refreshed successfully".tr));
    }
  }

  void sendMail(String email, String providerId, String senderMessage) async {
    loading.value = true;
    update();
    _laravelApiClient
        .send_mail(email, providerId, senderMessage)
        .then((value) async {
      loading.value = false;
      update();
      Get.back();
      await Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Sent Email Successfully".tr));
    }).catchError((error) {
      loading.value = false;
      update();
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Sent Email Failure".tr));
    });
  }

  // void resetProfileForm() {
  //   avatar.value = new Media(thumb: user.value.avatar.thumb);
  //   profileForm.currentState.reset();
  // }

  Future getUser() async {
    try {
      user.value = await _userRepository.getCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
