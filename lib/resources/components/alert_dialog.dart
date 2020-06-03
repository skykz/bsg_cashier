
import 'package:flutter/material.dart';



class CustomActionDialog extends StatelessWidget {
  final String title;
  final Function onPressed;
  final String cancelOptionText;
  final String confirmOptionText;

  CustomActionDialog(
      {@required this.title,
      @required this.onPressed,
      @required this.cancelOptionText,
      @required this.confirmOptionText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(10)),
      ),
      title: Text(title,
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).textTheme.bodyText2.color),
          textAlign: TextAlign.center),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            splashColor: Colors.greenAccent,
            child: Text(
              cancelOptionText,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            splashColor: Colors.redAccent,
            child: Text(
              confirmOptionText,
              style: TextStyle(
                  fontSize: 19,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
            ),
            onPressed:onPressed,
          ),
        ],
      ),
    );
  }
}
