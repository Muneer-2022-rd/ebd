import 'package:emarates_bd/common/class/curd.dart';

class CategoriesData {
  Crud crud;
  CategoriesData(this.crud);

  getProviderOfCategoriesWithPagenation(int page, String catId) async {
    var response = await crud.postData(
        "https://emiratesbd.ae/api/provider/category?category_id=$catId&limit=4&offset=$page",
        {});
    return response.fold((l) => l, (r) => r);
  }
}
