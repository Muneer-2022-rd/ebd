import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/root/controllers/root_controller.dart';
import 'package:emarates_bd/app/services/connectivity_checker_service.dart';
import '../../../../common/ui.dart';
import '../../../models/media_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';

class ProfileController extends GetxController {
  var user = new User().obs;
  var avatar = new Media().obs;
  final loading = false.obs;

  final hidePassword = true.obs;
  final oldPassword = "".obs;
  final name = "".obs;
  final image = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController Controller = TextEditingController();
  GlobalKey<FormState> profileForm = GlobalKey<FormState>();
  late UserRepository _userRepository;

  ConnectivityCheckerService connectivityCheckerService = Get.find();

  ProfileController() {
    _userRepository = new UserRepository();
  }

  @override
  void onInit() {
    user.value = Get.find<AuthService>().user.value;
    avatar.value = new Media(thumb: "" /*user.value.avatar!.thumb*/);
    super.onInit();
  }

  Future refreshProfile({bool? showMessage}) async {
//    await getUser();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of faqs refreshed successfully".tr));
    }
  }

  void saveProfileForm() async {
    Get.focusScope!.unfocus();
    if (connectivityCheckerService.isConnected) {
      try {
        if (profileForm.currentState!.validate()) {
          profileForm.currentState!.save();
          loading.value = true;
          update();
          print('name');
          print(user.value.name);
          profileForm.currentState!.save();
          user.value.password = newPassword.value == confirmPassword.value
              ? newPassword.value
              : null;
          await _userRepository.update(user.value).then((userAfterUpdate) {
            user.value = userAfterUpdate;
            Get.find<AuthService>().removeCurrentUser().then((value) {
              Get.find<AuthService>().user.value = userAfterUpdate;
            });
            loading.value = false;
            update();
            Get.showSnackbar(
                Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
          });
        }
      } catch (e) {
        loading.value = false;
        update();
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString().substring(11)));
      }
    } else if (!Get.isSnackbarOpen &&
        connectivityCheckerService.isConnected == false) {
      Get.showSnackbar(Ui.NoInternetBar());
    }
    // } else {
    //   Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    // }
  }

  Future<void> verifyPhone() async {
    try {
      await _userRepository.verifyPhone(smsSent.value);
      user.value = await _userRepository.update(user.value);
      Get.find<AuthService>().user.value = user.value;
      Get.back();
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

//  Future<void> deleteProfile() async {
//    try {
//      await _userRepository.delete(user.value);
//      Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile Deleted successfully".tr));
//      await Get.find<AuthService>().removeCurrentUser();
//      Get.find<RootController>().changePage(0);
//    } catch (e) {
//      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//    }
//  }

  void resetProfileForm() {
    avatar.value = new Media(thumb: user.value.avatar!.thumb);
    profileForm.currentState!.reset();
  }

  Future getUser() async {
    try {
      user.value = await _userRepository.getCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
