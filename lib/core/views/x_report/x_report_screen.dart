import 'dart:developer';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bsg/core/models/base_provider.dart';
import 'package:bsg/core/models/x_report_model.dart';
import 'package:bsg/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class XReportScreen extends StatefulWidget{  
  final String cashier;
  XReportScreen({this.cashier});

  @override
  _XReportScreenState createState() => _XReportScreenState();
}

class _XReportScreenState extends State<XReportScreen> {
    //Bluetooth part
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice _bluetoothDevice;
  bool _connected = false;
  String pathImage;

  @override
  void initState() {    
    
    initPlatformState();
   

    super.initState();   
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
      log('No device selected.');
    } else {
      bluetooth.isConnected.then((val) {
        if (!val) {
          bluetooth.connect(_bluetoothDevice).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        log( '+++++++++ device selected.');

        }
      });
    }
  }


  final double iconSize = 40; 
  dynamic list;

  @override
  Widget build(BuildContext context) {
    return BaseProvider<XReportModel>(      
      model: XReportModel(),
      builder: (context,model,child) => Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Text('X - отчет',style: TextStyle(
              color: Colors.black 
            ),),
            iconTheme: IconThemeData(
              color: Colors.black
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            actions: <Widget>[
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
            ],
          ),
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
                      child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[                   
                       Container(                       
                      color: Colors.grey[200],                                                                                            
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,                              
                          children: <Widget>[
                            Flexible(
                              flex: 2,
                              child: Text("ID",style: TextStyle(fontWeight: FontWeight.bold),)),
                            Flexible(
                              flex: 2,
                              child: Text("Дата",style: TextStyle(fontWeight: FontWeight.bold),)),
                            Flexible(
                              flex: 2,
                              child: Text("Топливо",style: TextStyle(fontWeight: FontWeight.bold),)),
                            Flexible(
                              flex: 2,
                              child: Text("₸/л",style: TextStyle(fontWeight: FontWeight.bold),))
                          ],
                          ),
                        ),
                      ),
                      StreamBuilder(
                              stream: model.getXReportList(context).asStream(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) { 

                                if(snapshot.data == null)
                                return  Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: <Widget>[
                                        CircularProgressIndicator(
                                                  backgroundColor: Colors.orange,
                                                  strokeWidth: 3,                                 
                                        ),
                                        SizedBox(height: 10,),
                                        Text("Загрузка...")
                                      ],
                                    ),
                                  ),
                                );
                            list = snapshot.data;
                            return SizedBox(
                              height: MediaQuery.of(context).size.height*0.7,
                              child: ListView.builder(
                                itemCount: snapshot.data['sales'].length,
                                addAutomaticKeepAlives: true,
                                itemExtent: 80,
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, i) =>  
                                    Container(
                                      color: snapshot.data['sales'][i]['status'] == 'refund'?Colors.red[100]:Colors.green[100],
                                      child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,                              
                                            children: <Widget>[
                                              SizedBox(
                                                width: 15,
                                                child: Icon(snapshot.data['sales'][i]['status'] == 'refund'?Icons.remove_circle_outline:Icons.check_circle_outline,color: snapshot.data['sales'][i]['status'] == 'refund'?Colors.red:Colors.green)),
                                              Flexible(
                                                flex: 2,
                                                child: Text("${snapshot.data['sales'][i]['id']}",style: TextStyle(fontWeight: FontWeight.bold),)),
                                              Flexible(
                                                flex: 2,
                                                child: Text("${DateTime.parse(snapshot.data['sales'][i]['datetime']).toLocal()}",style: TextStyle(fontWeight: FontWeight.bold),)),
                                              Flexible(
                                                flex: 2,
                                                child: Text("${snapshot.data['sales'][i]['fuel']}\n ${snapshot.data['sales'][i]['price']}  ₸/л.",style: TextStyle(fontWeight: FontWeight.bold),)),
                                              Flexible(
                                                flex: 2,
                                                child: Text("${snapshot.data['sales'][i]['status'] == 'refund'?'- ':''}${snapshot.data['sales'][i]['total_price']}\n "+
                                                "${snapshot.data['sales'][i]['status'] == 'refund'?'-':''} ${snapshot.data['sales'][i]['quantity']}",style: TextStyle(fontWeight: FontWeight.bold),))
                                            ],
                                          ),
                                ),
                                    ),                              
                              ),
                            );  
                        }),     
                         Center(
                           child: Builder(
                              builder: (ctx) => FlatButton(                          
                                shape:  RoundedRectangleBorder(
                                    borderRadius:  BorderRadius.circular(10.0)),
                                color: Colors.orange[100],
                                splashColor: Colors.white,
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Icon(Icons.print,color: Colors.orange),
                                      Text(
                                        "Распечатать",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed:() => _testPrint(ctx,list)
                              )),
                         ),                    
                    ],
            ),
          )
          
          ));
  }
  void _testPrint(BuildContext ctx,dynamic list) async {
  
    bluetooth.isConnected.then((isConnected) {

      if (isConnected) {
        log("------------------------------- printing");
        
        if(list['sales'].length > 0){
            //showCustomSnackBar(ctx, '${list['sales']['i']}', Colors.redAccent, Icons.info_outline);
            bluetooth.printNewLine();
            bluetooth.printCustom("X-otchet", 4, 1);      
            bluetooth.printCustom("-------------------", 1, 1);
            // bluetooth.printCustom(" Data | Toplivo KZT/L | KZT/L", 1, 1);
            bluetooth.printNewLine();

          for (var i = 0; i < list['sales'].length; i++) {      
            bluetooth.printCustom("${widget.cashier}", 1, 0);          
            bluetooth.printCustom(
            "Data:  ${list['sales'][i]['datetime']} \n"+
            "Time:  14:18:37 \n"+
            "GAS:  ${list['sales'][i]['fuel']}\n"+
            "Litters:  ${list['sales'][i]['quantity']} L\n"+
            "Price:   ${list['sales'][i]['price']} KZT/L\n "+
            "Sum:  ${list['sales'][i]['total_price']} KZT \n", 1, 1);                                          
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
            bluetooth.printCustom("-------------------", 1, 1);
            bluetooth.printNewLine();
            bluetooth.printNewLine();
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