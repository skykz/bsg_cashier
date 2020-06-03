import 'package:bsg/api/repository/repositories_api.dart';
import 'package:bsg/core/models/base_model.dart';
import 'package:flutter/cupertino.dart';

class DashboardModel extends BaseBloc{

  BsgAPI _api = BsgAPI();

  bool _isloaded = true;
  bool _isCanceled = false;
  bool get canceledStatus => _isCanceled;
  bool get loaded => _isloaded;

  
  void getDetailData(bool val){
    this._isloaded = val;
    notifyListeners();
  }

  void setCencel(bool val){
    this._isCanceled = val;
    notifyListeners();
  }


  Future doPayment( int fuelId,String quantity, double totalPrice,BuildContext context) async {
    setLoading(true);
    return await _api.doCashierSalesPost(fuelId, quantity, totalPrice,context).whenComplete((){
      setLoading(false);
    });
  }

  doCancelCashierSales(int id) async {

    setLoading(true);
     _api.cancelCashierSales(id).then((value) => {
       if(value['message'] == 'sales.cashier.canceled.success')
       setCencel(true)
     });

    setLoading(false);
  } 
 
}