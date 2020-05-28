import 'package:bsg/api/repository/repositories_api.dart';
import 'package:bsg/resources/components/info_response.dart';
import 'package:flutter/material.dart';
import 'package:bsg/resources/components/alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';

BsgAPI _api = BsgAPI();

Future alertAfterPayment(BuildContext context, String text,[Function onPressed,bool isPositive]) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => CustomActionDialog(
      title: 'Вы действительно хотите выйти из приложения без закрытия смены?',
      onPressed: () =>{},
      cancelOptionText: 'Нет',
      confirmOptionText: 'Да',
    ),
  );
}


void showCustomSnackBar(BuildContext context,String text,Color color,IconData iconData){

      Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          backgroundColor: color,
          action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {              
              },
            ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(iconData,color:Colors.white),
              Expanded(child: Padding( padding:EdgeInsets.only(left:16), 
              child:Text("$text",
              style: TextStyle(color: Colors.white),) )),
            ],
          ),
        ),
      );
    }

signOut(BuildContext context) async {
SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  
  _api.authLogout(context).then((value) async => {
    if(value['message'] == 'Вы вышли из системы.')
    {
      _sharedPreferences.clear(),
    

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
      (Route route) => false)
    }
  });
}

Future<bool> exitApp(BuildContext context) {
  return showDialog(
    context: context,    
    builder: (context) => CustomActionDialog(
      title: 'Вы действительно хотите выйти из приложения без закрытия смены?',
      onPressed: () => signOut(context),
      cancelOptionText: 'Нет',
      confirmOptionText: 'Да',
    ),
  );
}

Future<bool> infoAlertDialog(BuildContext context,String title) {
  return showDialog(
    context: context,
    builder: (context) => InfoAlertDialog(
      title: title,       
    ),
  );
}

void printWrapped(String text) {
  final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

 