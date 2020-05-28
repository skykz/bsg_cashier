import 'package:flutter/material.dart';

class BaseBloc extends ChangeNotifier{

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _onError = false;
  bool get onError => _onError;
  String _errorText = "";
  String get errorText => _errorText;
  
  void setLoading(bool value){
    _isLoading = value;    
    notifyListeners();
  }

  void catchOnError(bool error,String errorText){
      _onError = error;
      _errorText = errorText;
      notifyListeners();
  }

}