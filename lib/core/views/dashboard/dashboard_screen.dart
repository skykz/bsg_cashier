import 'dart:developer';



import 'package:bsg/core/models/base_provider.dart';
import 'package:bsg/core/models/cashier_dashboard.dart';
import 'package:bsg/core/views/dashboard/status_screen.dart';
import 'package:bsg/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:bsg/resources/components/key_button_item.dart';
import 'package:flutter/services.dart';

typedef ActionCallBack = void Function(Key key);
typedef KeyCallBack = void Function(Key key);



class DashBoardCashier extends StatefulWidget {
  final List<dynamic> object;  
  const DashBoardCashier({Key key,this.object}) : super(key: key);


  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<DashBoardCashier> {


  Key _sevenKey = Key('seven');
  Key _eightKey = Key('eight');
  Key _nineKey = Key('nine');
  Key _fourKey = Key('four');
  Key _fiveKey = Key('five');
  Key _sixKey = Key('six');
  Key _oneKey = Key('one');
  Key _twoKey = Key('two');
  Key _threeKey = Key('three');
  Key _zeroKey = Key('zero');
  Key _clearKey = Key('clear');
  Key _allClearKey = Key('allclear');

  double height;
  double width;
  List _currentValues = List();
  double lastValue;
  TextEditingController _textEditingController;
  bool savedLastValue = false;
 
  String dropdownValueOil;
  String dropdownType = "Тенге";
  List<String> valueOil = [];
  Map<int,dynamic> mapObject = {};


  void onKeyTapped(Key key) {

    if (savedLastValue == false && lastValue != null) {
      _currentValues.clear();
      savedLastValue = true;
    }
      
    setState(() {
      if (identical(_sevenKey, key)) {
        _currentValues.add('7');
        _textEditingController.text = convertToString(_currentValues);
      } else if(identical(_eightKey, key)) {
        _currentValues.add('8');
        _textEditingController.text = convertToString(_currentValues);
      } else if(identical(_nineKey, key)) {
        _currentValues.add('9');
        _textEditingController.text = convertToString(_currentValues);
      } else if(identical(_fourKey, key)) {
        _currentValues.add('4');
        _textEditingController.text = convertToString(_currentValues);
      } else if(identical(_fiveKey, key)) {
        _currentValues.add('5');
        _textEditingController.text = convertToString(_currentValues);
      } else if(identical(_sixKey, key)) {
        _currentValues.add('6');
        _textEditingController.text = convertToString(_currentValues);
      } else if(identical(_oneKey, key)) {
        _currentValues.add('1');
        _textEditingController.text = convertToString(_currentValues);
      } else if(identical(_twoKey, key)) {
        _currentValues.add('2');
        _textEditingController.text = convertToString(_currentValues);
      } else if(identical(_threeKey, key)) {
        _currentValues.add('3');
        _textEditingController.text = convertToString(_currentValues);      
      } else if(identical(_zeroKey, key)) {
        _currentValues.add('0');
        _textEditingController.text = convertToString(_currentValues);
      } else if(identical(_clearKey, key)) {
        if(_currentValues.length > 0)
        _currentValues.removeLast();
        _textEditingController.text = convertToString(_currentValues);
        log(" -------- ${ _textEditingController.text}");
      }else if(identical(_allClearKey, key)) {
        _currentValues.clear();
        lastValue = null;
        savedLastValue = false;
        _textEditingController.clear();
      } 
      
    });    
    // }else{
    //   if(identical(_clearKey, key)) {
    //     if(_currentValues.length > 0)
    //     _currentValues.removeLast();
    //     _textEditingController.text = convertToString(_currentValues);
    //     log(" -------- ${ _textEditingController.text}");
    //   }      
    // }

    // showCustomSnackBar(context, "Максимальная длина суммы 6 цифр", Colors.red, Icon(MyIcons.warning));
  }


  String convertToString(List values) {
    String val = '';
    print(_currentValues);
    for (int i = 0;i < values.length;i++) {
      val+=_currentValues[i];
    }
    return val;
  }


  void initState() { 
    super.initState();
    printWrapped("${widget.object}");
    for (var i = 0; i < widget.object.length; i++) {
      valueOil.add(widget.object[i]['name']);
      // mapObject.addAll({widget.object[i]['id']:widget.object[i]['name']});
    }    
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
   

    return BaseProvider<DashboardModel>(      
      model: DashboardModel(),
      builder: (context,model,child) =>  Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        centerTitle: true,
        backgroundColor: Colors.white,     
        iconTheme: IconThemeData(color:Colors.black),          
        title: Text("Панель кассира",style: TextStyle(color: Colors.black,fontSize: 20),),       
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[     
          SizedBox(
            width: MediaQuery.of(context).size.width,
                      child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                DropdownButton<String>(
                  dropdownColor: Colors.grey[100],
                  focusColor: Colors.green,                  
                  value: dropdownValueOil,
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 24,
                  elevation: 16,
                  hint: Text("Выберите бензин"),
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValueOil = newValue;
                    });
                  },
                  items: 
                      valueOil.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                          width: 140,
                          child: Padding(
                          padding: const EdgeInsets.only(left: 40,right: 10,bottom: 10),
                          child: Text(value,style: TextStyle(
                            fontSize: 15
                          ),),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: dropdownType,
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 24,
                  elevation: 16,                  
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownType = newValue;
                    });
                  },
                  items: <String>['Литр', 'Тенге']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40,right: 40,bottom: 10),
                        child: Text(value,style: TextStyle(
                          fontSize: 16
                        ),),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),     
          Container(
            alignment: Alignment.bottomRight,
            width: width,
            color: Colors.grey[100],
            height: (height/100)*10,
            child: IgnorePointer(
                child: TextField(  
                enabled: true,
                controller: _textEditingController,
                textAlign: TextAlign.right,
                inputFormatters: [
                      LengthLimitingTextInputFormatter(5),
                    ],
                showCursor: true,                                
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontSize: 40.0,
                ),                                            
                decoration: InputDecoration.collapsed(
                  hintText: '0',
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontSize: 40.0
                  )
                ),  
              ),
            ),
          ),                          
          Container(
                height: 270,
                padding: EdgeInsets.all(10.0),
                color: Colors.grey[100],
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                           buildKeyItem('7', _sevenKey),
                          buildKeyItem('8',_eightKey),
                          buildKeyItem('9',_nineKey),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          buildKeyItem('4',_fourKey),
                          buildKeyItem('5',_fiveKey),
                          buildKeyItem('6',_sixKey),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          buildKeyItem('1',_oneKey),
                          buildKeyItem('2',_twoKey),
                          buildKeyItem('3',_threeKey),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          KeyItem(
                            key: _allClearKey,
                            child: Text("C",style: TextStyle(
                              fontSize: 35,color:Colors.blue

                            ),),
                            onKeyTap: onKeyTapped,
                          ),
                          buildKeyItem('0',_zeroKey),
                          KeyItem(
                            key: _clearKey,
                            child: Icon(
                              Icons.backspace,
                              size: 30,
                              color: Colors.red,
                            ),
                            onKeyTap: onKeyTapped,
                          ),
                        ],
                      ),
                    ),                                       
                  ],
                ),
              ),   
              Builder(
                builder: (ctx) => FlatButton(                          
                  shape:  RoundedRectangleBorder(
                      borderRadius:  BorderRadius.circular(10.0)),
                  color: Colors.green[100],
                  splashColor: Colors.white,
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "Оплатить",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () => _calculateTotal(ctx,model)
                )),                                 
        ],
      ),
    ));

  }

  KeyItem buildKeyItem(String val, Key key) {
    return KeyItem(
      key: key,
      child: Text(
        val,
        style: TextStyle(
          color: Colors.black,          
          fontFamily: 'Avenir',
          fontStyle: FontStyle.normal,
          fontSize: 40.0,
        ),
      ),
      onKeyTap: onKeyTapped,
    );
  }

  _calculateTotal(BuildContext ctx,DashboardModel model){
    
    double oilPrice = 0.0;
    int fuelId = 0;    
    double quantity = 0.0;
    double total = 0.00;

    log("${_textEditingController.text.length}");
    double input = double.tryParse(_textEditingController.text);
    
    if(_textEditingController.text.length == 0 || _textEditingController.text == "0" || _textEditingController.text.isEmpty){
        showCustomSnackBar(ctx, 'Введите сумму или литр!', Colors.redAccent, Icons.info_outline);
      }
      else if(dropdownValueOil  == null){
        showCustomSnackBar(ctx, 'Выберите тип бензина!', Colors.redAccent, Icons.info_outline);
      }
      else{
                
          for (var i = 0; i < widget.object.length; i++) {
              if(dropdownValueOil == widget.object[i]['name']){
                setState(() {
                  oilPrice = widget.object[i]['price'];
                  fuelId = widget.object[i]['id'];
                });
              }
          }

          if(dropdownType == "Тенге"){
            quantity = input/oilPrice;  
            total = input;
          }else{
            // if values is Liter
            quantity = input;
            total = oilPrice*input;
          }

          log("- -  Total ---- ${double.parse(total.toStringAsFixed(2))}");
          log("- -  quantity  ---- ${quantity.toStringAsFixed(3).toString()}");
          log("- -  fuel ID ---- $fuelId");

           model.doPayment(fuelId, quantity.toStringAsFixed(3).toString(), double.tryParse(total.toStringAsFixed(2)) ,ctx).catchError((onError){
             log("$onError");
           }).then((value){
             if(value['sale'] != null)
              Navigator.push(context,MaterialPageRoute(builder: (context) => 
                  CashierSalesStatus(
                        id: value['sale']['id'],
              )));
           });       
      }
           
  }
 
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
