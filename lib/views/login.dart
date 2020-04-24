import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final logo = Image.asset("assets/logo.png");

  static const secondary = const Color(0xff0088B4);

  static final underlineTextField =
      UnderlineInputBorder(borderSide: BorderSide(color: secondary));

  // Email Field
  final emailField = TextField(
    obscureText: false,
    decoration: InputDecoration(labelText: "E-mail", focusColor: secondary),
  );

  // Password Field

  final passwordField = TextField(
    obscureText: true,
    decoration: InputDecoration(labelText: "Password"),
  );

  // Login Button

  final loginButton = FlatButton(
      color: secondary,
      child: Text("Login"),
      onPressed: () => {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)));

  // Register Button

  final registerButton = FlatButton(
    textColor: secondary,
    child: Text("Register"),
    onPressed: () => {},
  );

  // Google Button

  final googleButton = Container(
      //padding: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: -4.0,
            blurRadius: 4.0,
            offset: Offset(1.0, 4.0))
      ]),
      child: FlatButton(
        textColor: Color(0xFF575657),
        color: Color(0xFFF8F7F7),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Center(child: Text("Login com Google")),
            ),
          ],
        ),
        onPressed: () => {},
      ));

  final facebookButton = Container(
      //padding: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: -4.0,
            blurRadius: 4.0,
            offset: Offset(1.0, 4.0))
      ]),
      child: FlatButton(
        textColor: Colors.white,
        color: Color(0xFF45639E),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/facebook_logo.png"), height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Center(child: Text("Login com Facebook")),
            ),
          ],
        ),
        onPressed: () => {},
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/wave.png"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Center(child: logo),
                    SizedBox(height: 60.0),
                    emailField,
                    SizedBox(height: 20.0),
                    passwordField,
                    SizedBox(height: 8.0),
                    ButtonBar(
                      children: <Widget>[registerButton, loginButton],
                    ),
                    SizedBox(height: 8.0),
                    Column(
                      children: <Widget>[googleButton, facebookButton],
                    )
                  ],
                ),
                Container()
              ],
            ),
          ),
        ));
  }
}
