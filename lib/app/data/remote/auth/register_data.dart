import 'dart:io';
import 'package:emarates_bd/common/class/curd.dart';

class RegisterData {
  Crud crud;

  RegisterData(this.crud);

  registerNormal(
    String fName,
    String lName,
    String email,
    String password,
    int userType,
    String jobTitle,
    String phone,
    File? cvFile,
  ) async {
    print("fname $fName");
    print("laname $lName");
    print("email $email");
    print("job Title $jobTitle");
    print("user Type $userType");
    print("File $cvFile");
    if (userType == 1) {
      if (cvFile != null) {
        var response = await crud.postDataWithFile(
          linkeUrl: "https://emiratesbd.ae/api/register",
          data: {
            "fname": fName,
            "lname": lName,
            "email": email,
            "password": password,
            "user-type": userType.toString(),
            "jobtitle": jobTitle,
          },
          file1: cvFile,
          fileNameApi1: "mycv",
        );

        return response.fold((l) => l, (r) => r);
      } else {
        var response =
            await crud.postData("https://emiratesbd.ae/api/register", {
          "fname": fName,
          "lname": lName,
          "email": email,
          "password": password,
          "user-type": userType.toString(),
          "jobtitle": jobTitle,
          "phone": phone,
        });
        return response.fold((l) => l, (r) => r);
      }
    }
  }
}
