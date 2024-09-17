import 'package:emarates_bd/common/class/curd.dart';

class SearchData {
  Crud crud;
  SearchData(this.crud);

  searchProviderWithCites(String cityId, String query, int page) async {
    print("cityId :  $cityId");
    print("query: $query");
    if ((cityId != null || cityId.isEmpty) && query.isNotEmpty) {
      var response = await crud.getData(
          "https://emiratesbd.ae/api/search?city_id=$cityId&query=$query&limit=5&offset=$page");
      return response.fold((l) => l, (r) => r);
    } else if ((cityId == null || cityId.isEmpty) && query.isNotEmpty) {
      var response = await crud.getData(
          "https://emiratesbd.ae/api/search?city_id=&query=$query&limit=5&offset=$page");
      return response.fold((l) => l, (r) => r);
    }
  }
}
