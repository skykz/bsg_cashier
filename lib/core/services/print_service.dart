import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bsg/core/models/printer_model.dart';
import 'package:flutter/services.dart';



class TestPrint {
  final String reportTitle;
  final String dateStart;
  final String dateEnd;
  final String company;
  final int id;
  final String cashier;
  final List<dynamic> list;
  final PrinterModel printerModel;

  TestPrint({String reportTitle,String dateStart, String dateEnd, String company,
      PrinterModel printerModel,
      int id, String cashier,List<dynamic> list}):
        reportTitle = reportTitle,
      dateStart = dateStart,dateEnd = dateEnd,company = company,
      id = id, cashier = cashier,list = list, printerModel = printerModel;

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  BluetoothDevice _bluetoothDevice;
  String pathImage;
  TestPrint testPrint;

  Future<void> initPlatformState() async {
  bool isConnected = await bluetooth.isConnected;    
  List<BluetoothDevice> devices = [];
  
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // showCustomSnackBar(context, "Ошибка при подключения", Colors.redAccent, Icons.info_outline);
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          printerModel.setConnectionState(true);         
          break;
        case BlueThermalPrinter.DISCONNECTED:
          printerModel.setConnectionState(true);         
          // show( "Bluetooth не подключился!");        
          break;
        default:
          print(state);
          break;
      }
    });
    printerModel.setDevicesList(devices);
    // if (!mounted) return;
    // setState(() {
    //   _devices = devices;
    // });

    if(isConnected) {
      printerModel.setGlobalConnectionState(true);     
    }
  }


  void _connect() {
    if (_bluetoothDevice == null) {
      //  show("Bluetooth девайс не подключен!");
    } else {
      bluetooth.isConnected.then((val) {
        if (!val) {
          bluetooth.connect(_bluetoothDevice).catchError((error) {
            // setState(() => _connected = false);
            printerModel.setGlobalConnectionState(false);
          });
          // setState(() => _connected = true);
          printerModel.setGlobalConnectionState(true);
        }
      });
    }
  }

  sample(String pathImage) async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printNewLine();
        bluetooth.printCustom("HEADER", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printImage(pathImage); //path of your image/logo
        bluetooth.printNewLine();
        bluetooth.printLeftRight("LEFT", "RIGHT", 0);
        bluetooth.printLeftRight("LEFT", "RIGHT", 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("LEFT", "RIGHT", 2);
        bluetooth.printLeftRight("LEFT", "RIGHT", 3);
        bluetooth.printLeftRight("LEFT", "RIGHT", 4);
        bluetooth.printCustom("Body left", 1, 0);
        bluetooth.printCustom("Body right", 0, 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("Thank You", 2, 1);
        bluetooth.printNewLine();
        bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }
}
