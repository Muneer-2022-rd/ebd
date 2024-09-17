import 'dart:convert';
import 'package:emarates_bd/app/models/singleProviderModel.dart';
import 'package:emarates_bd/common/class/curd.dart';
import 'package:http/http.dart' as http;

class EproviderData {
  Crud crud;
  EproviderData(this.crud);

  getEProviderDetails(String eProviderId) async {
    print("Eprovider Single :  $eProviderId");
    var response = await crud.postData("https://emiratesbd.ae/api/company", {
      "place_id": eProviderId.toString(),
    });
    print(response);
    return response.fold((l) => l, (r) => r);
  }

  Future<SingleProviderModel?> getEProvider(String eProviderId) async {
    var response = await http.post(
        Uri.parse("https://emiratesbd.ae/api/company"),
        body: {"place_id": eProviderId});
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body);
      if (data["success"] == true) {
        print(data['data']);
        return SingleProviderModel.fromJson(data);
      } else {
        throw new Exception(data['message']);
      }
    } else {
      print("404");
    }
  }
}
