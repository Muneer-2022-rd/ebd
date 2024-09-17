import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:emarates_bd/app/models/singleProviderModel.dart';
import 'package:http/http.dart' as http;

import '../models/address_model.dart';
import '../models/award_model.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../models/category_model.dart';
import '../models/city_model.dart';
import '../models/coupon_model.dart';
import '../models/custom_page_model.dart';
import '../models/e_provider_model.dart';
import '../models/e_service_model.dart';
import '../models/event_model.dart';
import '../models/experience_model.dart';
import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../models/favorite_model.dart';
import '../models/notification_model.dart';
import '../models/option_group_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/review_model.dart';
import '../models/setting_model.dart';
import '../models/slide_model.dart';
import '../models/tag_model.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../services/settings_service.dart';
import 'api_provider.dart';

class LaravelApiClient extends GetxService with ApiClient {
  late dio.Dio _httpClient;
  late dio.Options _optionsNetwork;
  late dio.Options _optionsCache;

  LaravelApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl;
    _httpClient = new dio.Dio();
  }

  Future<LaravelApiClient> init() async {
    if (foundation.kIsWeb || foundation.kDebugMode) {
      _optionsNetwork = dio.Options();
      _optionsCache = dio.Options();
    } else {
      _optionsNetwork =
          buildCacheOptions(Duration(days: 3), forceRefresh: true);
      _optionsCache =
          buildCacheOptions(Duration(minutes: 10), forceRefresh: false);
      _httpClient.interceptors.add(
          DioCacheManager(CacheConfig(baseUrl: getApiBaseUrl(""))).interceptor);
    }
    return this;
  }

  void forceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = dio.Options();
    }
  }

  void unForceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = buildCacheOptions(duration, forceRefresh: false);
    }
  }

  Future<List<Slide>> getHomeSlider() async {
    Uri _uri = getApiBaseUri("slider");
    Get.log(_uri.toString());
    var response = await _httpClient?.getUri(_uri, options: _optionsCache);
    if (response!.data['success'] == true) {
      return response.data['data']
          .map<Slide>((obj) => Slide.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> getHomeSlider2() async {
    Uri _uri = getApiBaseUri("slider");
    Get.log(_uri.toString());

    var response = await _httpClient?.getUri(_uri, options: _optionsCache);
    if (response?.data['success'] == true) {
      print("response.data['data']['media']['url']");
      print(response?.data['data']['media']['url']);
      return response?.data['data']['media']['url'];
    } else {
      throw new Exception(response?.data['message']);
    }
  }

  Future<List<Slide>> getHomeSliderFront() async {
    Uri _uri = getApiBaseUri("slider");
    Get.log(_uri.toString());
    var response = await _httpClient?.getUri(_uri, options: _optionsCache);
    if (response?.data['success'] == true) {
      return response?.data['data']
          .map<Slide>((obj) => Slide.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response?.data['message']);
    }
  }

  Future<User> getUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("user").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(
      _uri,
      options: _optionsNetwork,
    );
    Get.log("User :  ${response.data.toString()}");
    if (response.data['success'] == true) {
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> send_mail(
      String email, String providerId, String senderMessage) async {
    Uri _uri = Uri.parse("https://emiratesbd.ae/api/send_message");
    Get.log(_uri.toString());
    var _queryParameters = {
      'sender_email': email,
      'place_id': providerId,
      'sender_msg': senderMessage,
    };

    var response = await http.post(
      _uri,
      body: _queryParameters,
      // options: _optionsNetwork,
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['success'] == true) {
      return true;
    } else {
      throw new Exception(responseBody['message']);
    }
  }

  Future<User> login(User user) async {
    Uri _uri = getApiBaseUri("login");
    Get.log(_uri.toString());
    print("user email  :  ${user.email}");
    print("password : ${user.password}");
    var response = await http.post(
      _uri,
      body: {
        "email": user.email.toString(),
        'social_register': "1",
        "social_id": user.password.toString()
      },
      // data: _queryParameters,
    );

    var responseBody = jsonDecode(response.body);
    if (responseBody['success'] == true) {
      print('aut logn');
      responseBody['data']['auth'] = true;
      Map<String, dynamic> json = responseBody['data'];
      json.addAll({
        "isSocial": true,
      });
      return User.fromJson(responseBody['data']);
    } else {
      print('err logn');
      throw new Exception(responseBody['message']);
    }
  }

  Future<User> register(User user, String userType) async {
    print('resg');
    Uri _uri = getApiBaseUri("register");
    Get.log(_uri.toString());
    var response = await http.post(
      _uri,
      body: {
        'fname': user.name,
        'lname': user.lname,
        'email': user.email,
        'password': user.password,
        'user-type': userType,
        'phone': user.phoneNumber
      },
    );
    var responseBody = jsonDecode(response.body);
    Get.log("response Rigester Data : ${responseBody['message']}");
    if (responseBody['success'] == true) {
      print('reg succes');
      return User.fromJson(responseBody['data']);
    } else {
      throw new Exception(responseBody['message']);
    }
  }

  Future<void> verifyPhone(String phoneNumber) async {
    print('resg');
    print("Phone Number : ${phoneNumber}");
    Uri _uri = Uri.parse("https://emiratesbd.ae/api/phone_verify");
    Get.log(_uri.toString());
    var response = await http.post(
      _uri,
      body: {
        'phone': phoneNumber,
      },
    );
    var responseBody = jsonDecode(response.body);
    Get.log("response Verify Phone : ${responseBody['message']}");
    if (responseBody['success'] == true) {
      print('verify phone success');
    } else {
      throw new Exception(responseBody['message']);
    }
  }

  Future<User?> regQucikListing(User user, List cat, City cit) async {
    print('regQucikListing');
    print("${cat.join(",")}");
    print(user.email);
    print(user.name);
    var _queryParameters = {
      'fname': user.name,
      'lname': user.lname,
      'email': user.email,
      'coemail': user.coemail,
      "coaddress": user.coaddress,
      'coaddress': user.coaddress,
      'password': user.password,
      'categories': cat.join(","),
      'city_id': cit.id,
    };
    Uri _uri = getApiBaseUri("provider_request");
    Get.log(_uri.toString());
    var response = await _httpClient?.post(
      "https://emiratesbd.ae/api/provider_request",
      // data: json.encode(user.toJson()),
      data: _queryParameters,
      // options: _optionsNetwork,
    );
    if (response!.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      print("${response.data['message']}");
    }
  }

  Future<String> checkUserExist(User user, String userType) async {
    try {
      print('exist user');
      print("user email ${user.email}");
      var _queryParameters = {
        'email': user.email,
        'type': userType,
        'phone': user.phoneNumber ?? "",
      };
      String _uri = "https://emiratesbd.ae/api/check";
      Get.log(_uri.toString());
      var response = await http.post(
        Uri.parse(_uri),
        body: _queryParameters,
      );
      var responseBody = jsonDecode(response.body);
      Get.log("${responseBody['message']}");
      return responseBody['message'];
    } catch (error) {
      throw new Exception(error.toString());
    }
  }

  Future<bool> registerGoogle(User user, {int? userType}) async {
    print("user Email ${user.email}");
    print(user.password);
    print("user Type Register : ${userType}");
    Uri _uri = getApiBaseUri("register");
    Get.log(_uri.toString());
    var response = await http.post(
      Uri.parse("https://emiratesbd.ae/api/register"),
      body: {
        'fname': user.name.toString(),
        'lname': user.lname.toString(),
        'email': user.email.toString(),
        'user-type': userType.toString(),
        'social_register': "1",
        "social_id": user.password.toString()
      },
    );
    print("response : $response");
    var responseBody = jsonDecode(response.body);
    print('responseBody["data"] : ${responseBody["data"]}');
    if (responseBody['success'] == true) {
      print("success login with google");
      print(
          "Success Message From Sign in  with google Api : ${responseBody["message"]}");
      return true;
    } else {
      print(
          "Filed Message From Sign in  with google Api : ${responseBody["message"]}");
      return false;
      // throw new Exception(response.data['message']);
    }
  }

  Future<bool> registerApple(User user) async {
    Get.log("Email Register: ${user.email}");
    Get.log("password Register : ${user.password}");
    Get.log("Name Register : ${user.name}");
    Uri _uri = getApiBaseUri("register");
    Get.log(_uri.toString());
    var response = await http.post(
      Uri.parse("https://emiratesbd.ae/api/register"),
      body: {
        'fname': user.name.toString(),
        'lname': user.lname.toString(),
        'email': user.email.toString(),
        'social_register': user.id.toString(),
        "social_id": user.password.toString()
      },
    );
    print('res');
    var responseBody = jsonDecode(response.body);
    if (responseBody['success'] == true) {
      print('reg succes');
      // auth
      return true;
      // return User.fromJson(response.data['data']);
    } else {
      print("reg false");
      return false;

      // throw new Exception(response.data['message']);
    }
  }

  Future<bool> yandexLogin(User user) async {
    // print('resg');
    Uri _uri = getApiBaseUri("yandex-login");
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response!.data['success'] == true) {
      // print('reg succes');
      response.data['data']['auth'] = true;
      return true;
      // return User.fromJson(response.data['data']);
    } else {
      // throw new Exception(response.data['message']);
      return false;
    }
  }

  Future<bool> sendResetLinkEmail(String email) async {
    Uri _uri = Uri.parse("https://emiratesbd.ae/api/reset_password");
    Get.log(_uri.toString());
    Get.log("email reset password : ${email}");
    // to remove other attributes from the user object
    var response = await http.post(
      _uri,
      body: {'email': email},
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['success'] == true) {
      return true;
    } else {
      throw new Exception(responseBody['message']);
    }
  }

  Future<User> deleteUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr);
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'id': user.id,
    };
    Uri _uri = getApiBaseUri("profile-delete")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> updateUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateUser() ]");
    }
    Get.log("api token : ${user.apiToken}");
    Get.log("first name : ${user.name}");
    Get.log("last name : ${user.lname}");
    Get.log("email : ${user.email}");
    Get.log("phone : ${user.phoneNumber}");
    Get.log("image : ${user.img}");
    Get.log("password : ${user.password}");
    var _queryParameters = {
      'api_token': user.apiToken,
      'first_name': user.name,
      'last_name': user.lname,
      'password': user.password,
//      'email' : user.email,
      'phone': user.phoneNumber
    };
    Uri _uri = Uri.parse("https://emiratesbd.ae/api/update_profile");
    Get.log(_uri.toString());
    var response = await http.post(
      _uri,
      body: _queryParameters,
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['success'] == true) {
      return user;
    } else {
      throw new Exception(responseBody['message']);
    }
  }

  Future<List<Address>> getAddresses() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getAddresses() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'search': "user_id:${authService.user.value.id}",
      'searchFields': 'user_id:=',
      'orderBy': 'id',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response!.data['success'] == true) {
      return response.data['data']
          .map<Address>((obj) => Address.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getRecommendedEServices() async {
    // print('rerrererererererere');
    final _address = Get.find<SettingsService>().address.value;
    // TODO get Only Recommended
    var _queryParameters = {
      // 'only': 'id;name;price;discount_price;price_unit;has_media;media;total_reviews;rate',
      // 'only': 'id;name;price;discount_price;price_unit;picture;has_media;media;total_reviews;rate',
      'limit': '6',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient?.getUri(_uri, options: _optionsCache);
    if (response!.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getOfferWeekEServices() async {
    final _address = Get.find<SettingsService>().address.value;
    // print('oofer laravel conteroller');
    // TODO get Only Offer
    var _queryParameters = {
      // 'only': 'id;name;price;discount_price;price_unit;has_media;media;total_reviews;rate',
      'limit': '6',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("service/offer");
    Get.log(_uri.toString());
    // print('offffferssssss');
    // print(_uri.toString());
    var response = await _httpClient?.getUri(_uri, options: _optionsCache);
    if (response!.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getAllEServicesWithPaginationCities(
      String cityId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      // 'with': 'eProvider;eProvider.addresses;categories',
      // 'search': 'categories.id:$categoryId',
      //   'search': 'categories.id:16',
      'city_id': '$cityId',

      // 'searchFields': 'categories.id:=',
      //'categories[0]':'$categoryId',
      // 'searchFields': 'categories.id:=59',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("service/city")
        .replace(queryParameters: _queryParameters);
    //    Uri _uri = getApiBaseUri("e_services");
    Get.log(_uri.toString());
    var response = await _httpClient?.postUri(_uri);

    // var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response!.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  getAllEProviderWithPaginationCities(String cityId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      // 'with': 'eProvider;eProvider.addresses;categories',
      // 'search': 'categories.id:$categoryId',
      //   'search': 'categories.id:16',
      'city_id': '$cityId',

      // 'searchFields': 'categories.id:=',
      //'categories[0]':'$categoryId',
      // 'searchFields': 'categories.id:=59',
      // 'limit': '4',
      // 'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("providers/city")
        .replace(queryParameters: _queryParameters);
    //    Uri _uri = getApiBaseUri("e_services");
    Get.log(_uri.toString());
    var response = await _httpClient?.getUri(_uri);

    // var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response!.data['success'] == true) {
      // print('oiu');
      return response.data['data']
          .map<EProvider>((obj) => EProvider.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getAllEServicesWithPagination(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'category_id': '$categoryId',
      // 'with': 'eProvider;eProvider.addresses;categories',
      // 'search': 'categories.id:$categoryId',
      // 'search': 'categories.id:53',

      // 'searchFields': 'categories.id:=',
      // 'categories[0]':'$categoryId',
      // 'searchFields': 'categories.id:=53',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    // Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Uri _uri = getApiBaseUri("service/category")
        .replace(queryParameters: _queryParameters);
    // Uri _uri = getApiBaseUri("e_services");
    Get.log(_uri.toString());
    var response = await _httpClient?.getUri(_uri, options: _optionsNetwork);
    if (response!.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<ProviderModel>> getAllProvidersWithPagination(
      String categoryId, int page) async {
    // final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'category_id': '$categoryId',
      // 'with': 'eProvider;eProvider.addresses;categories',
      // 'search': 'categories.id:$categoryId',
      // 'search': 'categories.id:53',

      // 'searchFields': 'categories.id:=',
      // 'categories[0]':'$categoryId',
      // 'searchFields': 'categories.id:=53',
      // 'limit': '4',
      // 'offset': ((page - 1) * 4).toString()
    };
    // if (!_address.isUnknown()) {
    //   _queryParameters['myLat'] = _address.latitude.toString();
    //   _queryParameters['myLon'] = _address.longitude.toString();
    // }
    // Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Uri _uri = getApiBaseUri("provider/category")
        .replace(queryParameters: _queryParameters);
    // Uri _uri = getApiBaseUri("e_services");
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      print(response.data['data']);
      print(' cat prov of cat');
      return response.data['data']
          .map<EProvider>((obj) => EProvider.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

////// provider by city
  Future<List<EProvider>> searchEProvider(
      String keywords, List<String> cities, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO Pagination
    // print('cities...');
    // print('${cities.join(',')}');
    // print('${cities.first}');
    var city;
    if (cities.length > 1) {
      city = '';
    } else {
      city = cities.first;
    }
// print(city);
    var _queryParameters = {
      'query': '$keywords',
      'city_id': '${city}',

      // 'with': 'eProvider;eProvider.addresses;categories',
      // 'search': 'categories.id:${cities.join(',')};name:$keywords',
      // 'searchFields': 'categories.id:in;name:like',
      'searchJoin': 'and',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    // Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Uri _uri =
        getApiBaseUri("search").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      // print('search.............');
      // print(response.data['data']);

      return response.data['data']
          .map<EProvider>((obj) => EProvider.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

////// service bi city
  Future<List<EService>> searchEServices(
      String keywords, List<String> cities, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO Pagination
    // print('cities...');
    // print('${cities.join(',')}');
    // print('${cities.first}');
    var city;
    if (cities.length > 1) {
      city = '';
    } else {
      city = cities.first;
    }
// print(city);
    var _queryParameters = {
      'keyword': '$keywords',
      'city': '${city}',

      // 'with': 'eProvider;eProvider.addresses;categories',
      // 'search': 'categories.id:${cities.join(',')};name:$keywords',
      // 'searchFields': 'categories.id:in;name:like',
      'searchJoin': 'and',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    // Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Uri _uri = getApiBaseUri("service/search")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      // print('search.............');
      // print(response.data['data']);

      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

///////// search by category
  // Future<List<EService>> searchEServices(String keywords, List<String> categories, int page) async {
  //   final _address = Get.find<SettingsService>().address.value;
  //   // TODO Pagination
  //   var _queryParameters = {
  //     'keyword': '$keywords',
  //     'with': 'eProvider;eProvider.addresses;categories',
  //     'search': 'categories.id:${categories.join(',')};name:$keywords',
  //     'searchFields': 'categories.id:in;name:like',
  //     'searchJoin': 'and',
  //   };
  //   if (!_address.isUnknown()) {
  //     _queryParameters['myLat'] = _address.latitude.toString();
  //     _queryParameters['myLon'] = _address.longitude.toString();
  //   }
  //   // Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
  //   Uri _uri = getApiBaseUri("service/search").replace(queryParameters: _queryParameters);
  //   Get.log(_uri.toString());
  //   var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
  //   if (response.data['success'] == true) {
  //
  //     print('search.............');
  //     print(response.data['data']);
  //
  //
  //     return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
  //   } else {
  //     throw new Exception(response.data['message']);
  //   }
  // }

  Future<List<Favorite>> getFavoritesEServices() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getFavoritesEServices() ]");
    }
    var _queryParameters = {
      'with': 'eService;options;eService.eProvider',
      'search': 'user_id:${authService.user.value.id}',
      'searchFields': 'user_id:=',
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Favorite>((obj) => Favorite.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Favorite> addFavoriteEService(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You must have an account to be able to add services to favorite".tr +
              "[ addFavoriteEService() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("favorites").replace(queryParameters: _queryParameters);

    Get.log(_uri.toString());

    var response = await _httpClient!.postUri(
      _uri,
      data: json.encode(favorite.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      print('success add');
      return Favorite.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> removeFavoriteEService(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You must have an account to be able to add services to favorite".tr +
              "[ removeFavoriteEService() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("favorites/1").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.deleteUri(
      _uri,
      data: json.encode(favorite.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> getEService(String id) async {
    var _queryParameters = {
      'with': 'eProvider;categories;eProvider.taxes',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken!;
    }
    Uri _uri = getApiBaseUri("e_services/$id")
        .replace(queryParameters: _queryParameters);

    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> callEProvider(String id) async {
    var _queryParameters = {
      // 'with': 'eProvider;categories;eProvider.taxes',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("services/call/$id");

    Get.log(_uri.toString());
    var response = await _httpClient!.postUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<SingleProviderModel> getEProvider(int eProviderId) async {
    print("Single Provider Id : ${eProviderId}");
    var response = await Dio().postUri(
        Uri.parse("https://emiratesbd.ae/api/company"),
        data: {"place_id": eProviderId},
        options: _optionsNetwork);
    if (response.data['success'] == true) {
      print(response.data['data']["name"]);
      return SingleProviderModel.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EProvider> callJustProvider(String eProviderId) async {
    const _queryParameters = {
      // 'with': 'eProviderType;availabilityHours;users',
    };
    Uri _uri = getApiBaseUri("providers/call/$eProviderId");
    Get.log(_uri.toString());
    var response = await _httpClient!.postUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EProvider.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getEProviderReviews(String eProviderId) async {
    var _queryParameters = {
      'with': 'eProviderReviews;eProviderReviews.user',
      'only':
          'eProviderReviews.id;eProviderReviews.review;eProviderReviews.rate;eProviderReviews.user;'
    };
    Uri _uri = getApiBaseUri("e_providers/$eProviderId")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['e_provider_reviews']
          .map<Review>((obj) => Review.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  //
  Future<List<ProviderModel>> getAllProvider() async {
    print('laravel prrovider get providers');
    Uri _uri = getApiBaseUri("providers/");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(
        Uri.parse("https://emiratesbd.ae/api/latest_providers"),
        options: _optionsNetwork);
    if (response.data['success'] == true) {
      Get.log(response.data['data'].toString());
      return response.data['data']
          .map<ProviderModel>((obj) => ProviderModel.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<ProviderModel>> getFetauredProvider() async {
    print('laravel prrovider get featured provider');
    var _queryParameters = {};
    Uri _uri = getApiBaseUri("featured_providers/");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<ProviderModel>((obj) => ProviderModel.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Gallery>> getEProviderGalleries(String eProviderId) async {
    var _queryParameters = {
      'with': 'media',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("galleries").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Gallery>((obj) => Gallery.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Award>> getEProviderAwards(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("awards").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Award>((obj) => Award.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Experience>> getEProviderExperiences(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("experiences").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Experience>((obj) => Experience.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderFeaturedEServices(
      String eProviderId, int page) async {
    print('call privider services api');
    var _queryParameters = {
      'provider_id': '$eProviderId',
      // 'with': 'eProvider;eProvider.addresses;categories',
      // 'search': 'e_provider_id:$eProviderId;featured:1',
      // 'searchFields': 'e_provider_id:=;featured:=',
      // 'searchJoin': 'and',
      // 'limit': '5',
      // 'offset': ((page - 1) * 5).toString()
    };
    // Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Uri _uri = getApiBaseUri("service/provider")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderPopularEServices(
      String eProviderId, int page) async {
    // TODO popular eServices
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderAvailableEServices(
      String eProviderId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'available_e_provider': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderMostRatedEServices(
      String eProviderId, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient?.getUri(_uri, options: _optionsCache);
    if (response!.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getEProviderEmployees(String eProviderId) async {
    var _queryParameters = {
      'with': 'users',
      'only':
          'users;users.id;users.name;users.email;users.phone_number;users.device_token'
    };
    Uri _uri = getApiBaseUri("e_providers/$eProviderId")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['users']
          .map<User>((obj) => User.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderEServices(
      String eProviderId, int page) async {
    var _queryParameters = {
      'provider_id': '$eProviderId',
      // 'with': 'eProvider;eProvider.addresses;categories',
      // 'search': 'e_provider_id:$eProviderId',
      // 'searchFields': 'e_provider_id:=',
      // 'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    // Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Uri _uri = getApiBaseUri("service/provider")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getEServiceReviews(String eServiceId) async {
    // var _queryParameters = {'with': 'user', 'only': 'created_at;review;rate;user', 'search': "e_service_id:$eServiceId", 'orderBy': 'created_at', 'sortBy': 'desc', 'limit': '10'};
    var _queryParameters = {
      'with': 'user',
      'only': 'created_at;review;rate;user',
      'search': "e_service_id:$eServiceId",
      'orderBy': 'created_at',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("e_service_reviews")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Review>((obj) => Review.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OptionGroup>> getEServiceOptionGroups(String eServiceId) async {
    var _queryParameters = {
      'with': 'options;options.media',
      'only':
          'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id;options.media',
      'search': "options.e_service_id:$eServiceId",
      'searchFields': 'options.e_service_id:=',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("option_groups")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<OptionGroup>((obj) => OptionGroup.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getFeaturedEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'category_id': '$categoryId',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId;featured:1',
      'searchFields': 'categories.id:=;featured:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("service/category/featured")
        .replace(queryParameters: _queryParameters);
    // Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getPopularEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'category_id': '$categoryId',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getMostRatedEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'category_id': '$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("service/category/rating")
        .replace(queryParameters: _queryParameters);
    // Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getAvailableEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'available_e_provider': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

// Cities
//   Future<List<City>> getAllCities() async {
//     const _queryParameters = {
//       'orderBy': 'order',
//       'sortBy': 'asc',
//     };
//     Uri _uri = getApiBaseUri("cities").replace(queryParameters: _queryParameters);
//     Get.log(_uri.toString());
//     var response = await _httpClient.getUri(_uri, options: _optionsCache);
//     if (response.data['success'] == true) {
//       return response.data['data'].map<City>((obj) => City.fromJson(obj)).toList();
//     } else {
//       throw new Exception(response.data['message']);
//     }
//   }

  Future<List<Event>> getAll() async {
    // print('hahah');
    // const _queryParameters = {
    //   'orderBy': 'order',
    //   'sortBy': 'asc',
    // };
    // Uri _uri = getApiBaseUri("cities").replace(queryParameters: _queryParameters);
    Uri _uri = getApiBaseUri("events");
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Event>((obj) => Event.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Event> getEvent(String id) async {
    var _queryParameters = {
      // 'with': 'eProvider;categories;eProvider.taxes',
      // 'event': '$id',
    };
    // if (authService.isAuth) {
    //   _queryParameters['api_token'] = authService.apiToken;
    // }

    Uri _uri = getApiBaseUri("events/$id");

    Get.log(_uri.toString());
    // var response = await _httpClient.postUri(_uri);

    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Event.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<City>> getAllCities() async {
    // const _queryParameters = {
    //   'orderBy': 'order',
    //   'sortBy': 'asc',
    // };
    // Uri _uri = getApiBaseUri("cities").replace(queryParameters: _queryParameters);
    Uri _uri = getApiBaseUri("cities");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<City>((obj) => City.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<City> getCity(String id) async {
    var _queryParameters = {
      // 'with': 'eProvider;categories;eProvider.taxes',
      'city_id': '$id',
    };

    // if (authService.isAuth) {
    //   _queryParameters['api_token'] = authService.apiToken;
    // }

    Uri _uri = getApiBaseUri("providers/city")
        .replace(queryParameters: _queryParameters);
    // Uri _uri = getApiBaseUri("service/city/11");
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri);
    // var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return City.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllCategories() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("all-categories")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Tag>> getAllTags() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("tags").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Tag.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllParentCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log("Uri Categories :  ${_uri.toString()}");
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
//      Get.log("Data Categories List : ${response.data["data"]}");
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      Get.log("Exeption Error to get Categories : ${response.data["message"]}");
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllSubCategories() async {
    const _queryParameters = {
      'parent': 'false',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getSubCategories(String categoryId) async {
    final _queryParameters = {
      'search': "parent_id:$categoryId",
      'searchFields': "parent_id:=",
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllWithSubCategories() async {
    const _queryParameters = {
      'with': 'subCategories',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getFeaturedCategories() async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'featuredEServices',
      'parent': 'true',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    // Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Uri _uri = getApiBaseUri("category/featured");
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Booking>> getBookings(String statusId, int page) async {
    var _queryParameters = {
      'with': 'bookingStatus;payment;payment.paymentStatus',
      'api_token': authService.apiToken,
      // 'search': 'user_id:${authService.user.value.id}',
      'search': 'booking_status_id:${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("bookings").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Booking>((obj) => Booking.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<BookingStatus>> getBookingStatuses() async {
    var _queryParameters = {
      'only': 'id;status;order',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("booking_statuses")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<BookingStatus>((obj) => BookingStatus.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> getBooking(String bookingId) async {
    var _queryParameters = {
      'with':
          'bookingStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${bookingId}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Coupon> validateCoupon(Booking booking) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'code': booking.coupon?.code ?? '',
      'e_service_id': booking.eService?.id ?? '',
      'e_provider_id': booking.eService?.eProvider?.id ?? '',
      'categories_id':
          booking.eService?.categories?.map((e) => e.id)?.join(",") ?? '',
    };
    Uri _uri =
        getApiBaseUri("coupons").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Coupon.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> updateBooking(Booking booking) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${booking.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!
        .putUri(_uri, data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> addBooking(Booking booking) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ addBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("bookings").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!
        .postUri(_uri, data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Review> addReview(Review review) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ addReview() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_service_reviews")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!
        .postUri(_uri, data: review.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Review.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Review> addReviewWithoutBooking(
      double rate, String review, String user_id, String service_id) async {
    print('addReviewWithoutBooking');
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ addReview() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_service_reviews_app")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.postUri(_uri,
        data: {
          'review': review,
          'user_id': user_id,
          'service_id': service_id,
          'rate': rate,
        },
        options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Review.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> addReviewEproviderWithoutBooking(
      double rate, String review, String apiToken, String provider_id) async {
    print('addReviewProvider');
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ addReview() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = Uri.parse("https://emiratesbd.ae/api/add_review");
    Get.log(_uri.toString());
    var response = await http.post(_uri, body: {
      'place_id': provider_id,
      'review_score': rate.toString(),
      'review': review,
      'api_token': apiToken
    });
    var responseBody = jsonDecode(response.body);
    if (responseBody['success'] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPaymentMethods() ]");
    }
    var _queryParameters = {
      'with': 'media',
      'search': 'enabled:1',
      'searchFields': 'enabled:=',
      'orderBy': 'order',
      'sortBy': 'asc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payment_methods")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<PaymentMethod>((obj) => PaymentMethod.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Wallet>> getWallets() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getWallets() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Wallet>((obj) => Wallet.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> createWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ createWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!
        .postUri(_uri, data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> updateWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!
        .putUri(_uri, data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.deleteUri(_uri, options: _optionsNetwork);

    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getWalletTransactions() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'with': 'user',
      'search': 'wallet_id:${wallet.id}',
      'searchFields': 'wallet_id:=',
    };
    Uri _uri = getApiBaseUri("wallet_transactions")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<WalletTransaction>((obj) => WalletTransaction.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createPayment(Booking _booking) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments/cash")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!
        .postUri(_uri, data: _booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createWalletPayment(Booking _booking, Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments/wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!
        .postUri(_uri, data: _booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  String getPayPalUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPayPalUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/paypal/express-checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getRazorPayUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getRazorPayUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/razorpay/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getStripeUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/stripe/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayStackUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPayStackUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/paystack/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayMongoUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPayMongoUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/paymongo/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getFlutterWaveUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getFlutterWaveUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/flutterwave/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeFPXUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getStripeFPXUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/stripe-fpx/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  Future<List<Notification>> getNotifications() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getNotifications() ]");
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
      'only': 'id;type;data;read_at;created_at',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Notification>((obj) => Notification.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> markAsReadNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ markAsReadNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.putUri(_uri,
        data: notification.markReadMap(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendNotification(
      List<User> users, User from, String type, String text, String id) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ sendNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    var data = {
      'users': users.map((e) => e.id).toList(),
      'from': from.id,
      'type': type,
      'text': text,
      'id': id,
    };
    Uri _uri = getApiBaseUri("notifications")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(data.toString());
    var response =
        await _httpClient!.postUri(_uri, data: data, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> removeNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ removeNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<int> getNotificationsCount() async {
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/count")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<FaqCategory>> getFaqCategories() async {
    var _queryParameters = {
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("faq_categories")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<FaqCategory>((obj) => FaqCategory.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Faq>> getFaqs(String categoryId) async {
    var _queryParameters = {
      'search': 'faq_category_id:${categoryId}',
      'searchFields': 'faq_category_id:=',
      'searchJoin': 'and',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("faqs").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Faq>((obj) => Faq.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Setting> getSettings() async {
    Get.log(
        "---------------------------------------------------------------------");
    Uri _uri = getApiBaseUri("settings");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri);
    if (response.data['success'] == true) {
      return Setting.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<CustomPage>> getCustomPages() async {
    var _queryParameters = {
      'only': 'id;title',
      'search': 'published:1',
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("custom_pages")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<CustomPage>((obj) => CustomPage.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<CustomPage> getCustomPageById(String id) async {
    Uri _uri = getApiBaseUri("custom_pages/$id");
    Get.log(_uri.toString());
    var response = await _httpClient!.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return CustomPage.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> uploadImage(File file) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ uploadImage() ]");
    }
    String fileName = file.path.split('/').last;
    Uri _uri = Uri.parse("https://emiratesbd.ae/api/update_picture");
    dio.FormData formData = dio.FormData.fromMap({
      "userfile":
          await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "api_token": authService.apiToken
    });
    var response = await _httpClient.postUri(_uri, data: formData);
    print(response.data);
    Get.log(response.data['data'].toString());
    if (response.data['success'] == true) {
      return response.data['data']["picture"];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteUploaded(String uuid) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient!.postUri(_uri, data: {'uuid': uuid});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteAllUploaded(List<String> uuids) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient!.postUri(_uri, data: {'uuid': uuids});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }
}
