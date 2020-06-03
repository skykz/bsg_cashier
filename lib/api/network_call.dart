
import 'dart:developer';

import 'package:bsg/utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String BASE_URL = "https://api.elitefuel.kz/";

class NetworkCall {
  // next three lines makes this class a Singleton
  static NetworkCall _instance = NetworkCall.internal();

  NetworkCall.internal();
  factory NetworkCall() => _instance;

  final JsonDecoder _decoder = JsonDecoder();
  dynamic _decodedRes;

  Future<dynamic> doRequestAuth(
      {@required String path,
      @required String method,
      @required BuildContext context,
      Map<String, dynamic> requestParams,
      Map<String, dynamic> body,
      FormData formData}) async {
    BaseOptions options = BaseOptions(

        baseUrl: BASE_URL, //base server url
        // connectTimeout: 20000, // 10 sec.
        // receiveTimeout: 20000,               
        method: method,);               
        //contentType: ContentType.parse("application/json").value);

    Dio dio = Dio(options);
    Response response;

    try {     
        response =
            await dio.request(path, queryParameters: requestParams, data: body);
      
      log("api route -- $path");
      printWrapped(' ==== RESPONSE: $response');

      _decodedRes = _decoder.convert(response.toString());
      return _decodedRes;
    } on DioError catch (error) {
      handleError(error, context);
    }
  }

  Future<dynamic> doRequestMain(
      {@required String path,
      @required String method,
      @required BuildContext context,
      Map<String, dynamic> requestParams,
      Map<String, dynamic> body}) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString("access_token");

    BaseOptions options = BaseOptions(
      baseUrl: BASE_URL, //base server url
      // connectTimeout:20000, // 10 sec.
      // receiveTimeout:20000,
      method: method,
      headers: {'Authorization': 'Bearer ' + accessToken},
      contentType: 'application/json',
    );
    
    Dio dio = Dio(options);
    Response response;
    try {
      response =
          await dio.request(path, queryParameters: requestParams, data: body);

      // if(path != '/image' && path != '/specialist/chat/get'){
      log("api route -- $path");
      printWrapped(' ==== RESPONSE: $response');

      // }

      return response.data;
    } on DioError catch (error) {
      print(' --- req main errors +++++++++ $error');     
      handleError(error, context);      
    }
  }

 
}

/// handling avaiable cases from server
void handleError(DioError error, BuildContext context) {
  String errorDescription = error.response.data['message'];  
  log("$errorDescription");

  if (error is DioError) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        errorDescription = 'Запрос был отменен';
        print(errorDescription);

        break;
      case DioErrorType.CONNECT_TIMEOUT:
        errorDescription = 'Попробуйте позже или перезагрузите';
        print(errorDescription);

        break;
      case DioErrorType.DEFAULT:
        errorDescription = 'Сеть не обнаружена';
        print(errorDescription);

        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        errorDescription = 'Время ответа сервера истекло';
        print(errorDescription);

        break;
      case DioErrorType.RESPONSE:
        // errorDescription = 'Ошибка сервера';
        errorDescription = error.response.data['message'];  
        print(errorDescription);

        break;
      case DioErrorType.SEND_TIMEOUT:
        errorDescription = 'Время соединения истекло';
        print(errorDescription);
        break;
    }
  }

   Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: Duration(seconds: 20),
        backgroundColor: Colors.red[600],
         action: SnackBarAction(
            label: 'ОК',
            textColor: Colors.white,
            onPressed: (){},            
          ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.error_outline,color:Colors.white),
            Expanded(child: Padding( padding:EdgeInsets.only(left:16), 
            child:Text(errorDescription,
            style: TextStyle(color: Colors.white),) )),
          ],
        ),
      ),
    );
}
