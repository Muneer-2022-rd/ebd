import 'package:get/get.dart';

import '../models/e_service_model.dart';
import '../models/favorite_model.dart';
import '../models/option_group_model.dart';
import '../models/review_model.dart';
import '../providers/laravel_provider.dart';

class EServiceRepository {
 late LaravelApiClient _laravelApiClient;

  EServiceRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<EService>> getAllWithPagination(String categoryId, {required int page}) {
    return _laravelApiClient.getAllEServicesWithPagination(categoryId, page);
  }


  Future<List<EService>> getAllWithPaginationCities(String cityId, {required int page}) {
    return _laravelApiClient.getAllEServicesWithPaginationCities(cityId, page);
  }

  // Future<List<EService>> search(String keywords, List<String> categories, {int page = 1}) {
  //   return _laravelApiClient.searchEServices(keywords, categories, page);
  // }
  Future<List<EService>> search(String keywords, List<String> cities, {int page = 1}) {
    return _laravelApiClient.searchEServices(keywords, cities, page);
  }

  Future<List<Favorite>> getFavorites() {
    return _laravelApiClient.getFavoritesEServices();
  }

  Future<Favorite> addFavorite(Favorite favorite) {
    return _laravelApiClient.addFavoriteEService(favorite);
  }

  Future<bool> removeFavorite(Favorite favorite) {
    return _laravelApiClient.removeFavoriteEService(favorite);
  }

  Future<List<EService>> getRecommended() {
    return _laravelApiClient.getRecommendedEServices();
  }

  Future<List<EService>> getFeatured(String categoryId, {required int page}) {
    return _laravelApiClient.getFeaturedEServices(categoryId, page);
  }

  Future<List<EService>> getPopular(String categoryId, {required int page}) {
    return _laravelApiClient.getPopularEServices(categoryId, page);
  }

  Future<List<EService>> getMostRated(String categoryId, {required int page}) {
    return _laravelApiClient.getMostRatedEServices(categoryId, page);
  }

  Future<List<EService>> getAvailable(String categoryId, {required int page}) {
    return _laravelApiClient.getAvailableEServices(categoryId, page);
  }

  Future<EService> get(String id) {
    return _laravelApiClient.getEService(id);
  }

  Future<List<Review>> getReviews(String eServiceId) {
    return _laravelApiClient.getEServiceReviews(eServiceId);
  }

  Future<List<OptionGroup>> getOptionGroups(String eServiceId) {
    return _laravelApiClient.getEServiceOptionGroups(eServiceId);
  }

  Future<List<EService>> getOffer() {
    return _laravelApiClient.getOfferWeekEServices();
  }

  Future<EService> call(String id) {
    return _laravelApiClient.callEProvider(id);
  }
}
