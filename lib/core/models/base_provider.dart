
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class BaseProvider<T extends ChangeNotifier> extends StatefulWidget{
  final Widget Function(BuildContext context,T model,Widget child) builder;
  final Widget child;
  final T model;
  final Function(T) onReady;

      BaseProvider({Key key,this.builder,this.model,this.child,this.onReady}) : super(key:key);
      _BaseProviderState<T> createState() => _BaseProviderState<T>();
}

class _BaseProviderState<T extends ChangeNotifier> extends State<BaseProvider<T>>{
  T model;

  @override
  void initState() {
    model = widget.model;
    if(widget.onReady != null)
    widget.onReady(model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (context) => model,
        child: Consumer<T>(
          builder: widget.builder,
          child: widget.child,
        ),
    );
  }

}