import 'package:emarates_bd/common/class/curd.dart';

class LogoutData {
  Crud crud;

  LogoutData(this.crud);

  logout(String api_token) async {
    var response = await crud.postData("https://emiratesbd.ae/api/logout", {
      "api_token": api_token,
    });
    return response.fold((l) => l, (r) => r);
  }
}
