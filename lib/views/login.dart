import 'package:flutter/material.dart';
import 'package:marketgo/components/FacebookButton.dart';
import 'package:marketgo/components/GoogleButton.dart';
import '../services/Auth.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final logo = Image.asset("assets/logo.png");

  String email;
  String password;

  void authenticate() {
    //print("Email: $email ; Password: $password");
    Auth.authenticate(this.email, this.password);
  }

  static const secondary = const Color(0xff0088B4);

  // @Manel what is this?
  static final underlineTextField =
      UnderlineInputBorder(borderSide: BorderSide(color: secondary));

  // Email Field
  Widget emailField() {
    return TextField(
      obscureText: false,
      decoration: InputDecoration(labelText: "E-mail", focusColor: secondary),
      onChanged: (text) => this.email = text,
    );
  }
  // Password Field

  Widget passwordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(labelText: "Password"),
      onChanged: (text) => {this.password = text},
    );
  }

  // Login Button

  Widget loginButton() {
    return FlatButton(
        color: secondary,
        child: Text("Login"),
        onPressed: authenticate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)));
  }

  // Register Button

  final registerButton = FlatButton(
    textColor: secondary,
    child: Text("Register"),
    onPressed: () => {print("Hello hello")},
  );

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
                    emailField(),
                    SizedBox(height: 20.0),
                    passwordField(),
                    SizedBox(height: 8.0),
                    ButtonBar(
                      children: <Widget>[registerButton, loginButton()],
                    ),
                    SizedBox(height: 8.0),
                    Column(
                      children: <Widget>[
                        GoogleButton(onPressed: () => {}),
                        FacebookButton(onPressed: () => {}),
                      ],
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
