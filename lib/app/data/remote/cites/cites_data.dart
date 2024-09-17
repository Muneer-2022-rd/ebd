import 'package:emarates_bd/common/class/curd.dart';

class CitesData {
  Crud crud;
  CitesData(this.crud);

  getProviderOfCitesWithPagenation(int page, String cityId) async {
    var response = await crud.postData(
        "https://emiratesbd.ae/api/provider/city?city_id=$cityId&limit=4&offset=$page",
        {});
    return response.fold((l) => l, (r) => r);
  }
}
