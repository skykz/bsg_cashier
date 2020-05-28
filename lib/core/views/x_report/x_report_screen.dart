import 'package:bsg/core/models/base_provider.dart';
import 'package:bsg/core/models/x_report_model.dart';
import 'package:flutter/material.dart';

class XReportScreen extends StatelessWidget{
  
  final double iconSize = 40; 
  List<TableRow> list = 
      [            
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
        ])
          ];

  @override
  Widget build(BuildContext context) {
    return BaseProvider<XReportModel>(      
      model: XReportModel(),
      builder: (context,model,child) => Scaffold(
          appBar: AppBar(
            title: Text('X - отчет',style: TextStyle(
              color: Colors.black 
            ),),
            iconTheme: IconThemeData(
              color: Colors.black
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
                      child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                      //       Center(
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: <Widget>[ 
                      //             Container(
                      //                   height: MediaQuery.of(context).size.height * 0.75,
                      //                   margin: EdgeInsets.all(10),                      
                      //                   child:  Table(
                      //                       border: TableBorder.all(),
                      //                       columnWidths: 
                      //                       { 
                      //                         0: FractionColumnWidth(.2), 
                      //                         1: FractionColumnWidth(.3), 
                      //                         2: FractionColumnWidth(.3),
                      //                         3: FractionColumnWidth(.4)
                      //                       },
                      //                 children: [
                      //                   TableRow( 
                      //                     children: [                                       
                      //                         Padding(
                      //                           padding: const EdgeInsets.all(8.0),
                      //                           child: Text('ID',style: TextStyle(fontWeight: FontWeight.bold),),
                      //                         ),                                      
                      //                         Padding(
                      //                           padding: const EdgeInsets.all(8.0),
                      //                           child: Text('Дата',style: TextStyle(fontWeight: FontWeight.bold),),
                      //                         ),                                       
                      //                         Padding(
                      //                           padding: const EdgeInsets.all(8.0),
                      //                           child: Text('Топливо',style: TextStyle(fontWeight: FontWeight.bold),),
                      //                         ),      
                      //                         Padding(
                      //                           padding: const EdgeInsets.all(8.0),
                      //                           child: Text('₸/л.',style: TextStyle(fontWeight: FontWeight.bold),),
                      //                         ),             
                      //                   ]),                                          
                                        
                      //             ],
                      //           ),
                      //         ),     
                                          
                      //       ],
                      //     )
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[   
                      //     //  FlatButton(
                      //     //     color: Colors.grey[200],
                      //     //     shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                      //     //     child: Icon(Icons.chevron_left,size: 50,color:Colors.grey),
                      //     // onPressed: (){}),                                                           
                      //     //   FlatButton(
                      //     //   color: Colors.grey[200],
                      //     //   shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                      //     //   child: Icon(Icons.chevron_right,size: 50,color:Colors.grey),
                      //     //   onPressed: (){}),     
                      //   ]),
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

                            return SizedBox(
                              height: MediaQuery.of(context).size.height*0.7,
                              child: ListView.builder(
                                itemCount: snapshot.data['sales'].length,
                                addAutomaticKeepAlives: true,
                                itemExtent: 65,
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, i) =>  InkWell(
                                      splashColor: Colors.lightBlue[100],
                                      onTap: () =>{},
                                        child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,                              
                                          children: <Widget>[
                                            Flexible(
                                              flex: 2,
                                              child: Text("${snapshot.data['sales'][i]['id']}",style: TextStyle(fontWeight: FontWeight.bold),)),
                                            Flexible(
                                              flex: 2,
                                              child: Text("${DateTime.parse(snapshot.data['sales'][i]['datetime']).toLocal()}",style: TextStyle(fontWeight: FontWeight.bold),)),
                                            Flexible(
                                              flex: 2,
                                              child: Text("${snapshot.data['sales'][i]['fuel']}\n ₸/л. ${snapshot.data['sales'][i]['price']}",style: TextStyle(fontWeight: FontWeight.bold),)),
                                            Flexible(
                                              flex: 2,
                                              child: Text("${snapshot.data['sales'][i]['total_price']}\n ${snapshot.data['sales'][i]['quantity']}",style: TextStyle(fontWeight: FontWeight.bold),))
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
                                onPressed: () => {}
                              )),
                         ),                    
                    ],
            ),
          )
          
          ));
  }

}