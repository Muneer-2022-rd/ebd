import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/common/ui.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityCheckerService extends GetxService {
  late bool isConnected;
  late SnackbarController snackBarController;

  Future<ConnectivityCheckerService> init() async {
    bool internetStateSnackBar = false;
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isConnected = (await InternetConnectionChecker().hasConnection) &&
          (result != ConnectivityResult.none);
      if (isConnected) {
        if (internetStateSnackBar == true) {
          Get.closeCurrentSnackbar().then((value) {
            Get.showSnackbar(Ui.SuccessInternetBar());
          });
          internetStateSnackBar = false;
          Get.log("InternetState  : ${internetStateSnackBar}");
        }
      } else {
        internetStateSnackBar = true;
        Get.log("InternetState  : ${internetStateSnackBar}");
        Get.showSnackbar(Ui.NoInternetBar());
      }
    });
    return this;
  }
}
