import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    CircularProgressIndicator(
                            backgroundColor: Colors.pinkAccent,
                          ),              
                    SizedBox(height: 10,),    
                    Text("Загрузка ...")    
                ],
    ));
  }



}