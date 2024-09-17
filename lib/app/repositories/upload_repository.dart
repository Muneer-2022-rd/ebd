import 'dart:io';

import 'package:get/get.dart';

import '../providers/laravel_provider.dart';

class UploadRepository {
 late LaravelApiClient _laravelApiClient;

  UploadRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<String> image(File image) {
    return _laravelApiClient.uploadImage(image);
  }

  Future<bool> delete(String uuid) {
    return _laravelApiClient.deleteUploaded(uuid);
  }

  Future<bool> deleteAll(List<String> uuids) {
    return _laravelApiClient.deleteAllUploaded(uuids);
  }
}
