import 'dart:io';

import 'package:get/get.dart';
import 'package:emarates_bd/common/class/curd.dart';

class QuickListingData {
  Crud crud;

  QuickListingData(this.crud);

  registerNewQuickListing(
    String fName,
    String lName,
    String email,
    String password,
    String coName,
    String coAddress,
    String coEmail,
    String categories,
    String phone,
    String cityId,
    File logoCompany,
    File coverCompany,
  ) async {
    print(" fname $fName");
    print("laname $lName");
    print("email $email");
    print("password $password");
    print("coName $coName");
    print("coAdress $coAddress");
    print("coEmail $coEmail");
    print("categories $categories");
    print("cityId : $cityId");
    print("logo company : ${logoCompany.path}");
    print("cover company : ${coverCompany.path}");
    var response = await crud.postDataWithFile(
        linkeUrl: "https://emiratesbd.ae/api/provider_request",
        data: {
          "fname": fName,
          "lname": lName,
          "email": email,
          "password": password,
          "phone": phone,
          "coname": coName,
          "coaddress": coAddress,
          "coemail": coEmail,
          "categories": categories,
          "city_id": cityId,
        },
        file1: logoCompany,
        fileNameApi1: 'userfile',
        file2: coverCompany,
        fileNameApi2: 'cover');
    return response.fold((l) => l, (r) => r);
  }

  registerCompany(
      String coName,
      String coAddress,
      String coEmail,
      String categories,
      String cityId,
      String api_token,
      File logoCompany,
      File coverCompany) async {
    Get.log("coName $coName");
    Get.log("coAdress $coAddress");
    Get.log("coEmail $coEmail");
    print("logo company : ${logoCompany.path}");
    print("cover company : ${coverCompany.path}");
    var response = await crud.postDataWithFile(
        linkeUrl: "https://emiratesbd.ae/api/company_request",
        data: {
          "coname": coName,
          "coaddress": coAddress,
          "coemail": coEmail,
          "categories": categories,
          "city_id": cityId,
          "api_token": api_token
        },
        file1: logoCompany,
        fileNameApi1: 'userfile',
        file2: coverCompany,
        fileNameApi2: 'cover');
    return response.fold((l) => l, (r) => r);
  }

  editQuickListing(
    String token,
    int placeId,
    String email2,
    String twitter,
    String postalCode,
    String facebook,
    String instagram,
    String whatsapp,
    String linkedin,
    String snapchat,
    String pinterest,
    String website,
    String tollFree,
    String description,
    String phone,
    String mobile,
    String fax,
    String managerName,
    String busnessName,
    String estYear,
    String empNumber,
    String lat,
    String lng,
  ) async {
    Get.log(placeId.toString());
    Get.log(token.toString());
    Get.log(email2.toString());
    Get.log(phone.toString());
    Get.log(mobile.toString());
    Get.log("whatsapp : $whatsapp");
    Get.log("FaceBook : $facebook");
    Get.log("Lat : $lat");
    Get.log("Long : $lng");
    var response =
        await crud.postData("https://emiratesbd.ae/api/edit-listing", {
      "api_token": token,
      "place_id": placeId.toString(),
      "postal_code": postalCode ?? "",
      "email2": email2 ?? "",
      "twitter": twitter ?? "",
      "facebook": facebook ?? "",
      "instagram": instagram ?? "",
      "whatsapp": whatsapp ?? "",
      "linkedin": linkedin ?? "",
      "snapchat": snapchat ?? "",
      "pinterest": pinterest ?? "",
      "toll_free": tollFree ?? "",
      "website": website ?? "",
      "description": description ?? "",
      "phone": phone ?? "",
      "mobile": mobile ?? "",
      "fax": fax ?? "",
      "emb_num": empNumber ?? "",
      "manager": managerName ?? "",
      "est_year": estYear ?? "",
      "place_name": busnessName ?? "",
      "lat": lat ?? "",
      "lng": lng ?? "",
    }, headers: {}
            // headers: {
            // "API_TOKEN" : token ,
            //  "Accept" : "application/json" ,
            //   "Content-Type" : "application/jso",
            // }
            );
    return response.fold((l) => l, (r) => r);
  }
}
