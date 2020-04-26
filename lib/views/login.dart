import 'package:flutter/material.dart';
import 'package:marketgo/components/FacebookButton.dart';
import 'package:marketgo/components/GoogleButton.dart';
import 'package:email_validator/email_validator.dart';
import '../services/Auth.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final logo = Image.asset("assets/logo.png");
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;

  void loginHandler() {
    if (_formKey.currentState.validate()) {
      print("Email: $email ; Password: $password");
      try {
        Auth.authenticate(this.email, this.password);
      } catch (e) {}
    }
  }

  void registerHandler() {
    Navigator.pushNamed(context, "/register");
  }

  static const secondary = const Color(0xff0088B4);

  // @Manel what is this?
  static final underlineTextField =
      UnderlineInputBorder(borderSide: BorderSide(color: secondary));

  // Email Field
  Widget emailField() {
    return TextFormField(
      obscureText: false,
      decoration: InputDecoration(labelText: "E-mail", focusColor: secondary),
      onChanged: (value) => this.email = value,
      validator: (value) {
        if (value.isEmpty) return "Deverá inserir um email";
        if (!EmailValidator.validate(value)) return "E-mail com formato errado";
        return null;
      },
    );
  }
  // Password Field

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: "Password"),
      onChanged: (value) => {this.password = value},
      validator: (value) {
        if (value.isEmpty) return "Deverá inserir uma password";

        return null;
      },
    );
  }

  // Login Button

  Widget loginButton() {
    return FlatButton(
        color: secondary,
        child: Text("Login"),
        onPressed: loginHandler,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)));
  }

  // Register Button

  Widget registerButton() {
    return FlatButton(
      textColor: secondary,
      child: Text("Register"),
      onPressed: registerHandler,
    );
  }

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
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(height: 100.0),
                    Hero(tag: "logo", child: Center(child: logo)),
                    SizedBox(height: 50.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          emailField(),
                          SizedBox(height: 20.0),
                          passwordField()
                        ],
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[registerButton(), loginButton()],
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
