import 'dart:developer';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bsg/api/repository/repositories_api.dart';
import 'package:bsg/app.dart';
import 'package:bsg/core/models/base_provider.dart';
import 'package:bsg/core/models/home_model.dart';
import 'package:bsg/core/models/imei_data.dart';
import 'package:bsg/core/models/mqtt_model.dart';
import 'package:bsg/core/services/mqtt_class.dart';
import 'package:bsg/core/services/print_service.dart';
import 'package:bsg/core/views/refund/search_by_id.dart';
import 'package:bsg/resources/components/loading_screen.dart';
import 'package:bsg/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:bsg/core/views/dashboard/dashboard_screen.dart';
import 'package:bsg/core/views/x_report/x_report_screen.dart';
import 'package:bsg/core/views/z-report/z-report.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget{
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin,
  AutomaticKeepAliveClientMixin<HomeScreen>{  
  AnimationController _controller;
  BsgAPI _api = BsgAPI();
  Stream<dynamic> getShift;
  Stream<dynamic> checkShiftStatus;   

  MQTTAppState currentAppState;
  MQTTManager manager;
  
  //Bluetooth part
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice _bluetoothDevice;
  bool _connected = false;
  String pathImage;
  TestPrint testPrint;
  String cashier;

 Future checkShiftStatusIsOpen(BuildContext context) async {
    String imei = Provider.of<ImeiString>(context,listen: false).value;
    return _api.checkShiftIsOpen(imei,context);
  }

  Future getShiftInfo(BuildContext context) async {
    String imei = Provider.of<ImeiString>(context,listen: false).value;
    return _api.getCashierShift(imei,context);
  }

  @override
  void initState() {    
    
    initPlatformState();

    checkShiftStatus = checkShiftStatusIsOpen(context).asStream().asBroadcastStream();
    getShift = getShiftInfo(context).asStream().asBroadcastStream();

    super.initState();
    _configureAndConnect();
    _controller = AnimationController(
      vsync: this,
    );
    _controller.repeat(
      period: Duration(milliseconds: 2000),
    );
  }

   Future<void> _configureAndConnect() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    String server = _sharedPreferences.getString("mqtt_server");
    String username = _sharedPreferences.getString("mqtt_user");
    String password = _sharedPreferences.getString("mqtt_password");
    String topic = _sharedPreferences.getString("mqtt_topic");
    log(server);
    log(username);
    log(password);
    log(topic);

    manager = MQTTManager(   
        password:password,     
        username: username,
        server: server,
        topic:topic,
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }

    @override
  void dispose() {        
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    bool isConnected=await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if(isConnected) {
      setState(() {
        _connected=true;
      });
    }
  }

   List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('Нет Bluetooth'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(          
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_bluetoothDevice == null) {
      // show('No device selected.');
    } else {
      bluetooth.isConnected.then((val) {
        if (!val) {
          bluetooth.connect(_bluetoothDevice).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  Widget _buildConnectionStateText(Widget child) {

    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              height: 25,
              color: currentAppState.getAppConnectionState == MQTTAppConnectionState.connected? Colors.greenAccent[100]:Colors.redAccent[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(" MQTT :",style: TextStyle(
                    color: Colors.black,
                    fontSize: 15
                  ),),
                  SizedBox(width: 15,),
                  Center(child: child),
                ],
              )),
        ),
      ],
    );
  }

    // Utility functions
  Widget prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return Text("Подключен",style:TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18
        ));
      case MQTTAppConnectionState.connecting:
        return  SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            strokeWidth: 2,            
          ),
        );
      case MQTTAppConnectionState.disconnected:
        return Text("Не подключен",style:TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    final imei = Provider.of<ImeiString>(context,listen: false).value;

    return BaseProvider<HomeModel>(      
      model: HomeModel(),
      builder: (context,model,child) => SafeArea(          
          child: WillPopScope(
            child: Scaffold(
            resizeToAvoidBottomPadding: true,
            backgroundColor: Colors.grey[200],
            resizeToAvoidBottomInset: true,
            appBar: AppBar(              
              elevation: 1,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Text("Принтер : ",style: TextStyle(
                    color:Colors.black
                  ),),
                  // Text(" Подключен ",style: TextStyle(
                  //   color:Colors.green[300]
                  // ),),
                  // CustomPaint(
                  // painter:  SpritePainter(_controller),
                  // child:  SizedBox(
                  //   width: 30.0,
                  //   height: 30.0,
                  // )),
                  Expanded(
                      child: Center(
                        child: DropdownButton(
                          items: _getDeviceItems(),
                          onChanged: (value) => setState(() => _bluetoothDevice = value),
                          value: _bluetoothDevice,
                          onTap: _connect,
                        ),
                      ),
                    ),
                  // Builder(
                  //      builder: (ctx) => IconButton(
                  //     icon: Icon(Icons.print,color: Colors.purple,), 
                  //     onPressed: () =>_testPrint(ctx)),
                  // )
                ],
              ),
              centerTitle: false,             
            ),
            body: Center(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     mainAxisSize: MainAxisSize.max,
                     children: <Widget>[
                       _buildConnectionStateText(prepareStateMessageFrom(currentAppState.getAppConnectionState)),                       
                        StreamBuilder(
                        stream: checkShiftStatus,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {   

                          if(snapshot.connectionState == ConnectionState.waiting)
                             return LoadingWidget();    

                          if(snapshot.hasError)   
                             return Center(
                                child: Container(
                                  height: 50,
                                  // width: 100,
                                  color: Colors.red[100],
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Text("${snapshot.error}"),
                                  )),
                              );
                                               
                        if(snapshot.data['open'] == true)                    
                          return StreamBuilder(
                          stream:getShift,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) 
                              return LoadingWidget();          

                            if(snapshot.hasError)   
                              return Center(
                                child: Container(
                                  height: 50,
                                  // width: 100,
                                  color: Colors.red[100],
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Text("${snapshot.error}"),
                                  )),
                              );
                              // showCustomSnackBar(context, "Данный терминал неизвестен. Обратитесь к администратору системы.", Colors.redAccent, Icons.info_outline);  
                              
                              return  Expanded(
                                     child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      StreamBuilder(
                                        stream: model.getInfoFromDb('user_surname').asStream().asBroadcastStream(),
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          if (snapshot.data == null) 
                                            return Center(
                                              child: Text("Загрузка..."),
                                            );                                                                                                 
                                            cashier = snapshot.data;    
                                            return Text.rich(                                                                  
                                                  TextSpan(                        
                                                        text: 'Кассир: ',                                                  
                                                        style: TextStyle(
                                                          fontSize: 18, 
                                                          color: Colors.black54),
                                                            children: <TextSpan>[                        
                                                          TextSpan(
                                                              text: snapshot.data,                                                        
                                                              style: TextStyle(                                                                                                
                                                                color: Colors.black54, 
                                                                fontWeight: FontWeight.bold, 
                                                                fontSize: 18                                         
                                                              )),                                                                    // can add more TextSpans here...
                                                        ],
                                                  ),
                                              textAlign: TextAlign.center,
                                        );}),                                            
                                  Builder(
                                     builder: (ctx) => FlatButton(                          
                                      shape:  RoundedRectangleBorder(
                                          borderRadius:  BorderRadius.circular(10.0)),
                                      color: Colors.blueAccent[100],
                                      splashColor: Colors.white,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*0.6,
                                        padding: const EdgeInsets.all(15),
                                        child: const Text(
                                          "Х-отчет",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      onPressed: () => _xReport(ctx)
                                    ),
                                  ),        
                                  FlatButton(
                                    shape:  RoundedRectangleBorder(
                                        borderRadius:  BorderRadius.circular(10.0)),
                                    color: Colors.grey,
                                    splashColor: Colors.white,
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width*0.6,
                                      child:const  Text(
                                        "Z-отчет/Закрыть смены",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ZReportScreen())),
                                  ),                                         

                                  FlatButton(
                                    shape:  RoundedRectangleBorder(
                                        borderRadius:  BorderRadius.circular(10.0)),
                                    color: Colors.green[200],
                                    splashColor: Colors.white,
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width*0.6,
                                      child: const Text(                                
                                        "Произвести оплату",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onPressed: () => Navigator.push(
                                            context, MaterialPageRoute(
                                              builder: (context) => DashBoardCashier(
                                                object: snapshot.data['shift']['fuels'],
                                              )))
                                  ),                           
                                   FlatButton(
                                    shape:  RoundedRectangleBorder(
                                        borderRadius:  BorderRadius.circular(10.0)),
                                      color: Colors.orangeAccent[100],
                                      splashColor: Colors.white,
                                      child:Container(
                                        padding: const EdgeInsets.all(15),
                                        width: MediaQuery.of(context).size.width*0.6,
                                        child: const Text(
                                        "Возврат",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchByIdRefund()))
                                  ),         
                                  FlatButton(
                                    shape:  RoundedRectangleBorder(
                                        borderRadius:  BorderRadius.circular(10.0)),
                                      color: Colors.red[100],
                                      splashColor: Colors.white,
                                      child:Container(
                                        padding: const EdgeInsets.all(15),
                                        width: MediaQuery.of(context).size.width*0.6,
                                        child: const Text(
                                        "Выйти",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onPressed: () => exitApp(context)
                                  )                                     
                                  ],
                                ),
                              )
                              ;});
                         
                             
                            return Expanded(
                               child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                   StreamBuilder(
                                        stream: model.getInfoFromDb('user_surname').asStream().asBroadcastStream(),
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          if (snapshot.data == null) 
                                            return Center(
                                              child: Text("Загрузка..."),
                                            );                                                                                                 

                                            return Text.rich(                                                                  
                                                  TextSpan(                        
                                                        text: 'Кассир: ',                                                  
                                                        style: TextStyle(
                                                          fontSize: 18, 
                                                          color: Colors.black54),
                                                            children: <TextSpan>[                        
                                                          TextSpan(
                                                              text: snapshot.data,                                                        
                                                              style: TextStyle(                                                                                                
                                                                color: Colors.black54, 
                                                                fontWeight: FontWeight.bold, 
                                                                fontSize: 18                                         
                                                              )),                                                                    // can add more TextSpans here...
                                                        ],
                                                  ),
                                              textAlign: TextAlign.center,
                                        );}),
                                  FlatButton(
                                      shape:  RoundedRectangleBorder(
                                      borderRadius:  BorderRadius.circular(10.0)),
                                    color: Colors.green[100],
                                    splashColor: Colors.greenAccent,
                                    child:Container(
                                      padding: const EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width*0.6,
                                      child: Text(
                                        "Начать смену",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  onPressed: (){
                                     _api.getCashierShift(imei).then((value){
                                       if(value != null)
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
                                     });
                                  } 
                                  ),
                                  FlatButton(
                                      shape:  RoundedRectangleBorder(
                                          borderRadius:  BorderRadius.circular(10.0)),
                                        color: Colors.red[100],
                                        splashColor: Colors.white,
                                        child:Container(
                                          padding: const EdgeInsets.all(15),
                                          width: MediaQuery.of(context).size.width*0.6,
                                          child: const Text(
                                          "Выйти",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      onPressed: () => exitApp(context)
                                    ) 
                                ],
                              ),
                            );
                        })
                     ],
                   )                                                                  
            )
      ),
      onWillPop: () => exitApp(context),
    )));
  }

  _xReport(BuildContext ctx) async {
    dynamic list = await Navigator.push(
                  context,MaterialPageRoute(
                    builder: (context) => XReportScreen()));
    if(list != null)                
    _testPrint(ctx,list);

  }

  @override
  bool get wantKeepAlive => true;

   void _testPrint(BuildContext ctx,[dynamic list]) async {
  
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        if(list['sales'].length > 0){
            bluetooth.printNewLine();
            bluetooth.printCustom("X-отчет", 3, 1);      
            bluetooth.printCustom("-----------------------------", 2, 1);
            bluetooth.printCustom(" Дата  | Топливо т / л | KZT / л", 2, 1);
            bluetooth.printNewLine();

          for (var i = 0; i < list['sales'].length; i++) {      
            bluetooth.printCustom("$cashier", 1, 0);          
            bluetooth.printCustom(" ${list['sales'][i]['datetime']}  | ${list['sales'][i]['fuel']}\n${list['sales'][i]['price']}| ${list['sales'][i]['quantity']}\n${list['sales'][i]['total_price']}", 2, 1);                                          
            // bluetooth.printLeftRight("LEFT", "RIGHT", 0);
            // bluetooth.printLeftRight("LEFT", "RIGHT", 1);
            // bluetooth.printNewLine();
            // bluetooth.printLeftRight("LEFT", "RIGHT", 2);
            // bluetooth.printLeftRight("LEFT", "RIGHT", 3);
            // bluetooth.printLeftRight("LEFT", "RIGHT", 4);
            // bluetooth.printCustom("Body left", 1, 0);
            // bluetooth.printCustom("Body right", 0, 2);
            // bluetooth.printNewLine();
            // bluetooth.printCustom("Thank You", 2, 1);
            // bluetooth.printNewLine();
            // bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
            // bluetooth.printNewLine();
            bluetooth.printNewLine();
            bluetooth.paperCut();
          }
        }
      }else{
        showCustomSnackBar(ctx, 'Bluetooth не подключен!', Colors.redAccent, Icons.info_outline);
      }
    });
  }
}