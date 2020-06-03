import 'dart:developer';

import 'package:bsg/api/repository/repositories_api.dart';
import 'package:flutter/material.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class MQTTAppState with ChangeNotifier{
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;
  dynamic _receivedObject = {'status_new':null};  
  dynamic get getResponseObject => _receivedObject;
  BsgAPI _api = BsgAPI();
  bool _isSuccess = false;
  dynamic _dataMqtt;
  dynamic get dataFromMqtt => _dataMqtt;
  bool get isSuccessfull => _isSuccess;

  void setReceivedText(dynamic text) {
    this._receivedObject = text;
    this._dataMqtt = text;
    log("message ------------ $text");
    notifyListeners();
  }
  
  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }
  
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;


  bool _isloaded = true;
  bool _isCanceled = false;
  bool get canceledStatus => _isCanceled;
  bool get loaded => _isloaded;


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  void setLoading(bool value){
    _isLoading = value;    
    notifyListeners();
  }
  
  void getDetailData(bool val){
    this._isloaded = val;
    notifyListeners();
  }

  void setCencel(bool val){
    this._isCanceled = val;
    notifyListeners();
  }

   void setNulltoObject(){
    this._receivedObject = {'status_new':null};
    notifyListeners();
  }


  Future doPayment( int fuelId,String quantity, double totalPrice,BuildContext context) async {
    
    return await _api.doCashierSalesPost(fuelId, quantity, totalPrice,context);
  }

  doCancelCashierSales(int id) async {

    setLoading(true);
     _api.cancelCashierSales(id).then((value) => {
       if(value['message'] == 'sales.cashier.canceled.success')
       setCencel(true)
     }).whenComplete((){       
        setLoading(false);
     });

  } 

  Future getCashierSalesDetail(int id) async {
    return await _api.searchSalesById(id);
  }

  Future confirmPayment(int id) async {
    setLoading(true);
    return await _api.confirmPayment(id).then((value){
      if(value['message'] != null)
        setSuccess(true);
    }).whenComplete((){
      this._receivedObject = {'status_new':'paid'};
      setLoading(false);
    });
  }

  void setSuccess(bool val){
    this._isSuccess = val;
    notifyListeners();
  }
} 