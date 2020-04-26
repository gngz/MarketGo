import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:marketgo/models/Register.dart';
import 'package:marketgo/services/Auth.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final logo = Image.asset("assets/logo.png");
  static const secondary = const Color(0xff0088B4);
  final _formKey = GlobalKey<FormState>();

  String _firstName, _lastName;
  String _email;
  String _password;

  Widget _firstNameField() {
    String fieldName = "Primeiro Nome";
    return TextFormField(
      obscureText: false,
      decoration: InputDecoration(labelText: fieldName),
      validator: (value) {
        return _textFieldValidator(value, fieldName);
      },
      onChanged: (value) {
        _firstName = value;
      },
    );
  }

  Widget _lastNameField() {
    String fieldName = "Último Nome";
    return TextFormField(
      obscureText: false,
      decoration: InputDecoration(labelText: fieldName),
      validator: (value) {
        return _textFieldValidator(value, fieldName);
      },
      onChanged: (value) {
        _lastName = value;
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      obscureText: false,
      decoration: InputDecoration(labelText: "E-mail"),
      validator: (value) => _emailValidator(value),
      onChanged: (value) {
        _email = value;
      },
    );
  }

  Widget _passwordField() {
    String fieldName = "Password";
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: fieldName),
      validator: (value) => _textFieldValidator(value, fieldName),
      onChanged: (value) {
        _password = value;
      },
    );
  }

  Widget _confirmPasswordField() {
    String fieldName = "Confirmar Password";
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: fieldName),
      validator: (value) => _confirmPasswordValidator(value),
    );
  }

  Widget _registerButton() {
    return FlatButton(
        color: secondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text("Registar"),
        ),
        onPressed: _registerHandler,
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

  String _textFieldValidator(String fieldValue, String fieldName) {
    if (fieldValue.isEmpty) return "O campo $fieldName não pode ser vazio.";

    return null;
  }

  String _emailValidator(String fieldValue) {
    if (fieldValue.isEmpty) return "O campo E-mail não pode ser vazio.";
    if (!EmailValidator.validate(fieldValue))
      return "E-mail com formato errado.";
    return null;
  }

  String _confirmPasswordValidator(String fieldValue) {
    if (fieldValue.isEmpty)
      return "O campo Confirmar Password não pode ser vazio.";
    if (fieldValue != _password)
      return "O campo Confirmar Password tem de ser igual à password.";
    return null;
  }

  void _registerHandler() {
    if (_formKey.currentState.validate()) {
      var registerDTO = new Register();

      registerDTO.firstName = _firstName;
      registerDTO.lastName = _lastName;
      registerDTO.email = _email;
      registerDTO.password = _password;

      Auth.register(registerDTO);
    }
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
                SizedBox(height: 100.0),
                Hero(tag: "logo", child: Center(child: logo)),
                SizedBox(height: 50.0),
                Form(
                    key: _formKey,
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
                          children: <Widget>[
                            _goBackButton(),
                            _registerButton()
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
