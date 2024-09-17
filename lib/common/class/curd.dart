import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';

import 'package:http/http.dart' as http;

class Crud {
  Future<Either<StatusRequest, Map>> postData(String url, Map data,
      {Map<String, String>? headers}) async {
    try {
      var response =
          await http.post(Uri.parse(url), body: data, headers: headers ?? {});
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responseBody = jsonDecode(response.body);
        return Right(responseBody);
      } else {
        return Left(StatusRequest.serverFailure);
      }
    } catch (error) {
      print(error.toString());
      return Left(StatusRequest.failure);
    }
  }

  Future<Either<StatusRequest, Map>> postDataWithFile(
      {required String linkeUrl,
      required Map<String, String> data,
      required File file1,
      required String fileNameApi1,
      File? file2,
      String? fileNameApi2}) async {
    Uri uri = Uri.parse(linkeUrl);
    var request = http.MultipartRequest("POST", uri);
    //file 1
    var fileStream1 = http.ByteStream(DelegatingStream.typed(file1.openRead()));
    var length1 = await file1.length();
    var multipartFile1 = http.MultipartFile(
      fileNameApi1,
      fileStream1,
      length1,
      filename: file1.path.split('/').last,
    );
    //file 2
    if (file2 != null && fileNameApi2 != null) {
      Get.log("File 2 run ");
      var fileStream2 =
          http.ByteStream(DelegatingStream.typed(file2.openRead()));
      var length2 = await file2.length();
      var multipartFile2 = http.MultipartFile(
        fileNameApi2,
        fileStream2,
        length2,
        filename: file2.path.split('/').last,
      );
      request.files.add(multipartFile2);
    }

    request.files.add(multipartFile1);
    request.fields.addAll(data);

    var response = await request.send();
    Get.log(response.statusCode.toString());
    //do whatever you want with the response
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();
      Map decodeMap = jsonDecode(responseBody);
      print(decodeMap);
      return Right(decodeMap);
    } else {
      return const Left(StatusRequest.serverFailure);
    }
  }

//  Future uploadmultipleimage(List images , ) async {
//
//
//    var uri = Uri.parse("");
//    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
//    request.headers[''] = '';
//    request.fields['user_id'] = '10';
//    request.fields['post_details'] = 'dfsfdsfsd';
//    //multipartFile = new http.MultipartFile("imagefile", stream, length, filename: basename(imageFile.path));
//    List<MultipartFile> newList = [];
//    for (int i = 0; i < images.length; i++) {
//      File imageFile = File(images[i].toString());
//      var stream =
//      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//      var length = await imageFile.length();
//      var multipartFile = new http.MultipartFile("imagefile", stream, length,
//          filename: basename(imageFile.path));
//      newList.add(multipartFile);
//    }
//    request.files.addAll(newList);
//    var response = await request.send();
//    if (response.statusCode == 200) {
//      print("Image Uploaded");
//    } else {
//      print("Upload Failed");
//    }
//    response.stream.transform(utf8.decoder).listen((value) {
//      print(value);
//    });
//  }

  Future<Either<StatusRequest, Map>> getData(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responseBody = jsonDecode(response.body);
        print("Response Body : $responseBody");
        return Right(responseBody);
      } else {
        print("server Error");
        return Left(StatusRequest.serverFailure);
      }
    } catch (error) {
      print(error.toString());
      return Left(StatusRequest.failure);
    }
  }

//

//
// Future<Either<StatusRequest , Map>>postDataWithFile(String url , Map  data)async{
//   try{
//     var response = await http.MultipartRequest("POST" , Uri.parse(url));
//     print(response.statusCode);
//     if(response.statusCode ==200 || response.statusCode ==201){
//       Map responseBody = jsonDecode(response.body);
//       return Right(responseBody);
//     }else{
//       return Left(StatusRequest.serverFailure);
//     }
//   }catch(error){
//     print(error.toString());
//     return Left(StatusRequest.failure);
//   }
// }
}
