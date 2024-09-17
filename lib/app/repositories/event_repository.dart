import 'package:get/get.dart';

import '../models/event_model.dart';
import '../providers/laravel_provider.dart';

class EventRepository {
 late LaravelApiClient _laravelApiClient;

  EventRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Event>> getAllEvents() {
    return _laravelApiClient.getAll();
  }
  Future<Event> getEvent(String id) {
    return _laravelApiClient.getEvent(id);
  }
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
