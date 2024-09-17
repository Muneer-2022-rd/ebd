import 'package:emarates_bd/common/class/curd.dart';

class HomeData {
  Crud crud;
  HomeData(this.crud);

  getLatestProviders() async {
    var response =
        await crud.getData("https://emiratesbd.ae/api/latest_providers");
    return response.fold((l) => l, (r) => r);
  }
}
