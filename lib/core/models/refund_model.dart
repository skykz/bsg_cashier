

import 'package:bsg/api/repository/repositories_api.dart';
import 'package:bsg/core/models/base_model.dart';
import 'package:flutter/widgets.dart';

class RefundModel extends BaseBloc{

  BsgAPI _api = BsgAPI();
  bool isSeaching = false;
  bool get getSearchingState => isSeaching;

  Map<String,dynamic> _object;
  dynamic get getObject => _object;

  Map<String,dynamic> _listObject;
  dynamic get getListObject => _listObject;


  void setSearchingState(bool val){
    this.isSeaching = val;
    notifyListeners();
  }

  void setFetchedObject(dynamic ob){
    this._object = ob;
    notifyListeners();
  }

  void setListObject(dynamic obj){
    this._listObject = obj;
    notifyListeners();
  }

   Future getSearchedSalesById(int id,BuildContext context){
    Future value;
     value = _api.searchSalesById(id,context).then((value) => {
        if(value != null)
          setFetchedObject(value)
     });
     return value;
  }

  Future doRefundUser(int id,BuildContext context) async {
    setLoading(true);
    
    return await _api.doRefund(id,context).whenComplete((){
      setLoading(false);
    });     
  }

  getLastSalesGet(BuildContext context) {
    setLoading(true);
     _api.doCashierSalesGet(context).then((value)=>{
      if(value != null)
      setListObject(value)
    }).whenComplete(() {
      setLoading(false);
    });
  }



}