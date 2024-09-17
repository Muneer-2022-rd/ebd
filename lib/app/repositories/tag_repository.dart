import 'package:get/get.dart';

import '../models/tag_model.dart';
import '../providers/laravel_provider.dart';

class TagRepository {
 late LaravelApiClient _laravelApiClient;

  TagRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Tag>> getAll() {
    return _laravelApiClient.getAllTags();
  }
  //
  // Future<List<Category>> getAllParents() {
  //   return _laravelApiClient.getAllParentCategories();
  // }
  //
  // Future<List<Category>> getAllWithSubCategories() {
  //   return _laravelApiClient.getAllWithSubCategories();
  // }
  //
  // Future<List<Category>> getSubCategories(String categoryId) {
  //   return _laravelApiClient.getSubCategories(categoryId);
  // }
  //
  // Future<List<Category>> getFeatured() {
  //   return _laravelApiClient.getFeaturedCategories();
  // }

}
