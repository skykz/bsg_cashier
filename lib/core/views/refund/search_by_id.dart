import 'dart:async';
import 'dart:developer';

import 'package:bsg/api/repository/repositories_api.dart';
import 'package:bsg/core/models/base_provider.dart';
import 'package:bsg/core/models/refund_model.dart';
import 'package:bsg/core/views/refund/report_detail.dart';
import 'package:bsg/utils/common_utils.dart';
import 'package:flutter/material.dart';

class SearchByIdRefund extends StatefulWidget{

  @override
  _SearchByIdRefundState createState() => _SearchByIdRefundState();
}

class _SearchByIdRefundState extends State<SearchByIdRefund> {
  final TextEditingController _idController = TextEditingController();

  final double iconSize = 40; 
  Map<String,dynamic> listSales = Map();
  bool isLoading = false;
  
  BsgAPI _api = BsgAPI();
  // Stream<dynamic> getList;

  Future getLastSalesGet(BuildContext context) async {
    return await _api.doCashierSalesGet(context);
  }

  Future getPage(String url,BuildContext context) async {
    return await _api.getNextOrPrevPage(url,context);
  }


  @override
  void initState() {    
    getLastSalesGet(context).then((value){
      if(value != null)
      setState(() {
        listSales = value;
      });
      // log("$listSales");
    });
    // getList = getLastSalesGet(context).asStream().asBroadcastStream();   
    super.initState();
    //  WidgetsBinding.instance.addPostFrameCallback((_){
    //   Provider.of<RefundModel>(context, listen: false)
    //   .getLastSalesGet(context);  

  }

  @override
  Widget build(BuildContext context) {
  log("${listSales.length}");
    return BaseProvider<RefundModel>(            
      model: RefundModel(),
      builder: (context,model,child) =>  Scaffold(                              
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 2,
            title: Text('Возврат: транзакции за смену',style: TextStyle(
              color: Colors.black,
              fontSize: 15
            ),),
            iconTheme: IconThemeData(
              color: Colors.black
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
                      child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:15.0,bottom:20),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                      Flexible(
                        flex: 2,
                          child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(                    
                              padding: EdgeInsets.only(left: 5.0),
                              decoration: BoxDecoration(
                                  color:Color.fromRGBO(235, 235, 240, 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: TextField(
                                cursorColor: Colors.deepPurple,
                                cursorRadius: Radius.circular(10.0),
                                cursorWidth: 3.0,
                                keyboardType: TextInputType.phone,
                                controller: _idController,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontSize: 17, color: Colors.grey),
                                  hintText: 'Поиск по ID',
                                  border: InputBorder.none,
                                  prefixIcon: GestureDetector(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width:0,
                                      child: Icon(Icons.search)                  
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width:0,
                                      child: Icon(Icons.cancel,color: Colors.grey,)                  
                                    ),
                                    onTap: () => _removeText(model)
                                  )
                                ),
                                style: TextStyle(fontSize: 18),
                            )),              
                        ),
                      ),
                      SizedBox(width: 10,),
                      Flexible(
                        child: Builder(
                            builder:(ctx) => FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:  BorderRadius.circular(10.0)),
                            color: Colors.lightBlue[100],
                            splashColor: Colors.blue[300],                        
                            child: Padding(
                              padding: const EdgeInsets.only(top:13.0,bottom: 13,left: 10,right: 10),
                              child: model.getSearchingState? 
                              SizedBox(
                                height: 20,
                                width: 20,
                                 child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ): Text(
                                "Найти",
                                style: TextStyle(
                                    fontSize:17,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () => _searchSalesById(ctx,model)
                                  ),
                        ))
                      ],
                    ),
                ),                                                            
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
                      model.getObject != null?
                        InkWell(
                                splashColor: Colors.lightBlue[100],
                                onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => ReportDetailScreen(
                                  object: model.getObject['transaction_id'],
                                ))),
                                  child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,                              
                                    children: <Widget>[
                                      Flexible(
                                        flex: 2,
                                        child: Text("${model.getObject['transaction_id']}",style: TextStyle(fontWeight: FontWeight.bold),)),
                                      Flexible(
                                        flex: 2,
                                        child: Text("${DateTime.parse(model.getObject['datetime']).toLocal()}",style: TextStyle(fontWeight: FontWeight.bold),)),
                                      Flexible(
                                        flex: 2,
                                        child: Text("${model.getObject['fuel']}\n ${model.getObject['price']}  ₸/л.",style: TextStyle(fontWeight: FontWeight.bold),)),
                                      Flexible(
                                        flex: 2,
                                        child: Text("${model.getObject['total_price']}\n ${model.getObject['quantity']}",style: TextStyle(fontWeight: FontWeight.bold),))
                                    ],
                                  ),
                          ),
                        ):                                                           
                        listSales.isEmpty?
                        Padding(
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
                          ):
                        SizedBox(
                              height: MediaQuery.of(context).size.height*0.6,
                              child: ListView.builder(
                                itemCount: listSales['data'].length,
                                addAutomaticKeepAlives: true,
                                itemExtent: 60,
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, i) =>  InkWell(
                                      splashColor: Colors.lightBlue[100],
                                      onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => ReportDetailScreen(
                                        object: listSales['data'][i],
                                      ))),
                                        child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,                              
                                          children: <Widget>[
                                            Flexible(
                                              flex: 2,
                                              child: Text("${listSales['data'][i]['id']}",style: TextStyle(fontWeight: FontWeight.bold),)),
                                            Flexible(
                                              flex: 2,
                                              child: Text("${DateTime.parse(listSales['data'][i]['updated_at']).toLocal()}",style: TextStyle(fontWeight: FontWeight.bold),)),
                                            Flexible(
                                              flex: 2,
                                              child: Text("${listSales['data'][i]['fuel']['name']}\n ${listSales['data'][i]['price']}  ₸/л.",style: TextStyle(fontWeight: FontWeight.bold),)),
                                            Flexible(
                                              flex: 2,
                                              child: Text("${listSales['data'][i]['total_price']}\n ${listSales['data'][i]['quantity']}",style: TextStyle(fontWeight: FontWeight.bold),))
                                          ],
                                        ),
                                ),
                              ),
                              ),
                            ),                        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Builder(
                              builder: (ctx) =>FlatButton(
                          child: Icon(Icons.chevron_left,
                            color: Colors.grey,size: 60,), 
                          onPressed: (){
                            if(listSales['prev_page_url'] != null){
                            setState(() {
                              isLoading = true;
                            });
                            getPage(listSales['prev_page_url'], context).then((value) {
                                if(value != null)
                                setState(() {
                                  listSales = Map();
                                  listSales.addAll(value);    
                                  isLoading = false;                              
                                });
                            });
                            }else{
                              showCustomSnackBar(ctx, "Больше нету страниц", Colors.orange, Icons.info_outline);
                            }
                          })),
                        isLoading?SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Colors.purpleAccent,
                          ),
                        ): Text("${listSales['current_page']} / ${listSales['last_page']}"),
                        Builder(
                              builder: (ctx) => FlatButton(
                            child: Icon(Icons.chevron_right,
                            color: Colors.grey,size: 60,), 
                            onPressed: (){
                               if(listSales['next_page_url'] != null){
                                  setState(() {
                                  isLoading = true;
                                    });
                                getPage(listSales['next_page_url'], context).then((value) {
                                    if(value != null)
                                    setState(() {
                                      listSales = Map();
                                      listSales.addAll(value);
                                      isLoading = false;
                                    });
                                });
                              }else{
                                 showCustomSnackBar(ctx, "Больше нету страниц", Colors.orange, Icons.info_outline);
                               }
                            }),
                        )  
                      ],
                    )                                                   
                ]),
            ),                                   
          ));
  }

  _searchSalesById(BuildContext ctx,RefundModel model){

    if(_idController.text.length == 0){
      showCustomSnackBar(ctx, 'Введите ID транзакций', Colors.redAccent, Icons.info_outline);
    }else{
      model.setSearchingState(true);
      model.getSearchedSalesById(int.tryParse(_idController.text),ctx).whenComplete(() => {
      model.setSearchingState(false)
      });
    }

  }

  _removeText(RefundModel model){
      if(_idController.text.length != 0){
        _idController.clear();
        model.setFetchedObject(null);
      }
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}