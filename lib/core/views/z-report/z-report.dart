import 'dart:developer';

import 'package:bsg/app.dart';
import 'package:bsg/core/models/base_provider.dart';
import 'package:bsg/core/models/z_report_model.dart';
import 'package:flutter/material.dart';

class ZReportScreen extends StatelessWidget{
  final String title;
  final String subtitle;
  final String defaul;

  ZReportScreen({this.defaul,this.subtitle,this.title});

  @override
  Widget build(BuildContext context) {

    log("rebuilded");
    
    return BaseProvider<ZReportModel>(      
      model: ZReportModel(),
      builder: (context,model,child) => Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close,color: Colors.black,), 
          onPressed: () => Navigator.pop(context)),
      ),
      body: Center(
        child: model.isLoading?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.purpleAccent,
              strokeWidth: 2,
            ),
            SizedBox(height: 10,),
            Text("Загрузка...",style:TextStyle(
              color: Colors.black87,
              fontSize: 22
            ))
          ],
        ) : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(        
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(model.getClosed?"Печать Z-отчета":"Закрытие смены",style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 20,),
              Text(model.getClosed?"Подтвердите успешную печать отчета":"Печать Z-отчет будет произведена после закрытия смены.",style: TextStyle(
                fontSize: 20,              
              ),
              textAlign: TextAlign.center,
              ),
              SizedBox(height: 70,),              
              Builder(
                       builder: (ctx) => FlatButton(
                          shape:  RoundedRectangleBorder(
                              borderRadius:  BorderRadius.circular(10.0)),
                          color: Colors.orange[100],
                          splashColor: Colors.orangeAccent[200],
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              model.getClosed?"Подтвердить \n успешную печать":"Подтвердить \n закрытие смены",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () {
                             if(model.getClosed != true){
                               _closeCashierShift(ctx,model);
                             }else{
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                                      Animation secondaryAnimation) {
                                    return MyApp();
                                  }, transitionsBuilder: (BuildContext context, Animation<double> animation,
                                      Animation<double> secondaryAnimation, Widget child) {
                                    return  SlideTransition(
                                      position:  Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    );
                                  }),
                                  (Route route) => false);
                            }
                          },
                        ),
              ),
              SizedBox(height: 150,),              
              FlatButton(
                        shape:  RoundedRectangleBorder(
                            borderRadius:  BorderRadius.circular(10.0)),
                        color: Colors.grey,
                        splashColor: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                             !model.getClosed?" Отменить ":" Повторить \n печать Z-отчета ",
                             textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: (){
                          if(model.getClosed != true)
                           Navigator.pop(context);
                           else
                           _printReport();
                           }
                      )
            ],
          ),
        ),
      ),
    ));
  }

  _closeCashierShift(BuildContext ctx,ZReportModel model){
      //TODO: print check with POS printer
      model.closeShift(ctx);
  }

  _printReport(){
    log("print otchet");
  }
}