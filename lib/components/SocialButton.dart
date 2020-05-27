import 'package:flutter/material.dart';

class SocialButton extends StatefulWidget {
  final Function onPressed;
  final Image icon;
  final String text;
  final Color color;
  final Color textColor;

  SocialButton(
      {this.onPressed, this.icon, this.text, this.color, this.textColor});

  @override
  _SocialButtonState createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        //padding: EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: -4.0,
              blurRadius: 4.0,
              offset: Offset(1.0, 4.0))
        ]),
        child: FlatButton(
          textColor: widget.textColor,
          color: widget.color,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.icon,
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Center(child: Text(widget.text)),
              ),
            ],
          ),
          onPressed: widget.onPressed,
        ));
  }
}
