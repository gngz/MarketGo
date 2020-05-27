import 'package:flutter/material.dart';
import 'SocialButton.dart';

class FacebookButton extends StatefulWidget {
  final Function onPressed;
  FacebookButton({Key key, this.onPressed}) : super(key: key);

  @override
  _FacebookButtonState createState() => _FacebookButtonState();
}

class _FacebookButtonState extends State<FacebookButton> {
  static const BackgroundColor = Color(0xFF45639E);

  @override
  Widget build(BuildContext context) {
    return new SocialButton(
      text: "Login com Facebook",
      color: BackgroundColor,
      textColor: Colors.white,
      icon: Image(image: AssetImage("assets/facebook_logo.png"), height: 15.0),
      onPressed: this.widget.onPressed,
    );
  }
}
