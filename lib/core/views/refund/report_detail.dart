import 'dart:developer';

import 'package:bsg/api/repository/repositories_api.dart';
import 'package:bsg/core/views/refund/refund_screen.dart';
import 'package:bsg/resources/components/loading_screen.dart';
import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget{
  final dynamic object;
  BsgAPI _api = BsgAPI();

  ReportDetailScreen({this.object});

  @override
  Widget build(BuildContext context) {
    log("$object");
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Данные транзакции ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close,color: Colors.white,), 
          onPressed: () => Navigator.pop(context)),
      ),
      body:SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FutureBuilder(
                      future: _api.searchSalesById((object['id'])),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) 
                          return LoadingWidget();

                          return Column(        
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[                           

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,),
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
                                                text: '${snapshot.data['transaction_id']}',
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
                                            TextSpan(text: 'Дата-время: ',
                                                  style: TextStyle(fontSize: 20 )),
                                            TextSpan(
                                                text: '${DateTime.parse(snapshot.data['datetime']).toLocal()}',
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
                                            TextSpan(text: 'Компания клиента: ',
                                                  style: TextStyle(fontSize: 18 )),
                                            TextSpan(
                                                text: snapshot.data['client_company'] != "" ?'${snapshot.data['client_company']}':'пусто',
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
                                                text:snapshot.data['client_login'] !=""?'${snapshot.data['client_login']}':'пусто',
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
                                              text: '${snapshot.data['fuel']} / ${snapshot.data['price']} Т/л',
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
                                                text: '${snapshot.data['quantity']} л',
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
                                                text: '${snapshot.data['total_price']}',
                                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),                           
                                          ]
                                        ),
                              ),
                            ),
                            SizedBox(height: 50,),
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
                                        onPressed: () => Navigator.pushReplacement(
                                              context, MaterialPageRoute(
                                                  builder: (context) => RefundScreen(
                                                    object: snapshot.data,
                                                  ))),
                                      ),
                            ),
                            SizedBox(height: 50,),
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
            );
                      })
          ),
        ),
      ),
    );
  }


}