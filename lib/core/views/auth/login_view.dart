import 'dart:developer';

import 'package:bsg/app.dart';
import 'package:bsg/core/models/base_provider.dart';
import 'package:bsg/core/models/imei_data.dart';
import 'package:bsg/core/models/login_model.dart';
import 'package:bsg/resources/components/primary_button.dart';
import 'package:bsg/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class LoginScreen extends StatefulWidget{

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {  

  TextEditingController _passwordValue = TextEditingController();

  MaskTextInputFormatter _phoneValueController = MaskTextInputFormatter(
      mask: 'e ##############',
      filter: {"#": RegExp(r'[0-9]')});

  @override
  void dispose() {    
    _passwordValue.dispose();
    _phoneValueController = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return BaseProvider<LoginModel>(
      model: LoginModel(),
      builder: (context,model,child) => SafeArea(
          child: Scaffold(
            body: ListView(        
              children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,          
                  children: <Widget>[
                    _buildLogo(),
                    _buildLoginField(context,model)
                  ],
              ),
              ]
            )
      ),
    ));
  }

  Widget _buildLogo(){
    return Padding(
       padding: const EdgeInsets.all(45),
       child: Image.asset("assets/images/logo.png",width: 200),       
    );
  }

  Widget _buildLoginField(BuildContext context,LoginModel model){

    final imei = Provider.of<ImeiString>(context).value;
    
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: <Widget>[
           Padding(
            padding: const EdgeInsets.only(left:20,right: 20,bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Авторизация",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25
                    ),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Кассира",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey
                    ),),
                ),
              ],
            ),
            ),
          Container(
            padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
                color:Color.fromRGBO(235, 235, 240, 1),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: TextField(
              cursorColor: Colors.deepPurple,
              cursorRadius: Radius.circular(10.0),
              cursorWidth: 3.0,              
              keyboardType: TextInputType.text,
              inputFormatters:[_phoneValueController],
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    fontSize: 20, color: Colors.grey),
                hintText: 'Логин',                
                border: InputBorder.none,
                prefixIcon: SizedBox(
                  width: 0,
                   child: Align(                    
                      alignment: Alignment.centerLeft,
                      child: const Icon(Icons.account_circle)                  
                    ),
                ),                
              ),
              style: TextStyle(fontSize: 18),
          )),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
                color:Color.fromRGBO(235, 235, 240, 1),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: TextField(
              cursorColor: Colors.deepPurple,
              cursorRadius: Radius.circular(10.0),
              cursorWidth: 3.0,
              obscureText: model.passwordState,
              keyboardType: TextInputType.text,
              controller: _passwordValue,
              decoration: InputDecoration(                
                suffixIcon: IconButton(
                  icon: Icon( model.passwordState?Icons.visibility_off:Icons.visibility),
                   onPressed: () => model.showPassword(model.passwordState)),
                hintStyle: const TextStyle(
                    fontSize: 20, color: Colors.grey),
                hintText: 'Пароль',
                border: InputBorder.none,
                prefixIcon:  SizedBox(
                  width: 0,
                   child: Align(   
                    alignment:Alignment.centerLeft,                    
                    child: const Icon(Icons.lock)
                   ))                                                  
              ),
              style: const TextStyle(fontSize: 18),
          )),
          const SizedBox(
            height: 35,
          ),
          Builder(
              builder:(ctx) => PrimaryButton(
              buttonText: "Войти", 
              height: 50,
              color: Colors.deepPurpleAccent,
              textColor: Colors.white,
              width: 250,            
              isOrderCreating: model.isLoading,
              onPressed: () => _doAuth(ctx,model)),
          ),
          Text('IMEI: $imei',style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),), 
        ],
      ),);
  }

  _doAuth(BuildContext ctx,LoginModel model){
    
    
    log("${_passwordValue.text}");

    if(_phoneValueController.getUnmaskedText().isEmpty || _passwordValue.text.isEmpty)
    {   
       showCustomSnackBar(ctx, 'Заполните все поля', Colors.redAccent,
       Icons.info_outline);
    }else{
      log("${_phoneValueController.getUnmaskedText()}");

      model.setLoading(true);
      model.doAuth("e"+_phoneValueController.getUnmaskedText().trim(), _passwordValue.text.trim(),ctx).then((value) => {
        model.setLoading(false),
        log("$value"),
        if(value != null){
          // showCustomSnackBar(ctx, value, Colors.green, Icons.done),
          Navigator.pushReplacement(
            ctx, MaterialPageRoute(builder: (context) => MyApp()))
        }
      });           
    }
  }
} 