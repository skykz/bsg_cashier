import 'package:flutter/material.dart';


class PrimaryButton extends StatefulWidget {
  final bool isOrderCreating;
  final String buttonText;
  final Function onPressed;
  final Color textColor;
  final Color color;
  final double height;
  final double width;

  PrimaryButton(
      {
      this.isOrderCreating,
      @required this.buttonText,
      this.textColor,
      @required this.onPressed,
      this.color,
      this.height,
      this.width});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with TickerProviderStateMixin<PrimaryButton> {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = 8.0;
    _scale = 1 - _controller.value;

    return GestureDetector(
        onTap: () {
              _controller.forward().then((val) {
                _controller.reverse().then((val) {
                 widget.onPressed();
                });
              });
            },
        child: Transform.scale(
            scale: _scale,
            child: Container(
              height: widget.height == null
                  ? 27
                  : widget.height,
              width: widget.width == null
                  ? 180
                  : widget.width,
              decoration: BoxDecoration(
                color: widget.color,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5.0,
                    color: Colors.grey.withOpacity(.4),
                    offset: Offset(1.0, 1.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(borderRadius),             
              ),
              child: FlatButton(
                color: Colors.transparent,
                child: widget.isOrderCreating?CircularProgressIndicator(
                  strokeWidth: 3,
                  backgroundColor: Colors.orangeAccent,
                ):Text(
                  widget.buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: widget.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                ),
                onPressed: null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius)),
              ),
            )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
