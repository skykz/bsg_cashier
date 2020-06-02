import 'dart:developer';


import 'package:bsg/core/models/base_provider.dart';
import 'package:bsg/core/models/refund_model.dart';
import 'package:bsg/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:bsg/resources/components/key_button_item.dart';
import 'package:flutter/services.dart';

typedef ActionCallBack = void Function(Key key);
typedef KeyCallBack = void Function(Key key);



class RefundScreen extends StatefulWidget {
  final dynamic object;
  RefundScreen({this.object});

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<RefundScreen> {


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
  Key _dotKey = Key('dot');

  double height;
  double width;
  List _currentValues = List();
  double lastValue;
  TextEditingController _textEditingController;
  bool savedLastValue = false;
 
  String dropdownValueOil;
  String dropdownType;


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
      }else if(identical(_dotKey, key)) {
        // _currentValues.clear();
        if(_currentValues.length > 0){
          _currentValues.add('.');
          _textEditingController.text = convertToString(_currentValues);
        }
        // lastValue = null;
        // savedLastValue = false;
        // _textEditingController.clear();
      } 
      
    });       
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
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    
    return BaseProvider<RefundModel>(      
      model: RefundModel(),
      builder: (context,model,child) => Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color:Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,               
        title: Text("Возврат",style: TextStyle(color: Colors.black,fontSize: 20),),     
      ),
      body: IgnorePointer(
          ignoring: model.isLoading,
              child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[    
            Table(            
              border: TableBorder.all(),
              columnWidths: 
              { 
                0: FractionColumnWidth(.2), 
                1: FractionColumnWidth(.3), 
                2: FractionColumnWidth(.3),
                3: FractionColumnWidth(.4)
              },
              children: [
                TableRow( 
                  children: [                                       
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('ID',style: TextStyle(fontWeight: FontWeight.bold),),
                      ),                                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Дата',style: TextStyle(fontWeight: FontWeight.bold),),
                      ),                                       
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Топливо',style: TextStyle(fontWeight: FontWeight.bold),),
                      ),      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('₸/л.',style: TextStyle(fontWeight: FontWeight.bold),),
                      ),             
                ]),
                TableRow(                     
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${widget.object['transaction_id']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("${DateTime.parse(widget.object['datetime']).toLocal()}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                        fontSize: 15
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("${widget.object['fuel']} / ${widget.object['price']} ₸/л.",textAlign: TextAlign.start,
                        style: TextStyle(
                        fontSize: 16
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("${widget.object['total_price']}\n ${widget.object['quantity']}",textAlign: TextAlign.start,
                        style: TextStyle(
                        fontSize: 15
                      ),),
                    ),                 
                ]),
              ],
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
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: "Введите сумму или литр",
                    labelStyle: TextStyle(
                      fontSize: 17
                    ),
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
                              key: _dotKey,
                              child: Text(".",style: TextStyle(
                                fontSize: 40,color:Colors.black

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                      child: model.isLoading?SizedBox(
                                  height: 30,
                                  width: 30,
                                   child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                      : Text(
                        "Вернуть",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () => _doRefund(ctx,model)
                  )),                                   
          ],
        ),
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

  _doRefund(BuildContext ctx,RefundModel model){

      log("${_textEditingController.text}");
      if(_textEditingController.text.length == 0 || _textEditingController.text == "0" || _textEditingController.text.isEmpty){
        showCustomSnackBar(ctx, 'Введите сумму!', Colors.redAccent, Icons.info_outline);
      }else{            
        model.doRefundUser(widget.object['transaction_id'], context).then((value){  
          if(value != null)  
            if(value['message'] == 'Возврат выполнен.')
              showCustomSnackBar(ctx, "${value['message']}", Colors.green, Icons.check_circle_outline);

        }).catchError((error){
          showCustomSnackBar(ctx, "Ошибка: $error", Colors.redAccent, Icons.info_outline);
        });
      }
  }

 @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
