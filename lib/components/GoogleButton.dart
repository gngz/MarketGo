import 'package:flutter/material.dart';
import 'SocialButton.dart';

class GoogleButton extends StatefulWidget {
  final Function onPressed;
  GoogleButton({Key key, this.onPressed}) : super(key: key);

  @override
  _GoogleButtonState createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  static const _BackgroundColor = Color(0xFFF8F7F7);
  static const _TextColor = Color(0xFF575657);

  @override
  Widget build(BuildContext context) {
    return new SocialButton(
      text: "Login com Google",
      color: _BackgroundColor,
      textColor: _TextColor,
      icon: Image(image: AssetImage("assets/google_logo.png"), height: 15.0),
      onPressed: widget.onPressed,
    );
  }
}
