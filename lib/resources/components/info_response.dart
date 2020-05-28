
import 'package:flutter/material.dart';



class InfoAlertDialog extends StatelessWidget {
  final String title;  


  InfoAlertDialog(
      {@required this.title,      
      t});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(10)),
      ),
      title: Text(title,
          style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyText2.color),
          textAlign: TextAlign.center),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[        
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            splashColor: Colors.purpleAccent,
            child: Text(
              "ОК",
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.pop(context,false),
          ),
        ],
      ),
    );
  }
}
