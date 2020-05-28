import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

class PrinterModel with ChangeNotifier{

  List<BluetoothDevice> _listDevices = List();
  bool _isConnected = false;
  bool _globalConnect = false;

  bool get getConnectionState => _isConnected;
  bool get getGlobalConnect =>_globalConnect;


  void setConnectionState(bool val){
    this._isConnected = val;
    notifyListeners();
  }
  void setGlobalConnectionState(bool val){
    this._globalConnect = val;
    notifyListeners();
  }
  void setDevicesList(List<BluetoothDevice> val){
    this._listDevices = val;
    notifyListeners();
  }

  
}