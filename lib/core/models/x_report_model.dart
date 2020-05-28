import 'package:bsg/api/repository/repositories_api.dart';
import 'package:bsg/core/models/base_model.dart';
import 'package:flutter/material.dart';

class XReportModel extends BaseBloc{

    BsgAPI _api = BsgAPI();

    Future getXReportList(BuildContext context){

      return _api.getCashierXReports(context);
    }

    
}