
import 'package:flutter/material.dart';

class KeyItem extends StatelessWidget {

  final Widget child;
  final Key key;
  final Function onKeyTap;

  KeyItem({@required this.child,this.key,this.onKeyTap});

  @override
  Widget build(BuildContext context) {
    // assert(debugCheckHasMaterial(context));
    return Expanded(
        child: Material(          
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.grey,
              highlightColor: Colors.blueGrey,
              onTap: () => onKeyTap(key),
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: child,
          ),
        ),
      ),
    );
  }
}
