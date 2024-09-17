import 'package:get/get.dart';
import 'package:emarates_bd/app/models/city_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/user_model.dart';
import '../providers/firebase_provider.dart';
import '../providers/laravel_provider.dart';
import '../services/auth_service.dart';

class UserRepository {
  late LaravelApiClient _laravelApiClient;
  late FirebaseProvider _firebaseProvider;
  UserRepository() {}
  Future<User> login(User user) {
    // print('hi');
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.login(user);
  }

  Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithApple();
  }

  Future<User> get(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUser(user);
  }

  Future<User> update(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.updateUser(user);
  }

  Future<User> delete(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.deleteUser(user);
  }

  Future<bool> sendResetLinkEmail(String email) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.sendResetLinkEmail(email);
  }

  Future<User> getCurrentUser() {
    return this.get(Get.find<AuthService>().user.value);
  }

  Future<User> register(User user, String userType) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.register(user, userType);
  }

  Future<void> verifyPhoneApi(String phoneNumber) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.verifyPhone(phoneNumber);
  }

  Future<User?> quickListing(User user, List cat, City cit) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.regQucikListing(user, cat, cit);
  }

  Future<String> checkUserExist(User user, String userType) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.checkUserExist(user, userType);
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithEmailAndPassword(email, password);
  }

  Future<bool> signInWithGoogle(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithGoogle(email, password);
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signUpWithEmailAndPassword(email, password);
  }

  Future<bool> signUpWithGoogle(User user, {int? userType}) async {
    LaravelApiClient _laravelApiClient2 = new LaravelApiClient();
    if (_laravelApiClient2.registerGoogle(user, userType: userType) == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUpWithApple(User user) async {
    LaravelApiClient _laravelApiClient2 = new LaravelApiClient();
    if (_laravelApiClient2.registerApple(user) == true) {
      // this.login(user);
      return true;
    } else {
      // this.login(user);
      return false;
    }
  }

  Future<bool> signUpWithYandex(User user) async {
    LaravelApiClient _laravelApiClient2 = new LaravelApiClient();
    if (_laravelApiClient2.yandexLogin(user) == true) {
      // this.login(user);
      return true;
    } else {
      // this.login(user);
      return false;
    }
  }

  Future<void> verifyPhone(String smsCode) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.verifyPhone(smsCode);
  }

  Future<void> sendCodeToPhone() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.sendCodeToPhone();
  }

  Future signOut() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return await _firebaseProvider.signOut();
  }
}
