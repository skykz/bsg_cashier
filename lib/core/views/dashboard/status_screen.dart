// import 'package:bsg/core/models/cashier_dashboard.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bsg/core/models/mqtt_model.dart';
import 'package:bsg/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class CashierSalesStatus extends StatelessWidget{
  final int id;
  final String cashier;
  final BlueThermalPrinter bluetooth;
  CashierSalesStatus({Key key,this.id,this.cashier,this.bluetooth}):super(key:key);
  bool isLoaded = true;

  @override
  Widget build(BuildContext context) {

    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    // currentAppState = appState;

    Widget switchScreen(MQTTAppState appState){
      switch (appState.getResponseObject['status_new']) {
        case "waitforapproval":
            return  Padding(
              padding: const EdgeInsets.only(left: 10,top:5),
              child: Column(        
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text("Данные транзакции: ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 20,),

                  Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10),
                   child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.0,
                            color:Colors.black,
                          ),
                          children:<TextSpan>[
                                  TextSpan(text: 'ID: ',
                                        style: TextStyle(fontSize: 20 )),
                                  TextSpan(
                                      text: '${appState.getResponseObject['transaction_id'].toString()}',
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),                           
                                ]
                              ),
                    ),
                 ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.0,
                            color:Colors.black,
                          ),
                          children:<TextSpan>[
                                  TextSpan(text: 'Клиент: ',
                                        style: TextStyle(fontSize: 18 )),
                                  TextSpan(
                                      text: '${appState.getResponseObject['client_company']}',
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),                           
                                ]
                              ),
                    ),
                  ),
                  Padding(
                    padding:const EdgeInsets.symmetric(vertical: 10),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.0,
                            color:Colors.black,
                          ),
                          children:<TextSpan>[
                                  TextSpan(text: 'Логин пользователя: ',
                                        style: TextStyle(fontSize: 18 )),
                                  TextSpan(
                                      text: '${appState.getResponseObject['client_login']}',
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),                           
                                ]
                              ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.0,
                          color:Colors.black,
                        ),
                        children:<TextSpan>[
                                TextSpan(text: 'Топливо: ',
                                      style: TextStyle(fontSize: 18 )),
                                TextSpan(
                                    text: '${appState.getResponseObject['fuel']} / ${appState.getResponseObject['price']} Т/л',
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),                           
                              ]
                            ),
                ),
                  ),
                  Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10),
                   child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.0,
                            color:Colors.black,
                          ),
                          children:<TextSpan>[
                                  TextSpan(text: 'Количество: ',
                                        style: TextStyle(fontSize: 18 )),
                                  TextSpan(
                                      text: '${appState.getResponseObject['quantity']} л',
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),                           
                                ]
                              ),
                    ),
                 ),
                  Padding(
                    padding:const EdgeInsets.symmetric(vertical: 10),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.0,
                            color:Colors.black,
                          ),
                          children:<TextSpan>[
                                  TextSpan(text: 'Сумма: ',
                                        style: TextStyle(fontSize: 18 )),
                                  TextSpan(
                                      text: '${appState.getResponseObject['total_price']} КZT',
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),                           
                                ]
                              ),
                    ),
                  ),
                  SizedBox(height: 70,),
                  Center(
                    child: FlatButton(
                              shape:  RoundedRectangleBorder(
                                  borderRadius:  BorderRadius.circular(10.0)),
                              color: Colors.orange[100],
                              splashColor: Colors.orangeAccent[200],
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Продолжить",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onPressed: () => appState.confirmPayment(appState.getResponseObject['transaction_id']),
                            ),
                  ),
                  SizedBox(height: 100,),
                  Center(
                    child: FlatButton(
                              shape:  RoundedRectangleBorder(
                                  borderRadius:  BorderRadius.circular(10.0)),
                              color: Colors.grey,
                              splashColor: Colors.orangeAccent[200],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  " Отменить ",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context)
                            ),
                      ),
                    ],
                  ),
            );        
          break;
        case "canceled":
            return  Column(        
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

              appState.canceledStatus?Icon(Icons.info_outline,color:Colors.orange,size:80):CircularProgressIndicator(
                strokeWidth: 3,                
                backgroundColor: Colors.purple,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),      
              SizedBox(height: 10,),
              Text("Транзакция отменена.",
              textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 25,                
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: appState.canceledStatus?20:100,),
              Text("Оплата не произведена.",                          
              style: TextStyle(
                fontSize: 20,              
              ),
              textAlign: TextAlign.center,
              ),
              SizedBox(height: 40,),             
              SizedBox(height: 150,),
              FlatButton(
                        shape:  RoundedRectangleBorder(
                            borderRadius:  BorderRadius.circular(10.0)),
                        color: Colors.grey,
                        splashColor: Colors.orangeAccent[200],
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            " ОК ",
                            style: TextStyle(
                                fontSize:appState.canceledStatus?30: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () => {
                            appState.setNulltoObject(),
                            Navigator.pop(context),
                            Navigator.pop(context)                          
                         },
                      ),
            ],
          );
          break;
        case "paid":
          return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
               Text("Оплата успешно прошла",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),),

                  Builder(
                        builder:(ctx) => FlatButton(
                              shape:  RoundedRectangleBorder(
                                  borderRadius:  BorderRadius.circular(10.0)),
                              color: Colors.greenAccent[100],
                              splashColor: Colors.green[200],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  " ОК ",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onPressed: () => _printAndBack(appState,ctx)
                            ),
                  ),
          ], 
        );

        default: 
          return Column(        
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

             CircularProgressIndicator(
                strokeWidth: 3,                
                backgroundColor: Colors.purple,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),      
              SizedBox(height: 10,),
              Text("Ожидается подтверждение клиента...",
              textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 25,                
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: appState.canceledStatus?20:100,),
              Text("Попросите клиента отсканировать QR-код терминала.",                          
              style: TextStyle(
                fontSize: 20,              
              ),
              textAlign: TextAlign.center,
              ),
              SizedBox(height: 40,),             
              SizedBox(height: 150,),
              FlatButton(
                        shape:  RoundedRectangleBorder(
                            borderRadius:  BorderRadius.circular(10.0)),
                        color: Colors.grey,
                        splashColor: Colors.orangeAccent[200],
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(" Отменить ",
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () => {
                          if(appState.canceledStatus == true){
                            Navigator.pop(context),
                            Navigator.pop(context)
                          }
                          else {
                            appState.doCancelCashierSales(id)
                            }
                         },
                      ),
            ],
          );
          break;        
      }
    }


    return  Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Статус оплаты",style:TextStyle(
          fontSize: 22,
          color:Colors.black
        )),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: switchScreen(appState)          
      ),
    );
  
  }

  void _printAndBack(MQTTAppState appState,BuildContext context) {    

     bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
          if(appState.dataFromMqtt != null){
            
            DateTime a = DateTime.tryParse(appState.dataFromMqtt['datetime']); 
            String b = TimeOfDay.fromDateTime(a).format(context);    
            
            String year = "${DateTime.parse(appState.dataFromMqtt['datetime']).year}-"+
                      "${DateTime.parse(appState.dataFromMqtt['datetime']).month}-"+
                      "${DateTime.parse(appState.dataFromMqtt['datetime']).day}";

            bluetooth.printNewLine();
            bluetooth.printCustom("Payment Success", 4, 1);      
            bluetooth.printCustom("----------------------------", 1, 1);
            bluetooth.printNewLine();

             
            bluetooth.printCustom("Cashier:  $cashier", 1, 0);          
            bluetooth.printCustom(
            "ID:  ${appState.dataFromMqtt['transaction_id']} \n"+
            "Data:  $year \n"+
            "Time:  $b \n"+
            "Client login:  ${appState.dataFromMqtt['client_login']} \n"+
            "Status:  ${(appState.dataFromMqtt['status_new'])} \n" +
            "GAS:  ${(appState.dataFromMqtt['fuel']).toString().replaceAll("АИ","Au")}\n"+
            "Litters:  ${appState.dataFromMqtt['quantity']} L\n"+
            "Price:   ${appState.dataFromMqtt['price']} KZT/L\n "+
            "Sum:  ${appState.dataFromMqtt['total_price']} KZT \n", 1, 1);                                          
            
            bluetooth.printCustom("----------------------------", 1, 1);        
            bluetooth.printNewLine();
            bluetooth.printNewLine();
            bluetooth.printNewLine();
            bluetooth.printNewLine();
            bluetooth.paperCut();

              appState.setNulltoObject();                   
              Navigator.pop(context);
              Navigator.pop(context);
          }    
        showCustomSnackBar(context, 'Данные из MQTT пусто', Colors.redAccent, Icons.info_outline);

      }else{
        showCustomSnackBar(context, 'Bluetooth не подключен!', Colors.redAccent, Icons.info_outline);
      }             
     });
  }


}