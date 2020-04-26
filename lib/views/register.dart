import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final logo = Image.asset("assets/logo.png");
  static const secondary = const Color(0xff0088B4);

  Widget _firstNameField() {
    return TextFormField(
      obscureText: false,
      decoration: InputDecoration(labelText: "Primeiro Nome"),
    );
  }

  Widget _lastNameField() {
    return TextFormField(
      obscureText: false,
      decoration: InputDecoration(labelText: "Último Nome"),
    );
  }

  Widget _emailField() {
    return TextFormField(
      obscureText: false,
      decoration: InputDecoration(labelText: "E-mail"),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: "Password"),
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: "Confirmar Password"),
    );
  }

  Widget _registerButton() {
    return FlatButton(
        color: secondary,
        child: Text("Registar"),
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)));
  }

  Widget _goBackButton() {
    return FlatButton(
      textColor: secondary,
      child: Text("Voltar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 100.0),
              Hero(tag: "logo", child: Center(child: logo)),
              SizedBox(height: 50.0),
              Form(
                  child: Column(
                children: <Widget>[
                  _firstNameField(),
                  SizedBox(height: 8.0),
                  _lastNameField(),
                  SizedBox(height: 8.0),
                  _emailField(),
                  SizedBox(height: 8.0),
                  _passwordField(),
                  SizedBox(height: 8.0),
                  _confirmPasswordField(),
                  SizedBox(height: 8.0),
                  ButtonBar(
                    children: <Widget>[_goBackButton(), _registerButton()],
                  )
                ],
              )),
            ],
          ),
        ));
  }
}
