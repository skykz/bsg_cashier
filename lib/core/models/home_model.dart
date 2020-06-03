

import 'package:bsg/core/models/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeModel extends BaseBloc{
  
  String sms;
  String keyValue;


  Future<String> getInfoFromDb(String key) async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    
    return _sharedPreferences.getString(key);    
  } 

}