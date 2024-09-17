import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices extends GetxService{
  SharedPreferences? sharedPreferences ;

  Future<SharedPrefServices> init() async{
    sharedPreferences = await SharedPreferences.getInstance();
    return this ;
  }

}