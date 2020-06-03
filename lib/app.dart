
import 'package:bsg/core/views/auth/login_view.dart';
import 'package:bsg/core/views/home/home_views.dart';
import 'package:bsg/resources/components/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/models/imei_data.dart';
import 'core/models/mqtt_model.dart';


class MyApp extends StatefulWidget {

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
 String imei = "";

 getImei() async {
    ImeiPlugin.getImei().then((value) {   
      if(value.isNotEmpty)         
      setState(() {
        imei = value;
      });
    });  
  }

 @override
  void initState() {  
    getImei();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
          providers: [
            ChangeNotifierProvider<MQTTAppState>(
                  create: (_) => MQTTAppState(),
            ),
            Provider<ImeiString>.value(
              value: ImeiString(imei),
            ),
            // ChangeNotifierProvider<PrinterModel>(
            //       create: (_) => PrinterModel(),
            // ), 
           ],
             child:  MaterialApp(
                debugShowCheckedModeBanner: false,            
                theme: ThemeData(
                  fontFamily: "Rubik",       
                  primarySwatch: Colors.deepPurple,       
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home:FutureBuilder(
                        future: SharedPreferences.getInstance(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) 
                            return Scaffold(
                                body: LoadingWidget()
                            ); 
                          String accessToken = snapshot.data.getString('access_token');                          
                          if(accessToken != null)         
                            return HomeScreen();

                          return LoginScreen();
                        }))
              );
  }
}
