import 'package:bsg/api/network_call.dart';
import 'package:flutter/material.dart';

class BsgAPI {
  static BsgAPI _instance = BsgAPI.internal();
  BsgAPI.internal();
  factory BsgAPI() => _instance;

  NetworkCall _networkCall = NetworkCall();


  // CASHIER
  static const AUTH_LOGIN = 'auth/login';
  static const AUTH_LOGOUT = 'auth/logout';

  static const CASHIER_SHIFT = 'cashier/shifts';
  static const CASHIER_SHIFT_CLOSE = 'cashier/shifts/close';
  static const CASHIER_SALES_POST = 'cashier/sales';
  static const CASHIER_SALES_CANCEL_BY_ID = 'cashier/sales/';
  static const CASHIER_SALES_GET = 'cashier/sales/';
  static const CASHIER_SALES_PAID_BY_ID = 'cashier/sales/';
  static const CASHIER_SALES_REFUND_BY_ID = 'cashier/sales/';
  static const CHECK_SHIFT_STATUS = 'cashier/shifts/is_open';
  static const CASHIER_REPORT_X_REPORT_GET = '/cashier/reports/x-report';


  Future<dynamic> authLogin(String login,String password,[BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestAuth(
          path: AUTH_LOGIN,
          method: 'POST',
          context: context,
          body: {
            "login": login,
            "password": password});
            
      return response;     
  }

    Future<dynamic> authLogout([BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: AUTH_LOGOUT,
          method: 'POST',
          context: context,
          );
            
      return response;     
  }
  
  Future<dynamic> checkShiftIsOpen(String imei,[BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: CHECK_SHIFT_STATUS,
          method: 'GET',
          context: context,           
          requestParams: {
            'imei':imei
          }        
      );
            
      return response;     
  }

  Future<dynamic> getCashierShift(String imei, [BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: CASHIER_SHIFT,
          method: 'POST',
          context: context,
          body: {
            'imei': imei
          }
          );
            
      return response;     
  }

  Future<dynamic> doCashierSalesPost(int fuelId, String quantity, double totalPrice, [BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: CASHIER_SALES_POST,
          method: 'POST',
          context: context,
          body: {
            'fuel_id':fuelId,
            'quantity':quantity,
            'total_price':totalPrice
          }
          );
            
      return response;     
  }
  
  Future<dynamic> doCashierSalesGet([BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: CASHIER_SALES_GET,
          method: 'GET',
          context: context,         
          );
            
      return response;     
  }

  Future<dynamic> cancelCashierSales(int id,[BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: CASHIER_SALES_CANCEL_BY_ID+"$id/cancel",
          method: 'PUT',
          context: context,         
          );
            
      return response;     
  }

  Future<dynamic> doRefund(int id,[BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: CASHIER_SALES_REFUND_BY_ID+"$id/refund",
          method: 'PUT',
          context: context,         
          );
            
      return response;     
  }

  Future<dynamic> getCashierXReports([BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: CASHIER_REPORT_X_REPORT_GET,
          method: 'GET',
          context: context,         
          );
            
      return response;     
  }

  Future<dynamic> searchSalesById(int id,[BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: "cashier/sales/$id",
          method: 'GET',
          context: context,                   
      );
            
      return response;     
  }

  Future<dynamic> confirmPayment(int id,[BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: CASHIER_SALES_PAID_BY_ID+"$id/paid",
          method: 'PUT',
          context: context,         
          );
            
      return response;     
  }


   Future<dynamic> closeCashierShift([BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: CASHIER_SHIFT_CLOSE,
          method: 'PUT',
          context: context,                 
      );
            
      return response;     
  }

    Future<dynamic> getNextOrPrevPage(String url,[BuildContext context]) async {
    
      dynamic response = await _networkCall.doRequestMain(
          path: url,
          method: 'GET',
          context: context,                   
      );            
      return response;     
  }
}
