import 'package:emarates_bd/common/class/curd.dart';

class LoginData {
  Crud crud;

  LoginData(this.crud);

  login(
    String email,
    String password,
  ) async {
    print("email $email");
    var response = await crud.postData("https://emiratesbd.ae/api/login", {
      "email": email,
      "password": password,
    });
    return response.fold((l) => l, (r) => r);
  }
}
