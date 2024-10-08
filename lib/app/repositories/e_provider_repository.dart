import 'package:get/get.dart';
import 'package:emarates_bd/app/models/singleProviderModel.dart';
import '../models/award_model.dart';
import '../models/e_provider_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../providers/laravel_provider.dart';

class EProviderRepository {
  late LaravelApiClient _laravelApiClient;

  EProviderRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<EProvider>> search(String keywords, List<String> cities,
      {int page = 1}) {
    return _laravelApiClient.searchEProvider(keywords, cities, page);
  }

  Future<List<EProvider>> getAllWithPaginationCities(String cityId,
      {required int page}) {
    return _laravelApiClient.getAllEProviderWithPaginationCities(cityId, page);
  }

  Future<List<ProviderModel>> getAllWithPagination(String categoryId,
      {required int page}) {
    return _laravelApiClient.getAllProvidersWithPagination(categoryId, page);
  }

  Future<SingleProviderModel> get(int eProviderId) {
    return _laravelApiClient.getEProvider(eProviderId);
  }

  Future<List<ProviderModel>> getAllProvider() {
    return _laravelApiClient.getAllProvider();
  }

  Future<List<ProviderModel>> getFetauredProvider() {
    return _laravelApiClient.getFetauredProvider();
  }

  Future<List<Review>> getReviews(String eProviderId) {
    return _laravelApiClient.getEProviderReviews(eProviderId);
  }

  Future<List<Gallery>> getGalleries(String eProviderId) {
    return _laravelApiClient.getEProviderGalleries(eProviderId);
  }

  Future<List<Award>> getAwards(String eProviderId) {
    return _laravelApiClient.getEProviderAwards(eProviderId);
  }

  Future<List<Experience>> getExperiences(String eProviderId) {
    return _laravelApiClient.getEProviderExperiences(eProviderId);
  }

  Future<List<EService>> getEServices(String eProviderId, {required int page}) {
    return _laravelApiClient.getEProviderEServices(eProviderId, page);
  }

  Future<List<User>> getEmployees(String eProviderId) {
    return _laravelApiClient.getEProviderEmployees(eProviderId);
  }

  Future<List<EService>> getPopularEServices(String eProviderId,
      {required int page}) {
    return _laravelApiClient.getEProviderPopularEServices(eProviderId, page);
  }

  Future<List<EService>> getMostRatedEServices(String eProviderId,
      {required int page}) {
    return _laravelApiClient.getEProviderMostRatedEServices(eProviderId, page);
  }

  Future<List<EService>> getAvailableEServices(String eProviderId,
      {required int page}) {
    return _laravelApiClient.getEProviderAvailableEServices(eProviderId, page);
  }

  Future<List<EService>> getFeaturedEServices(String eProviderId,
      {required int page}) {
    return _laravelApiClient.getEProviderFeaturedEServices(eProviderId, page);
  }

  Future<EProvider> callJustProvider(String eProviderId) {
    return _laravelApiClient.callJustProvider(eProviderId);
  }
}
