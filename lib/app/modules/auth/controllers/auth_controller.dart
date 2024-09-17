import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:emarates_bd/app/data/remote/auth/login_data.dart';
import 'package:emarates_bd/app/data/remote/auth/quick_listing_data.dart';
import 'package:emarates_bd/app/data/remote/auth/register_data.dart';
import 'package:emarates_bd/app/models/category_model.dart';
import 'package:emarates_bd/app/models/city_model.dart';
import 'package:emarates_bd/app/modules/auth/views/business_information_page2.dart';
import 'package:emarates_bd/app/modules/auth/views/busness_information_page3.dart';
import 'package:emarates_bd/app/modules/auth/views/bussiness_information_page1.dart';
import 'package:emarates_bd/app/modules/global_widgets/show_tost.dart';
import 'package:emarates_bd/app/providers/firebase_provider.dart';
import 'package:emarates_bd/app/repositories/category_repository.dart';
import 'package:emarates_bd/app/repositories/city_repository.dart';
import 'package:emarates_bd/app/services/connectivity_checker_service.dart';
import 'package:emarates_bd/app/services/sheardPrefServices.dart';
import 'package:emarates_bd/common/Functions/handeldata.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rive/rive.dart';

import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../global_widgets/text_field_widget.dart';

class AuthController extends GetxController {
  StatusRequest statusRequestNormalRegister = StatusRequest.non;
  StatusRequest statusRequestQuickListing = StatusRequest.non;
  StatusRequest statusRequestQuickListingStep2 = StatusRequest.non;
  StatusRequest statusRequestLogin = StatusRequest.non;
  QuickListingData quickListingData = QuickListingData(Get.find());
  RegisterData registerData = RegisterData(Get.find());
  LoginData loginData = LoginData(Get.find());
  SharedPrefServices sharedPrefServices = Get.find();
  ConnectivityCheckerService connectivityCheckerService = Get.find();

  File? logoCompany;
  File? coverCompany;
  User user = new User();
  var userType = 1;
  File? file;
  GoogleMapController? gmc;
  LatLng latLng = LatLng(0, 0);
  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(25.276987, 55.296249),
    zoom: 5.4746,
  );

  int currentIndex = 0;

  PageController pageController = PageController();

  List<String> titleQuickListing = [
    "Basic Information",
    "Contact Info and Social Media",
    "Location Business"
  ];

  List<Widget> pages = [
    BusinessInformationPage1(),
    BusinessInformationPage2(),
    BusinessInformationPage3()
  ];

  //Nodes
  FocusNode passwordNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode mobileNode = FocusNode();

  //TextEditing Controllers for QuickListing
  //step1
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController coName = TextEditingController();
  TextEditingController coEmail = TextEditingController();
  TextEditingController coAddress = TextEditingController();
  TextEditingController otpPhone = TextEditingController();

  //step2
  TextEditingController facebook = TextEditingController();
  TextEditingController twitter = TextEditingController();
  TextEditingController instagram = TextEditingController();
  TextEditingController linkedin = TextEditingController();
  TextEditingController whatsapp = TextEditingController();
  TextEditingController snapchat = TextEditingController();
  TextEditingController pinterest = TextEditingController();
  TextEditingController email1 = TextEditingController();
  TextEditingController website = TextEditingController();
  TextEditingController email2 = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController fax = TextEditingController();
  TextEditingController tollFreePhone = TextEditingController();
  TextEditingController employeesNumber = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController managerName = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController latLangGoogleMap = TextEditingController();
  TextEditingController busnessName = TextEditingController();
  DateTime? dateCompany;

  //regester
  TextEditingController jobTitle = TextEditingController();
  TextEditingController fileCv = TextEditingController();
  late GlobalKey<FormState> quickListingKey1;

  late GlobalKey<FormState> quickListingKey2;

  late GlobalKey<FormState> quickListingKey3;

  late GlobalKey<FormState> loginFormKey;

  late GlobalKey<FormState> registerKey;

  GlobalKey<FormState> keyFormBottomSheet = GlobalKey<FormState>();

  GoogleSignIn _googleSignIn = GoogleSignIn();

  List categories = <Category>[].obs;
  final cities = <City>[].obs;

//  final googleAccount = Rx<GoogleSignInAccount>();
  final Rx<User> currentUser = Get.find<AuthService>().user;
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final hidePassword = true.obs;
  final loading = false.obs;
  final smsSent = ''.obs;
  late UserRepository _userRepository;
  late CategoryRepository _categoryrRepository;
  late CityRepository _cityRepository;
  List listCatIdSelected = [];
  final cat_selected = Category().obs;
  final city_selected = City().obs;

  //Rive Animation Variable And Functions

  bool isShowConfetti = false;
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;

  late SMITrigger confetti;

  void onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  AuthController() {
    _userRepository = UserRepository();
    _categoryrRepository = CategoryRepository();
    _cityRepository = CityRepository();
  }

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void dispose() {
    //step1
    email.dispose();
    password.dispose();
    fName.dispose();
    lName.dispose();
    coEmail.dispose();
    coAddress.dispose();
    coName.dispose();

    //step2
    facebook.dispose();
    twitter.dispose();
    instagram.dispose();
    linkedin.dispose();
    whatsapp.dispose();
    email1.dispose();
    email2.dispose();
    snapchat.dispose();
    pinterest.dispose();
    website.dispose();
    phone.dispose();
    fax.dispose();
    mobile.dispose();
    tollFreePhone.dispose();
    employeesNumber.dispose();
    managerName.dispose();
    date.dispose();
    desc.dispose();
    fileCv.dispose();
    latLangGoogleMap.dispose();
    busnessName.dispose();
    super.dispose();
  }

  void get_categories() async {
    categories.assignAll(await _categoryrRepository.getAllWithSubCategories());
    cat_selected.value = categories[0];
  }

  Future getCities() async {
    try {
      cities.assignAll(await _cityRepository.getAll());
      city_selected.value = cities[0];
      // print(cities);
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  changeIndexPage(int index) {
    currentIndex = index;
    update();
  }

  changeUserType(int value) {
    userType = value;
    Get.log("User Type Select : ${userType}");
    update();
    SystemSound.play(SystemSoundType.click);
  }

  sendDataBasicInformation() async {
    if (connectivityCheckerService.isConnected) {
      if (Get.find<AuthService>().isAuth) {
        await registerCompany();
      } else {
        await registerQuickListing();
      }
    } else if (!Get.isSnackbarOpen &&
        connectivityCheckerService.isConnected == false) {
      Get.showSnackbar(Ui.NoInternetBar());
    }
  }

  sendContentInformation() {
    quickListingKey2.currentState!.save();
    loading.value = true;
    update();
    Future.delayed(Duration(seconds: 1), () {
      loading.value = false;
      update();
      pageController.nextPage(
          duration: Duration(seconds: 1), curve: Curves.easeInOut);
    });
  }

  skipContentInformation() async {
    if (!Get.find<AuthService>().isAuth ||
        Get.find<AuthService>().user.value.email == '') {
      Get.find<AuthService>().removeCurrentUser();
      Get.back();
    } else {
      Get.back();
    }
  }

  // to split user name to first_name and last_name for google Register
  static Map<String, dynamic>? parseJwt(String token) {
    // validate token
    if (token == null) return null;
    final List<String> parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    // retrieve token payload
    final String payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));
    // convert to Map
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }

  Future<void> googleRegisterFullOperation() async {
    User user = new User();
    update();
    await _googleSignIn.signIn().then((valueGoogleAccount) async {
      loading.value = true;
      update();
      if (await _googleSignIn.isSignedIn()) {
        statusRequestLogin = StatusRequest.loading;
        isShowConfetti = true;
        currentUser.value.name = valueGoogleAccount!.displayName;
        print("Full display name : ${valueGoogleAccount.displayName}");
        print("email : ${valueGoogleAccount.email}");
        // currentUser.value.avatar.url=googleAccount.value.photoUrl;
        update();
        final GoogleSignInAuthentication googleSignInAuthentication =
            await valueGoogleAccount.authentication;
        final idToken = googleSignInAuthentication.idToken;
        Map<String, dynamic> idMap = parseJwt(idToken!)!;
        final String firstName = idMap["given_name"];
        final String lastName = idMap["family_name"];
        Get.log("first name : ${firstName}");
        Get.log("last name : ${lastName}");
        user.name = firstName;
        user.lname = lastName;
        user.password = valueGoogleAccount.id;
        user.email = valueGoogleAccount.email;
        checkUserExistToSelectTypeUser(user);
      }
    }).catchError((error) {
      loading.value = false;
      statusRequestLogin = StatusRequest.failure;
      update();
      print(error.toString());
    });
    // if (connectivityCheckerService.isConnected) {
    //
    // } else if (!Get.isSnackbarOpen &&
    //     connectivityCheckerService.isConnected == false) {
    //   Get.showSnackbar(Ui.NoInternetBar());
    // }
  }

  void appleRegister() async {
    try {
      final firebaseProvider = Get.find<FirebaseProvider>();

      loading.value = true;
      update();
      final result = await firebaseProvider.signInWithApple();
      if (result != null) {
        loading.value = true;
        update();
        currentUser.value.name = result.givenName;
        user.name = result.givenName;
        user.password = result.userIdentifier;
        user.email = result.email;
        update();
        _userRepository.signUpWithApple(user).then((value) {
          Get.find<FireBaseMessagingService>()
              .setDeviceToken()
              .then((value) async {
            Timer(Duration(seconds: 3), () async {
              await _userRepository.signInWithApple().then((value) async {
                await _userRepository.login(user).then((value) {
                  currentUser.value = value;
                  Get.log("user ${value.toString()}");
                  loading.value = false;
                  update();
                  Get.offAllNamed(Routes.ROOT);
                  Get.showSnackbar(Ui.SuccessSnackBar(
                      message: "Logged in as ".tr + "${value.name}"));
                }).catchError((error) {
                  Get.showSnackbar(
                      Ui.ErrorSnackBar(message: error.toString().tr));
                  loading.value = false;
                  update();
                });
              });
            });
          }).catchError((error) {
            loading.value = false;
            update();
          });
        }).catchError((error) {});
      }
    } catch (e) {
      loading.value = false;
      update();
    }
  }

  Future<void> facebookLoginFullOperation() async {
    if (connectivityCheckerService.isConnected) {
      await FacebookAuth.instance.login(
        permissions: [
          'email',
          'public_profile',
          'user_birthday',
          'user_friends',
          'user_gender',
          'user_link'
        ],
      ).then((valueFaceBookAccount) async {
        if (valueFaceBookAccount.status == LoginStatus.success) {
          statusRequestLogin = StatusRequest.loading;
          isShowConfetti = true;
          update();
          await FacebookAuth.i
              .getUserData(
                  fields:
                      "id,name,email,picture.width(200),birthday,friends,gender,link")
              .then((value) async {
            if (valueFaceBookAccount.status == LoginStatus.success) {
              Get.log(
                  "response FaceBook Api : ${valueFaceBookAccount.toString()}");
              final AccessToken? accessToken =
                  valueFaceBookAccount.accessToken!;
              if (accessToken != null) {
                FacebookAuth.instance
                    .getUserData()
                    .then((userInformation) async {
                  var graphResponse = await http.get(Uri.parse(
                      'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}'));
                  var profile = jsonDecode(graphResponse.body);
                  Get.log("Profile FaceBook : ${profile.toString()}");
                  final userData = userInformation;
                  User user = new User();
                  user.name = profile['first_name'];
                  user.lname = profile['last_name'];
                  user.email = userData['email'];
                  user.password = userData['id'];
                  if (user.email == null) {
                    bottomSheetCompleteInformation(user,
                        onPressButton: () async {
                      if (keyFormBottomSheet.currentState!.validate()) {
                        Get.back();
                        user.email = email.text;
                        checkUserExistToSelectTypeUser(user);
                      }
                    }, typeUserSelection: false);
                  } else {
                    checkUserExistToSelectTypeUser(user);
                  }
                }).catchError((error) {
                  loading.value = false;
                  update();
                });
              } else {
                Get.log("Not Access Token");
              }
            }
          }).catchError((error) {
            print(error.toString());
            loading.value = false;
            update();
          });
        }
      }).catchError((error) {
        loading.value = false;
        update();
        print(error.toString());
      });
    } else if (!Get.isSnackbarOpen &&
        connectivityCheckerService.isConnected == false) {
      Get.showSnackbar(Ui.NoInternetBar());
    }
  }

  void checkUserExistToSelectTypeUser(User user) async {
    String res = await _userRepository.checkUserExist(user, "");
    //user register
    if (res != 'User not registered') {
      socialMediaAuthApi(user);
    } else {
      bottomSheetCompleteInformation(user, onPressButton: () async {
        Get.back();
        socialMediaAuthApi(user);
      }, typeUserSelection: true);
    }
  }

  void socialMediaAuthApi(User user) {
    _userRepository
        .signUpWithGoogle(user, userType: userType)
        .then((doRegister) async {
      Timer(const Duration(seconds: 4), () async {
        await Get.find<FireBaseMessagingService>()
            .setDeviceToken()
            .then((value) async {
          await _userRepository.login(user).then((value) {
            success.fire();
            Future.delayed(
              const Duration(seconds: 2),
              () {
                confetti.fire();
                Future.delayed(const Duration(seconds: 1), () {
                  currentUser.value = value;
                  statusRequestLogin = StatusRequest.success;
                  Get.find<AuthService>().setUserData(auth: true, userType: 1);
                  Get.offAllNamed(Routes.ROOT)!.then((value) {
                    loading.value = false;
                    update();
                  });
                  Get.showSnackbar(Ui.SuccessSnackBar(
                      message: "Login Successfully , Welcome".tr +
                          " ${currentUser.value.name} ${currentUser.value.lname}"));
                  // Navigator.pop(context);
                });
              },
            );
          }).catchError((errorStr) {
            error.fire();
            Future.delayed(
              const Duration(seconds: 2),
              () {
                Get.showSnackbar(Ui.ErrorSnackBar(
                    message: '${errorStr.toString().substring(11)}'.tr));
                statusRequestLogin = StatusRequest.failure;
                loading.value = false;
                reset.fire();
                update();
              },
            );
          });
        }).catchError((error) {
          loading.value = false;
          update();
        });
      });
    }).catchError((error) {
      loading.value = false;
      update();
    });
  }

  //
  Future<void> checkAccount() async {
    if (registerKey.currentState!.validate()) {
      registerKey.currentState!.save();
      if (connectivityCheckerService.isConnected) {
        loading.value = true;
        try {
          print('${currentUser.value.email}');
          // _user_exist= await _userRepository.checkUserExist(currentUser.value);
          String res = await _userRepository.checkUserExist(
              currentUser.value, userType.toString());
          //user register
          if (res != 'User not registered')
            Get.showSnackbar(Ui.ErrorSnackBar(message: res.tr));
          //user not register
          else
            sendCodeToPhone();
        } catch (e) {
          Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
          loading.value = false;
        } finally {
          loading.value = false;
        }
      } else if (!Get.isSnackbarOpen &&
          connectivityCheckerService.isConnected == false) {
        Get.showSnackbar(Ui.NoInternetBar());
      }
    }
  }

  void sendCodeToPhone() async {
    loading.value = true;
    update();
    try {
      await _userRepository.sendCodeToPhone().then((value) {
        loading.value = false;
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString().substring(11)));
    }
  }

  //create user and company
  registerQuickListing() async {
    print("run");
    if (quickListingKey1.currentState!.validate()) {
      if (logoCompany != null && coverCompany != null) {
        print("validate true");
        statusRequestQuickListing = StatusRequest.loading;
        loading.value = true;
        update();
        var response = await quickListingData.registerNewQuickListing(
            fName.text,
            lName.text,
            email.text,
            password.text,
            coName.text,
            coAddress.text,
            coAddress.text,
            (listCatIdSelected.map((e) => e.id)).join(","),
            mobile.text,
            city_selected.value.id!,
            logoCompany!,
            coverCompany!);
        Get.log(response["data"].toString());
        statusRequestQuickListing = handlingData(response);
        print("$statusRequestQuickListing =====================");
        update();
        if (StatusRequest.success == statusRequestQuickListing) {
          if (response["success"] == true) {
            Get.find<AuthService>().user.value =
                User.fromJson(response["data"]);
            Get.log(Get.find<AuthService>().user.value.toString());
            Get.find<AuthService>().user.value =
                Get.find<AuthService>().setUserData(auth: false, email: '');
            Get.log("------------------------------------------------------");
            Get.log(Get.find<AuthService>().user.value.toString());
            pageController.nextPage(
                duration: Duration(seconds: 1), curve: Curves.easeInOut);
            loading.value = false;
            print(response["message"]);
          } else {
            statusRequestQuickListing = StatusRequest.failure;
            loading.value = false;
            ShowToast.showToast(ToastType.ERROR, "${response["message"]}");
          }
        }
      } else {
        logoCompany == null && coverCompany != null
            ? ShowToast.showToast(
                ToastType.ERROR, "Please enter Logo of company".tr)
            : null;
        coverCompany == null && logoCompany != null
            ? ShowToast.showToast(
                ToastType.ERROR, "please enter Cover of company".tr)
            : null;
        coverCompany == null && logoCompany == null
            ? ShowToast.showToast(
                ToastType.ERROR, "Please enter cover and company logo".tr)
            : null;
      }
    }
    update();
  }

  //create company after register
  registerCompany() async {
    print("run");
    if (quickListingKey1.currentState!.validate()) {
      if (logoCompany != null && coverCompany != null) {
        print("validate true");
        statusRequestQuickListing = StatusRequest.loading;
        loading.value = true;
        update();
        var response = await quickListingData.registerCompany(
            coName.text,
            coAddress.text,
            coAddress.text,
            (listCatIdSelected.map((e) => e.id)).join(","),
            city_selected.value.id!,
            Get.find<AuthService>().user.value.apiToken!,
            logoCompany!,
            coverCompany!);
        Get.log(
            "Response Register Basic Information Company : ${response['data']}");
        statusRequestQuickListing = handlingData(response);
        print("$statusRequestQuickListing =====================");
        update();
        if (StatusRequest.success == statusRequestQuickListing) {
          if (response["success"] == true) {
//          sharedPrefServices.sharedPreferences!
//              .setInt("place_id", response["data"]["place_id"]);
            Get.find<AuthService>().user.value = Get.find<AuthService>()
                .setUserData(
                    placeId:
                        int.parse(response['data']['place_id'].toString()));
            loading.value = false;
            Get.log(
                "user after register company : ${currentUser.value.toString()}");
            pageController.nextPage(
                duration: Duration(seconds: 1), curve: Curves.easeInOut);
            print(response["message"]);
          } else {
            statusRequestQuickListing = StatusRequest.failure;
            ShowToast.showToast(ToastType.ERROR, "${response["message"]}");
          }
        } else {
          logoCompany == null && coverCompany != null
              ? ShowToast.showToast(
                  ToastType.ERROR, "Please enter Logo of company".tr)
              : null;
          coverCompany == null && logoCompany != null
              ? ShowToast.showToast(
                  ToastType.ERROR, "please enter Cover of company".tr)
              : null;
          coverCompany == null && logoCompany == null
              ? ShowToast.showToast(
                  ToastType.ERROR, "Please enter cover and company logo".tr)
              : null;
        }
      }
    }
    update();
  }

  // Add information to Company
  editQuickListing() async {
    statusRequestQuickListingStep2 = StatusRequest.loading;
    loading.value = true;
    update();
    var response = await quickListingData.editQuickListing(
        Get.find<AuthService>().user.value.apiToken!,
        Get.find<AuthService>().user.value.placeId!,
        email2.text,
        twitter.text,
        postalCode.text,
        facebook.text,
        instagram.text,
        whatsapp.text,
        linkedin.text,
        snapchat.text,
        pinterest.text,
        website.text,
        tollFreePhone.text,
        desc.text,
        phone.text,
        mobile.text,
        fax.text,
        employeesNumber.text,
        managerName.text,
        busnessName.text,
        date.text,
        latLng.latitude.toString(),
        latLng.longitude.toString());
    statusRequestQuickListingStep2 = handlingData(response);
    print("$statusRequestQuickListingStep2 =====================");
    update();
    if (StatusRequest.success == statusRequestQuickListingStep2) {
      if (response["success"] == true) {
        if (Get.find<AuthService>().isAuth &&
            Get.find<AuthService>().user.value.email!.isEmpty) {
          Get.find<AuthService>().removeCurrentUser();
        }
        update();
        Future.delayed(Duration(seconds: 1), () {
          Get.offAllNamed(Routes.ROOT);
          loading.value = false;
          Get.showSnackbar(
              Ui.SuccessSnackBar(message: "${response["message"]}"));
          print(response["message"]);
        });
      } else {
        statusRequestQuickListingStep2 = StatusRequest.failure;
        loading.value = false;
        update();
        ShowToast.showToast(ToastType.ERROR, "${response["message"]}");
      }
    }
    update();
  }

  registerNormal() async {
    if (registerKey.currentState!.validate()) {
      if (connectivityCheckerService.isConnected) {
        statusRequestNormalRegister = StatusRequest.loading;
        isShowConfetti = true;
        update();
        var response = await registerData.registerNormal(
            fName.text,
            lName.text,
            email.text,
            password.text,
            userType,
            jobTitle.text,
            mobile.text,
            file ?? null);
        update();
        if (response["success"] == true) {
          success.fire();
          await Future.delayed(
            const Duration(seconds: 2),
            () async {
              confetti.fire();
              await Future.delayed(const Duration(seconds: 1), () {
                statusRequestLogin = StatusRequest.success;
                Get.back();
                Get.showSnackbar(Ui.SuccessSnackBar(
                    message:
                        "User created successfully, Check your email to confirm your registration"
                            .tr));
                print(response["message"]);
              });
            },
          );
        } else {
          error.fire();
          await Future.delayed(
            const Duration(seconds: 2),
            () {
              statusRequestLogin = StatusRequest.failure;
              ShowToast.showToast(ToastType.ERROR, "${response["message"]}");
              loading.value = false;
              reset.fire();
              update();
            },
          );
        }
      } else if (!Get.isSnackbarOpen &&
          connectivityCheckerService.isConnected == false) {
        Get.showSnackbar(Ui.NoInternetBar());
      }
    }
    update();
  }

  login() async {
    print("start login ");
    if (loginFormKey.currentState!.validate()) {
      if (connectivityCheckerService.isConnected) {
        statusRequestLogin = StatusRequest.loading;
        isShowConfetti = true;
        update();
        var response = await loginData.login(
          email.text,
          password.text,
        );
        Get.log(response['data'].toString());
        update();
        if (response["success"] == true) {
          currentUser.value = User.fromJson(response["data"]);
          success.fire();
          await Future.delayed(
            const Duration(seconds: 2),
            () async {
              confetti.fire();
              await Future.delayed(const Duration(seconds: 1), () {
                statusRequestLogin = StatusRequest.success;
                Get.log("User : ${currentUser.value.toString()}");
                Get.offNamedUntil(
                  Routes.ROOT,
                  (route) => false,
                );
                Get.showSnackbar(Ui.SuccessSnackBar(
                    message: "Login Successfully , Welcome".tr +
                        " ${currentUser.value.name} ${currentUser.value.lname}"));
              });
            },
          );
        } else {
          error.fire();
          await Future.delayed(
            const Duration(seconds: 2),
            () {
              statusRequestLogin = StatusRequest.failure;
              ShowToast.showToast(ToastType.ERROR, "${response["message"]}");
              loading.value = false;
              reset.fire();
              update();
            },
          );
        }
      } else if (!Get.isSnackbarOpen &&
          connectivityCheckerService.isConnected == false) {
        Get.showSnackbar(Ui.NoInternetBar());
      }
    }
    update();
  }

  Future<void> verifyPhone() async {
    if (connectivityCheckerService.isConnected) {
      try {
        loading.value = true;
        await _userRepository.verifyPhone(smsSent.value);
        await Get.find<FireBaseMessagingService>().setDeviceToken();
        await _userRepository
            .register(currentUser.value, userType.toString())
            .then((user) async {
          await _userRepository
              .verifyPhoneApi(currentUser.value.phoneNumber!)
              .then((value) {
            Get.offNamedUntil(Routes.ROOT, (route) => false);
            Get.showSnackbar(Ui.SuccessSnackBar(
                message: 'Check your email to confirm your registration'.tr));
            loading.value = false;
          }).catchError((error) {
            Get.log(error.toString());
          });
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString().substring(11)));
      } finally {
        loading.value = false;
      }
    }
  }

  Future<void> resendOTPCode() async {
    if (connectivityCheckerService.isConnected) {
      await _userRepository.sendCodeToPhone().then((value) {
        Get.showSnackbar(
            Ui.SuccessSnackBar(message: 'Resend OTP code successfully'.tr));
      }).catchError((error) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Resend OTP code Filed".tr));
      });
    }
  }

  void sendResetLink() async {
    Get.focusScope?.unfocus();
    if (forgotPasswordFormKey.currentState!.validate()) {
      forgotPasswordFormKey.currentState!.save();
      if (connectivityCheckerService.isConnected) {
        loading.value = true;
        update();
        try {
          await _userRepository
              .sendResetLinkEmail(email.text)
              .then((value) async {
            loading.value = false;
            update();
            Get.back();
            Get.showSnackbar(Ui.SuccessSnackBar(
                message:
                    "The Password reset link has been sent to your email: ".tr +
                        email.text));
          });
        } catch (e) {
          Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        } finally {
          loading.value = false;
          update();
        }
      }
    }
  }

  Future<void> selectDateCompany(BuildContext context) async {
    dateCompany = DateTime.now();
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Get.theme.colorScheme.secondary,
              ),
              primaryColor: Get.theme.colorScheme.secondary,
              textButtonTheme: TextButtonThemeData(),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: dateCompany!,
        confirmText: "ok",
        cancelText: "cancel",
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dateCompany) {
      dateCompany = picked;
      date.text = dateCompany.toString();
      update();
    }
  }

  onDragMarker(LatLng t) {
    latLng = t;
    latLangGoogleMap.text = "${t.latitude} , ${t.longitude}";
    update();
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

  setMarkerCustomImage(Marker newMarker, {LatLng? latLong}) async {
    if (latLong != null) {
      latLng = latLong;
      latLangGoogleMap.text = "${latLong.latitude} , ${latLong.longitude}";
    }
    myMarker = {};
    update();
    myMarker.add(newMarker);
    update();
    Get.log(latLng.toString());
  }

  void bottomSheetCompleteInformation(User user,
      {required void Function() onPressButton,
      required bool typeUserSelection}) {
    Get.bottomSheet(
      WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SafeArea(
          child: SizedBox(
            height: user.email == null ? Get.height / 2.1 : Get.height / 2.8,
            child: Form(
              key: keyFormBottomSheet,
              child: GetBuilder<AuthController>(
                builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Text(
                          "Complete registration  Information".tr,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Get.theme.colorScheme.secondary),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      if (typeUserSelection)
                        Column(
                          children: [
                            Text(
                              "I AM".tr,
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Get.theme.hintColor
                                      : Get.theme.colorScheme.secondary,
                                  fontSize: 15.0),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    changeUserType(1);
                                  },
                                  child: Container(
                                    width: 130.0,
                                    height: 45.0,
                                    decoration: BoxDecoration(
                                      color: userType == 1
                                          ? Get.theme.colorScheme.secondary
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Individual".tr,
                                        style: TextStyle(
                                            color: userType == 1
                                                ? Colors.white
                                                : Get.theme.colorScheme
                                                    .secondary),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    changeUserType(2);
                                  },
                                  child: Container(
                                    width: 130.0,
                                    height: 45.0,
                                    decoration: BoxDecoration(
                                      color: userType == 2
                                          ? Get.theme.colorScheme.secondary
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Business Owner".tr,
                                        style: TextStyle(
                                            color: userType == 2
                                                ? Colors.white
                                                : Get.theme.colorScheme
                                                    .secondary),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      if (user.email == null)
                        TextFieldWidget(
                          controller: email,
                          labelText: "Facebook Email".tr,
                          hintText: "Enter Facebook Email".tr,
                          iconData: FontAwesomeIcons.facebook,
                          isFirst: true,
                          isLast: false,
                          validator: (input) => !input!.contains('@')
                              ? "Should be a valid email".tr
                              : null,
                        ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: onPressButton,
                            child: Text('complete registration'.tr),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enableDrag: false,
      isDismissible: false,
    );
  }

  pickedPdfFile(BuildContext context) async {
    FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ["pdf"]).then((value) {
      if (value != null) {
        file = File(value.files.single.path!);
        fileCv.text = value.files.single.name;
        update();
      } else {
        print("error picked");
      }
    }).catchError((error) {});
  }

  // pickedPdfFile(BuildContext context) async {
  //   AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
  //   if (build.version.sdkInt! >= 30) {
  //     PermissionStatus status_30 =
  //         await Permission.manageExternalStorage.request();
  //     print('storgae status  $status_30');
  //     if (status_30.isGranted) {
  //       pick_cv_file();
  //     } else {
  //       notify(context);
  //     }
  //   } else if (build.version.sdkInt! < 30) {
  //     PermissionStatus status = await Permission.storage.request();
  //     print('storgae status  $status');
  //     if (status.isGranted) {
  //       pick_cv_file();
  //     } else {
  //       notify(context);
  //     }
  //   }
  // }

  // void pick_cv_file() {
  //   FilePicker.platform.pickFiles(
  //       type: FileType.any, allowedExtensions: ["pdf", "PDF"]).then((value) {
  //     if (value != null) {
  //       file = File(value.files.single.path!);
  //       fileCv.text = value.files.single.name;
  //       update();
  //     } else {
  //       print("error picked");
  //     }
  //   }).catchError((error) {});
  // }

  // Future<dynamic> notify(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: const Text('Permission Denied'),
  //       content: const Text(
  //           'You have denied the permission to access external storage.'),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('OK'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             await openAppSettings();
  //           },
  //           child: const Text('Open Settings'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<File?> pickImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source, imageQuality: 50);
    if (file != null) {
      int sizeInBytes = File(file.path).lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      print("Size in MB  : ${sizeInMb}");
      if (sizeInMb > 5) {
        ShowToast.showToast(
            ToastType.ERROR, "The image must be smaller than 5 MB");
        return null;
      } else {
        update();
        return File(file.path);
      }
    }
    update();
  }

//
// Future<Position> getLatAndLang() async {
//   currentLocation = await Geolocator.getCurrentPosition()
//       .then((value) {
//         lat = value.latitude ;
//         lang = value.longitude ;
//         update() ;
//        kGooglePlex = CameraPosition(
//           target: LatLng(lat, lang),
//           zoom: 14.4746,
//         );
//        update() ;
//   })
//       .catchError((error) {
//
//   });
// }
//AIzaSyCNiQYsSAw-c1iOaEt5zF8ym2X8xWWc0iI
}
