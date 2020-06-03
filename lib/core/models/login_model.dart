
import 'package:bsg/core/models/base_model.dart';
import 'package:bsg/api/repository/repositories_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginModel extends BaseBloc{

  BsgAPI _api = BsgAPI();
  bool _isHide = true;
  dynamic onValue;  
  bool get passwordState => _isHide;
  
  void showPassword(bool val){
      this._isHide = val == true?false:true;
      notifyListeners();
  }
 

  Future<dynamic> doAuth(String login,String password,BuildContext context) async { 
   SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

      onValue =  _api.authLogin(login,password,context).then((value) async {

      await _sharedPreferences.setString('access_token', value['token']['token']);
      await _sharedPreferences.setString('user_surname', value['user']['surname']);
      await _sharedPreferences.setString('user_name', value['user']['name']);
      await _sharedPreferences.setString('user_phone', value['user']['phone_number']);
      await _sharedPreferences.setInt('user_balance', value['user']['balance']);
      await _sharedPreferences.setString('user_email', value['user']['email']);

      await _sharedPreferences.setString('mqtt_server', value['mqtt']['server']);
      await _sharedPreferences.setString('mqtt_user', value['mqtt']['user']);
      await _sharedPreferences.setString('mqtt_password', value['mqtt']['password']);
      await _sharedPreferences.setString('mqtt_topic', value['mqtt']['topics']['transactions']);      
      
      return value['message'];
    }).catchError((onError){      
    });  
    return onValue;

  }


}