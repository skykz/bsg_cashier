import 'package:bsg/api/repository/repositories_api.dart';
import 'package:bsg/core/models/base_model.dart';
import 'package:flutter/material.dart';

class ZReportModel extends BaseBloc{

    BsgAPI _api = BsgAPI();
    bool _isClosed = false;
    bool get getClosed => _isClosed;

    void setShiftClosedState(bool val){
      this._isClosed = val;
      notifyListeners();
    }

    Future closeShift(BuildContext context){
      setLoading(true);
      return _api.closeCashierShift(context).then((value){
        if(value['message'] == "Смена закрыта"){
          setShiftClosedState(true);
        }
      }).whenComplete(() {
        setLoading(false);
      });
    }

    
}