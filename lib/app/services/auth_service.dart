import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/media_model.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import 'settings_service.dart';

class AuthService extends GetxService {
  final user = User().obs;
  late GetStorage _box;
 late UserRepository _usersRepo;

  AuthService() {
    _usersRepo = new UserRepository();
    _box = new GetStorage();
  }


  User setUserData(
      {String? id,
        String? fName,
        String? lName,
        String? img,
        String? email,
        String? password,
        int? userType,
        Media? avatar,
        String? apiToken,
        String? deviceToken,
        String? phoneNumber,
        bool? verifiedPhone,
        String? verificationId,
        String? address,
        String? bio,
        bool? auth,
        int? placeId,
        bool? isSocial}) {
    return User(
        id: id ?? Get.find<AuthService>().user.value.id,
        name: fName ?? Get.find<AuthService>().user.value.name,
        lname: lName  ?? Get.find<AuthService>().user.value.lname,
        email: email ?? Get.find<AuthService>().user.value.email,
        verifiedPhone: verifiedPhone ?? Get.find<AuthService>().user.value.verifiedPhone,
        userType: userType ?? Get.find<AuthService>().user.value.userType,
        password: password ?? Get.find<AuthService>().user.value.password,
        address: address ?? Get.find<AuthService>().user.value.address,
        apiToken: apiToken ?? Get.find<AuthService>().user.value.apiToken,
        avatar: avatar ?? Get.find<AuthService>().user.value.avatar,
        bio: bio ?? Get.find<AuthService>().user.value.bio,
        deviceToken: deviceToken ?? Get.find<AuthService>().user.value.deviceToken,
        img: img ?? Get.find<AuthService>().user.value.img,
        phoneNumber: phoneNumber ?? Get.find<AuthService>().user.value.phoneNumber,
        isSocial: isSocial ?? Get.find<AuthService>().user.value.isSocial,
        verificationId: verificationId ?? Get.find<AuthService>().user.value.verificationId,
        placeId:  placeId ?? Get.find<AuthService>().user.value.placeId,
        auth: auth ?? Get.find<AuthService>().user.value.auth );
  }
  Future<AuthService> init() async {
    user.listen((User _user) {
      if (Get.isRegistered<SettingsService>()) {
        Get.find<SettingsService>().address.value.userId = _user.id;
      }
      _box.write('current_user', _user.toJson());
    });
    await getCurrentUser();
    return this;
  }


  Future getCurrentUser() async {
    if (user.value.auth == null && _box.hasData('current_user')) {
      user.value = User.fromJson(await _box.read('current_user'));
      user.value.auth = true;
    } else {
      user.value.auth = false;
    }
  }

  Future removeCurrentUser() async{
    user.value = new User();
    await _box.remove('current_user') ;
  }

  bool get isAuth => user.value.auth ?? false ;

  String? get apiToken => (user.value.auth ?? false) ? user.value.apiToken : '';
}
