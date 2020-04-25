import 'package:flutter/material.dart';
import 'SocialButton.dart';

class FacebookButton extends StatefulWidget {
  final Function onPressed;
  FacebookButton({Key key, this.onPressed}) : super(key: key);

  @override
  _FacebookButtonState createState() => _FacebookButtonState();
}

class _FacebookButtonState extends State<FacebookButton> {
  SocialButton _socialButton = new SocialButton();

  @override
  Widget build(BuildContext context) {
    _socialButton.text = "Login com Facebook";
    _socialButton.color = Color(0xFF45639E);
    _socialButton.textColor = Colors.white;
    _socialButton.icon =
        Image(image: AssetImage("assets/facebook_logo.png"), height: 15.0);
    _socialButton.onPressed = widget.onPressed;

    return _socialButton;
  }
}
