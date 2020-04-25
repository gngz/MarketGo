import 'package:flutter/material.dart';
import 'SocialButton.dart';

class GoogleButton extends StatefulWidget {
  final Function onPressed;
  GoogleButton({Key key, this.onPressed}) : super(key: key);

  @override
  _GoogleButtonState createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  SocialButton _socialButton = new SocialButton();

  @override
  Widget build(BuildContext context) {
    _socialButton.text = "Login com Google";
    _socialButton.color = Color(0xFFF8F7F7);
    _socialButton.textColor = Color(0xFF575657);
    _socialButton.icon =
        Image(image: AssetImage("assets/google_logo.png"), height: 15.0);
    _socialButton.onPressed = widget.onPressed;

    return _socialButton;
  }
}
